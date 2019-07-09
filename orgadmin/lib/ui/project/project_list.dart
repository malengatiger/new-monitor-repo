import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:orgadmin/admin_bloc.dart';

abstract class ProjectListener {
  onProjectSelected(Project project);
}
class ProjectList extends StatefulWidget {
  final ProjectListener listener;

  ProjectList(this.listener);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  User user;
  bool isBusy = false;
  List<Project> projects =  [];
  GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    user = await Prefs.getUser();
    setState(() {
      isBusy = true;
    });
    projects = await adminBloc.findProjectsByOrganization(user.organizationId);

    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project List'),
        elevation: 8,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:20.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(user == null? 'Organization': user.organizationName,
                        style: Styles.whiteBoldMedium,  overflow: TextOverflow.clip,),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Column(
                      children: <Widget>[
                        Text('${projects.length}', style: Styles.blackBoldLarge,),
                        SizedBox(height: 4,),
                        Text('Projects', style: Styles.whiteSmall,),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24,),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.brown[100],
      body: isBusy? Center(
        child: Container(
          child: CircularProgressIndicator(
            strokeWidth: 24,
            backgroundColor: Colors.yellow,
          ),
        ),
      ) : ListView.builder(
        itemCount: projects.length,
        itemBuilder: (BuildContext context, int index) {
        var  p =  projects.elementAt(index);
        return  Padding(
          padding: const EdgeInsets.only(left:8.0, right: 8, top: 8),
          child: GestureDetector(
            onTap: () {
              widget.listener.onProjectSelected(p);
            },
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.only(left:12.0, right: 12, top: 8),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.apps, color: getRandomColor(),),
                        SizedBox(width: 8,),
                        Expanded(child: Container(child: Text(p.name, style: Styles.blackBoldMedium, overflow: TextOverflow.clip))),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 32,),
                        Expanded(child: Container(child: Text(p.description, style: Styles.blackSmall, overflow: TextOverflow.clip))),
                      ],
                    ),
                    SizedBox(height: 16,)
                  ],
                ),
              ),
            ),
          ),
        );
      },),
    );
  }
}
