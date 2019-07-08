import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/data/settlement.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/slide_right.dart';
import 'package:orgadmin/admin_bloc.dart';
import 'package:orgadmin/ui/settlement/settlement_detail.dart';
import 'package:orgadmin/ui/settlement/settlement_editor.dart';

class SettlementList extends StatefulWidget {
  @override
  _SettlementListState createState() => _SettlementListState();
}

class _SettlementListState extends State<SettlementList> {
  Country country;
  List<Settlement> list = List();
  List<Country> countries = List();
  GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    _getSettlements();
  }

  _getSettlements() async {
    setState(() {
      isBusy = true;
    });
    country = await Prefs.getCountry();
    if (country == null) {
      countries = await adminBloc.getCountries();
      if (countries.length == 1) {
        country = countries.elementAt(0);
      }
    }
    if (country != null) {
      await adminBloc.findSettlementsByCountry(country.countryId);
    }
    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: adminBloc.settlementStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          list = snapshot.data;
          print(
              ' 🛎 settlements received fromsnapshot:  🛎 🛎 ${list.length}  🛎 🛎');
        }

        return Scaffold(
          key: _key,
          appBar: AppBar(
            title: Text('Settlements'),
            backgroundColor: Colors.indigo[400],
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _navigateToEditor,
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: _getSettlements,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Total Settlements",
                          style: Styles.whiteSmall,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          '${list.length}',
                          style: Styles.blackBoldLarge,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Colors.brown[100],
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
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      var sett = list.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, SlideRightRoute(
                            widget: SettlementDetail(sett)
                          ));
                        },
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.apps, color: getRandomColor(),),
                                  title: Text(sett.settlementName, style: Styles.blackBoldSmall,),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }

  void _navigateToEditor() {
    Navigator.push(
        context,
        SlideRightRoute(
          widget: SettlementEditor(),
        ));
  }
}
