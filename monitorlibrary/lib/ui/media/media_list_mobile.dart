import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/ui/media/full_photo/full_photo_main.dart';
import 'package:monitorlibrary/ui/media/video/video_main.dart';
import 'package:monitorlibrary/ui/project_monitor/project_monitor_main.dart';
import 'package:page_transition/page_transition.dart';

import '../../functions.dart';
import '../../snack.dart';

class MediaListMobile extends StatefulWidget {
  final Project project;

  MediaListMobile(this.project);

  @override
  _MediaListMobileState createState() => _MediaListMobileState();
}

class _MediaListMobileState extends State<MediaListMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  StreamSubscription<List<Photo>> photoStreamSubscription;
  StreamSubscription<List<Video>> videoStreamSubscription;
  var _photos = List<Photo>();
  var _videos = List<Video>();
  User user;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _listen();
  }

  void _listen() async {
    pp('🔆 🔆 🔆 🔆 💜 💜 💜 Listening to streams from monitorBloc ....');
    user = await Prefs.getUser();

    photoStreamSubscription = monitorBloc.projectPhotoStream.listen((value) {
      pp('🔆 🔆 🔆 💜 💜 _MediaListMobileState: Photos from stream controller: 💙 ${value.length}');
      _photos = value;
      _processMedia();
      if (mounted) {
        setState(() {});
      }
    });
    videoStreamSubscription = monitorBloc.projectVideoStream.listen((value) {
      pp('🔆 🔆 🔆 💜 💜 _MediaListMobileState: Videos from stream controller: 🏈 ${value.length}');
      _videos = value;
      _processMedia();
      if (mounted) {
        setState(() {});
      }
    });

    if (mounted) {
      _refresh(false);
    }
  }

  Future<void> _refresh(bool forceRefresh) async {
    pp('🔆 🔆 🔆 💜 💜 _MediaListMobileState: _refresh ...');
    setState(() {
      isBusy = true;
    });
    try {
      await monitorBloc.refreshProjectData(
          projectId: widget.project.projectId, forceRefresh: forceRefresh);
      _processMedia();
    } catch (e) {
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key, message: 'Data refresh failed');
    }
    setState(() {
      isBusy = false;
    });
  }

  var _key = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    _controller.dispose();
    photoStreamSubscription.cancel();
    videoStreamSubscription.cancel();
    super.dispose();
  }

  void _processMedia() {
    suitcases.clear();
    _photos.forEach((element) {
      var sc = Suitcase(photo: element, date: element.created);
      suitcases.add(sc);
    });
    _videos.forEach((element) {
      var sc = Suitcase(video: element, date: element.created);
      suitcases.add(sc);
    });
    if (suitcases.isNotEmpty) {
      suitcases.sort((a, b) => b.date.compareTo(a.date));
      latest = getFormattedDateShortest(suitcases.first.date, context);
      earliest = getFormattedDateShortest(suitcases.last.date, context);
    }
  }

  String latest, earliest;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Container(),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _refresh(true);
              },
            ),
            IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: _navigateToMonitor,
            )
          ],
          bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    widget.project == null ? '' : widget.project.name,
                    style: Styles.whiteBoldSmall,
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      isBusy
                          ? Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                backgroundColor: Colors.black,
                              ),
                            )
                          : Container(),
                      SizedBox(
                        width: 28,
                      ),
                      Text(
                        'Photos & Videos',
                        style: Styles.blackTiny,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${suitcases.length}',
                        style: Styles.whiteBoldSmall,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  suitcases.isEmpty
                      ? Container()
                      : Row(
                          children: [
                            Text(
                              'Latest:',
                              style: Styles.blackTiny,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              latest == null ? 'some date' : latest,
                              style: Styles.whiteBoldSmall,
                            ),
                            SizedBox(
                              width: 28,
                            ),
                            Text(
                              'Earliest:',
                              style: Styles.blackTiny,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              earliest == null ? 'some date' : earliest,
                              style: Styles.whiteBoldSmall,
                            )
                          ],
                        ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(120),
          ),
        ),
        backgroundColor: Colors.brown[100],
        body: Stack(
          children: [
            suitcases.isEmpty
                ? Center(
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 120,
                          ),
                          Text(
                            'No media found',
                            style: Styles.blackBoldMedium,
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          Card(
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: IconButton(
                                  icon: Icon(Icons.add_a_photo),
                                  onPressed: _navigateToMonitor),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1),
                    itemCount: suitcases.length,
                    itemBuilder: (BuildContext context, int index) {
                      var suitcase = suitcases.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          _onMediaTapped(suitcase);
                        },
                        child: Container(
                          height: 120,
                          width: 120,
                          child: suitcase.video != null
                              ? Image.asset(
                                  'assets/video3.png',
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.fill,
                                )
                              : Image.network(
                                  suitcase.photo.thumbnailUrl,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  var suitcases = List<Suitcase>();

  void _onMediaTapped(Suitcase suitcase) {
    if (suitcase.video != null) {
      pp('🦠 🦠 🦠 _onMediaTapped: Play video from 🦠 ${suitcase.video.url} 🦠');
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.bottomRight,
              duration: Duration(seconds: 1),
              child: VideoMain(suitcase.video)));
    } else {
      pp(' 🍎 🍎 🍎 _onMediaTapped: show full image from 🍎 ${suitcase.photo.url} 🍎');
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.bottomRight,
              duration: Duration(seconds: 1),
              child: FullPhotoMain(suitcase.photo, widget.project)));
    }
  }

  void _navigateToMonitor() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(milliseconds: 1500),
            child: ProjectMonitorMain(widget.project)));
  }
}

class Suitcase {
  Photo photo;
  Video video;
  String date;

  Suitcase({this.photo, this.video, this.date});
}
