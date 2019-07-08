import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/data/settlement.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/snack.dart';
import 'package:orgadmin/admin_bloc.dart';

import '../countries.dart';


class SettlementEditor extends StatefulWidget {
  @override
  _SettlementEditorState createState() => _SettlementEditorState();
}

class _SettlementEditorState extends State<SettlementEditor>
    implements CountryListener, SnackBarListener {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController nameCntrl = TextEditingController();
  TextEditingController emailCntrl = TextEditingController();
  TextEditingController cellCntrl = TextEditingController();
  TextEditingController popCntrl = TextEditingController();
  bool isBusy = false;
  AdminBloc bloc = AdminBloc();
  User user;
  List<Country> countries = List();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    user = await Prefs.getUser();
    countries = await bloc.getCountries();
    if (countries.length == 1) {
      _country = countries.elementAt(0);
      await Prefs.saveCountry(_country);
      prettyPrint(_country.toJson(), '💙 💙 💙 country.  check country id');
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Settlement Editor'),
        backgroundColor: Colors.indigo[300],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Column(
            children: <Widget>[
              Text(user == null? '': user.organizationName, style: Styles.blackBoldMedium,),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      body: isBusy
          ? Center(
              child: Container(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 28,
                  backgroundColor: Colors.pink,
                ),
              ),
            )
          : ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: nameCntrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Enter settlement name',
                    labelText: 'Settlement Name',
                  ),
                  onChanged: _onNameChanged,
                ),
                SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: emailCntrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter email address',
                    labelText: 'Email',
                  ),
                  onChanged: _onEmailChanged,
                ),
                SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: cellCntrl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter cellphone number',
                    labelText: 'Cellphone',
                  ),
                  onChanged: _onCellChanged,
                ),
                SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: popCntrl,
                  keyboardType: TextInputType.numberWithOptions(signed: false),
                  decoration: InputDecoration(
                    hintText: 'Enter population',
                    labelText: 'Population',
                  ),
                  onChanged: _onPopChanged,
                ),
                SizedBox(
                  height: 20,
                ),
                _country == null? Container() : Text('${_country.name}', style: Styles.blackBoldLarge,),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  elevation: 8,
                  color: Colors.pink[700],
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Text('Submit Settlement', style: Styles.whiteSmall,),
                  ),
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Country _country;
  @override
  onCountrySelected(Country country) {
    _country = country;
    setState(() {});
    return null;
  }

  var name;
  void _onNameChanged(String value) {
    name = value;
  }

  var email;
  void _onEmailChanged(String value) {
    email = value;
  }

  var cell;
  void _onCellChanged(String value) {
    cell = value;
  }

  int pop = 0;
  void _onPopChanged(String value) {
    pop = int.parse(value);
  }

  void _submit() async {
    setState(() {
      isBusy = true;
    });

    try {
      assert(_country != null);
      var sett = Settlement(
        settlementName: name,
        email: email,
        countryId: _country.countryId,
        countryName: _country.name,
        population: pop,
      );
      await bloc.addSettlement(sett);
      setState(() {
        isBusy = false;
      });
      AppSnackbar.showSnackbar(
          scaffoldKey: _key,
          message: 'Settlement added',
          textColor: Colors.lightGreen,
          backgroundColor: Colors.black);
    } catch (e) {
      setState(() {
        isBusy = false;
      });
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key,
          message: e.message,
          actionLabel: 'Error',
          listener: this);
    }
  }

  @override
  onActionPressed(int action) {
    // TODO: implement onActionPressed
    return null;
  }
}
