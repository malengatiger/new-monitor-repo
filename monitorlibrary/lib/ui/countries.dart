import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/functions.dart';

class CountriesDropDown extends StatefulWidget {
  final CountryListener countryListener;

  CountriesDropDown(this.countryListener);

  @override
  _CountriesDropDownState createState() => _CountriesDropDownState();
}

class _CountriesDropDownState extends State<CountriesDropDown> {
  @override
  void initState() {
    super.initState();
    _getCountries();
  }

  List<Country> _countries = List();
  _getCountries() async {
    _countries = await DataAPI.getCountries();
    pp('🦠 🦠 🦠 getCountries .....🦠 ${_countries.length} found');
    _countries.forEach((c) {
      var item = DropdownMenuItem<Country>(
        child: ListTile(
          leading: Icon(Icons.local_library),
          title: Text('${c.name}'),
        ),
      );
      items.add(item);
      prettyPrint(c.toJson(), '🏀🏀 Country ...  🏀🏀');
    });
    pp('🧩 🧩  setting state ');
    setState(() {});
  }

  List<DropdownMenuItem<Country>> items = List();

  @override
  Widget build(BuildContext context) {
    pp('👽 👽 build starting ...  🐲 🐲 🐲 🐲 ');
    if (items.isEmpty) {
      return Container();
    }
    return DropdownButton<Country>(
      items: items,
      onChanged: _onDropDownChanged,
    );
  }

  void _onDropDownChanged(Country value) {
    pp('🔆🔆🔆 _onDropDownChanged ... ');
    widget.countryListener.onCountrySelected(value);
  }
}

abstract class CountryListener {
  onCountrySelected(Country country);
}
