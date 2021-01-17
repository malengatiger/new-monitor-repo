import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';

import '../functions.dart';

class SpecialSnack {
  static showUserSnackbar(
      {@required GlobalKey<ScaffoldState> scaffoldKey,
      @required User user,
      @required SpecialSnackListener listener,
      int durationMinutes}) {
    if (scaffoldKey.currentState == null) {
      pp('SpecialSnack.showUserSnackbar --- currentState is NULL, quit ..');
      return;
    }
    ScaffoldMessenger.of(scaffoldKey.currentState.context)
        .removeCurrentSnackBar();
    ScaffoldMessenger.of(scaffoldKey.currentState.context)
        .showSnackBar(SnackBar(
      content: Container(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Text(
                '${user.name}',
                style: Styles.blackBoldSmall,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                'User added to organization',
                style: Styles.blackTiny,
              ),
              Text(
                '${user.userType}',
                style: Styles.blackTiny,
              ),
              Text(
                '${getFormattedDateShortWithTime(user.created, scaffoldKey.currentContext)}',
                style: Styles.blackTiny,
              ),
              SizedBox(
                height: 12,
              ),
              RaisedButton(
                  elevation: 8,
                  color: Theme.of(scaffoldKey.currentContext).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Close',
                      style: Styles.whiteTiny,
                    ),
                  ),
                  onPressed: () {
                    listener.onClose();
                  })
            ],
          ),
        ),
      ),
      duration:
          Duration(minutes: durationMinutes == null ? 1 : durationMinutes),
      backgroundColor: Colors.brown[100],
    ));
  }

  static showProjectSnackbar(
      {@required GlobalKey<ScaffoldState> scaffoldKey,
      @required Project project,
      Color textColor,
      Color backgroundColor,
      @required SpecialSnackListener listener,
      int durationMinutes}) {
    if (scaffoldKey.currentState == null) {
      pp('SpecialSnack.showProjectSnackbar --- currentState is NULL, quit ..');
      return;
    }
    ScaffoldMessenger.of(scaffoldKey.currentState.context)
        .removeCurrentSnackBar();
    ScaffoldMessenger.of(scaffoldKey.currentState.context)
        .showSnackBar(SnackBar(
      content: Container(
        height: 164,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(
                height: 4,
              ),
              Text(
                'Project added to organization',
                style: Styles.blackTiny,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                '${project.name}',
                style: Styles.blackBoldSmall,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                '${project.description}',
                style: Styles.blackTiny,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                '${getFormattedDateShortWithTime(project.created, scaffoldKey.currentContext)}',
                style: Styles.blackTiny,
              ),
              SizedBox(
                height: 4,
              ),
              RaisedButton(
                  elevation: 8,
                  color: Theme.of(scaffoldKey.currentContext).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Close',
                      style: Styles.whiteTiny,
                    ),
                  ),
                  onPressed: () {
                    listener.onClose();
                  })
            ],
          ),
        ),
      ),
      duration:
          Duration(minutes: durationMinutes == null ? 1 : durationMinutes),
      backgroundColor: Colors.brown[100],
    ));
  }

  static showPhotoSnackbar(
      {@required GlobalKey<ScaffoldState> scaffoldKey,
      @required Photo photo,
      @required SpecialSnackListener listener,
      int durationMinutes}) {
    if (scaffoldKey.currentState == null) {
      pp('SpecialSnack.showPhotoSnackbar --- currentState is NULL, quit ..');
      return;
    }
    ScaffoldMessenger.of(scaffoldKey.currentState.context)
        .removeCurrentSnackBar();
    ScaffoldMessenger.of(scaffoldKey.currentState.context)
        .showSnackBar(SnackBar(
      content: Container(
        height: 300,
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Image.network(
                  photo.thumbnailUrl,
                  width: 152,
                  height: 152,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '${photo.userName} : ${getFormattedDateShortWithTime(photo.created, scaffoldKey.currentContext)}',
                  style: Styles.blackTiny,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '${photo.projectName}',
                  style: Styles.blueBoldSmall,
                ),
                SizedBox(
                  height: 4,
                ),
                RaisedButton(
                    elevation: 8,
                    color: Theme.of(scaffoldKey.currentContext).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Close',
                        style: Styles.whiteTiny,
                      ),
                    ),
                    onPressed: () {
                      listener.onClose();
                    })
              ],
            ),
          ),
        ),
      ),
      duration:
          Duration(minutes: durationMinutes == null ? 1 : durationMinutes),
      backgroundColor: Colors.brown[100],
    ));
  }

  static showVideoSnackbar(
      {@required GlobalKey<ScaffoldState> scaffoldKey,
      @required Video video,
      @required SpecialSnackListener listener,
      int durationMinutes}) {
    if (scaffoldKey.currentState == null) {
      pp('SpecialSnack.showVideoSnackbar --- currentState is NULL, quit ..');
      return;
    }

    ScaffoldMessenger.of(scaffoldKey.currentState.context)
        .removeCurrentSnackBar();
    ScaffoldMessenger.of(scaffoldKey.currentState.context)
        .showSnackBar(SnackBar(
      content: Container(
        height: 140,
        color: Colors.brown[100],
        child: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            Text(
              'Project Video added OK',
              style: Styles.blackBoldSmall,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '${getFormattedDateShortWithTime(video.created, scaffoldKey.currentContext)}',
              style: Styles.blackTiny,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              '${video.userName}',
              style: Styles.blackBoldSmall,
            ),
            SizedBox(
              height: 4,
            ),
            RaisedButton(
                elevation: 4,
                color: Theme.of(scaffoldKey.currentState.context).primaryColor,
                onPressed: () {
                  listener.onClose();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Close',
                    style: Styles.whiteTiny,
                  ),
                )),
          ],
        ),
      ),
      duration:
          Duration(minutes: durationMinutes == null ? 1 : durationMinutes),
      backgroundColor: Colors.brown[100],
      // action: SnackBarAction(
      //   label: 'Close',
      //   onPressed: () {
      //     listener.onClose();
      //   },
      // ),
    ));
  }

  static showMessageSnackbar(
      {@required GlobalKey<ScaffoldState> scaffoldKey,
      @required OrgMessage message,
      @required SpecialSnackListener listener,
      int durationMinutes}) {
    if (scaffoldKey.currentState == null) {
      pp('SpecialSnack.showVideoSnackbar --- currentState is NULL, quit ..');
      return;
    }

    var height = 300;
    ScaffoldMessenger.of(scaffoldKey.currentState.context)
        .removeCurrentSnackBar();
    ScaffoldMessenger.of(scaffoldKey.currentState.context)
        .showSnackBar(SnackBar(
      content: Container(
        height: 300,
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(scaffoldKey.currentState.context)
                                .primaryColor,
                          ),
                          onPressed: () {
                            listener.onClose();
                          })
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          '${message.message}',
                          style: Styles.blackBoldSmall,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 52,
                        child: Text(
                          'From: ',
                          style: Styles.greyLabelTiny,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${message.adminName}',
                        style: Styles.blackBoldSmall,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 52,
                        child: Text(
                          'To: ',
                          style: Styles.greyLabelTiny,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${message.name}',
                        style: Styles.blackBoldSmall,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Project: ',
                        style: Styles.greyLabelTiny,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${message.projectName}',
                        style: Styles.blueBoldSmall,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Text(
                        'Frequency: ',
                        style: Styles.greyLabelTiny,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${message.frequency}',
                        style: Styles.pinkBoldSmall,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        'Sent: ',
                        style: Styles.greyLabelTiny,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${getFormattedDateShortWithTime(message.created, scaffoldKey.currentContext)}',
                        style: Styles.blackTiny,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      duration:
          Duration(minutes: durationMinutes == null ? 1 : durationMinutes),
      backgroundColor: Colors.brown[100],
    ));
  }
}

abstract class SpecialSnackListener {
  onClose();
}
