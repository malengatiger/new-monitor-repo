import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';

import '../../functions.dart';

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

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _listen();
  }

  void _listen() async {
    pp('🔆 🔆 🔆 🔆 💜 💜 💜 Listening to streams from monitorBloc ....');

    photoStreamSubscription = monitorBloc.photoStream.listen((value) {
      pp('🔆 🔆 🔆 💜 💜 _MediaListMobileState: Photos from stream controller: 💙 ${value.length}');
      _photos = value;
      _processMedia();
      setState(() {});
    });
    videoStreamSubscription = monitorBloc.videoStream.listen((value) {
      pp('🔆 🔆 🔆 💜 💜 _MediaListMobileState: Videos from stream controller: 🏈 ${value.length}');
      _videos = value;
      _processMedia();
      setState(() {});
    });
    _refresh();
  }

  Future<void> _refresh() async {
    pp('🔆 🔆 🔆 💜 💜 _MediaListMobileState: _refresh ...');
    setState(() {
      isBusy = true;
    });
    _photos =
        await monitorBloc.getProjectPhotos(projectId: widget.project.projectId);
    _videos =
        await monitorBloc.getProjectVideos(projectId: widget.project.projectId);
    _processMedia();
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
    suitcases.sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(
            widget.project.name,
            style: Styles.whiteBoldSmall,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _refresh,
            )
          ],
          bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
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
                        'Visual Project Monitoring',
                        style: Styles.whiteBoldSmall,
                      ),
                      SizedBox(
                        width: 48,
                      ),
                      Text(
                        '${suitcases.length}',
                        style: Styles.blackBoldMedium,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(60),
          ),
        ),
        backgroundColor: Colors.brown[100],
        body: Stack(
          children: [
            suitcases.isEmpty
                ? Center(
                    child: Container(
                      child: Text(
                        'No media found',
                        style: Styles.blackBoldMedium,
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
      pp('🦠 🦠 🦠 _onMediaTapped: Play video from ${suitcase.video.url}');
    } else {
      pp(' 🍎 🍎 🍎 _onMediaTapped:  show full image  from ${suitcase.photo.url}');
    }
  }
}

class Suitcase {
  Photo photo;
  Video video;
  String date;

  Suitcase({this.photo, this.video, this.date});
}
