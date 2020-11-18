import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/bloc/admin_bloc.dart';
import 'package:monitorlibrary/data/community.dart';
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/snack.dart';

abstract class CommunityListener {
  onSettlementSelected(Community settlement);
}

class CommunityList extends StatefulWidget {
  final CommunityListener listener;

  CommunityList(this.listener);

  @override
  _CommunityListState createState() => _CommunityListState();
}

class _CommunityListState extends State<CommunityList> {
  Country country;
  List<Community> list = List();
  List<Country> countries = List();
  GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    _getCommunities();
  }

  _getCommunities() async {
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
      try {
        await adminBloc.findCommunitiesByCountry(country.countryId);
      } catch (e) {
        pp('👿 error getting community list ... 👿👿👿👿 does fucking the snackBar show?');
        AppSnackbar.showErrorSnackbar(
            scaffoldKey: _key, message: '😡 😡 Query failed, what now, Boss?');
      }
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
          pp(' 🛎 settlements received from snapshot:  🛎 🛎 ${list.length}  🛎 🛎');
        }

        return Scaffold(
          key: _key,
          appBar: AppBar(
            title: Text('Settlements'),
            backgroundColor: Colors.indigo[400],
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: _getCommunities,
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
                          widget.listener.onSettlementSelected(sett);
                        },
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(
                                    Icons.apps,
                                    color: getRandomColor(),
                                  ),
                                  title: Text(
                                    sett.name,
                                    style: Styles.blackBoldSmall,
                                  ),
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
}
