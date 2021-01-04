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
      Color textColor,
      Color backgroundColor,
      @required SpecialSnackListener listener,
      int durationMinutes}) {
    if (scaffoldKey.currentState == null) {
      pp('SpecialSnack.showUserSnackbar --- currentState is NULL, quit ..');
      return;
    }
    scaffoldKey.currentState.removeCurrentSnackBar();

    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Container(
        height: 100,
        child: Column(
          children: [
            Text(
              '${user.name}',
              style: Styles.whiteBoldSmall,
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              'User added to organization',
              style: Styles.whiteTiny,
            ),
            Text(
              '${user.userType}',
              style: Styles.blackTiny,
            ),
            Text(
              '${getFormattedDateShortWithTime(user.created, scaffoldKey.currentContext)}',
              style: Styles.blackTiny,
            ),
          ],
        ),
      ),
      duration:
          Duration(minutes: durationMinutes == null ? 1 : durationMinutes),
      backgroundColor: backgroundColor,
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          listener.onClose();
        },
      ),
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
    scaffoldKey.currentState.removeCurrentSnackBar();

    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Container(
        height: 100,
        child: Column(
          children: [
            Text(
              '${project.name}',
              style: Styles.whiteBoldSmall,
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              'Project added to organization',
              style: Styles.whiteTiny,
            ),
            Text(
              '${project.description}',
              style: Styles.whiteTiny,
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              '${getFormattedDateShortWithTime(project.created, scaffoldKey.currentContext)}',
              style: Styles.blackTiny,
            ),
            SizedBox(
              height: 2,
            ),
          ],
        ),
      ),
      duration:
          Duration(minutes: durationMinutes == null ? 1 : durationMinutes),
      backgroundColor: backgroundColor,
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          listener.onClose();
        },
      ),
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
    scaffoldKey.currentState.removeCurrentSnackBar();

    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Container(
        height: 260,
        child: Column(
          children: [
            Image.network(
              photo.thumbnailUrl,
              width: 160,
              height: 160,
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
              height: 2,
            ),
            RaisedButton(
                elevation: 8,
                color: Theme.of(scaffoldKey.currentContext).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Close'),
                ),
                onPressed: () {
                  listener.onClose();
                })
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

  static showVideoSnackbar(
      {@required GlobalKey<ScaffoldState> scaffoldKey,
      @required Video video,
      @required SpecialSnackListener listener,
      int durationMinutes}) {
    if (scaffoldKey.currentState == null) {
      pp('SpecialSnack.showVideoSnackbar --- currentState is NULL, quit ..');
      return;
    }
    scaffoldKey.currentState.removeCurrentSnackBar();

    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Container(
        height: 140,
        color: Colors.brown[100],
        child: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            Text(
              'Organization Video added OK',
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
            FlatButton(
                onPressed: () {
                  listener.onClose();
                },
                child: Text(
                  'Close',
                  style: Styles.blueSmall,
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
      Color textColor,
      Color backgroundColor,
      @required SpecialSnackListener listener,
      int durationMinutes}) {
    if (scaffoldKey.currentState == null) {
      pp('SpecialSnack.showVideoSnackbar --- currentState is NULL, quit ..');
      return;
    }
    scaffoldKey.currentState.removeCurrentSnackBar();

    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Container(
        height: 100,
        child: Column(
          children: [
            Text('${message.message}'),
            SizedBox(
              height: 2,
            ),
            Text(
              '${getFormattedDateShortWithTime(message.created, scaffoldKey.currentContext)}',
              style: Styles.blackTiny,
            ),
          ],
        ),
      ),
      duration:
          Duration(minutes: durationMinutes == null ? 1 : durationMinutes),
      backgroundColor: backgroundColor,
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          listener.onClose();
        },
      ),
    ));
  }
}

abstract class SpecialSnackListener {
  onClose();
}
