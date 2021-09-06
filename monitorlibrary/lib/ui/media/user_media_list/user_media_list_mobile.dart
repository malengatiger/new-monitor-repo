import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/ui/media/full_photo/full_photo_main.dart';
import 'package:monitorlibrary/ui/media/video/video_main.dart';
import 'package:page_transition/page_transition.dart';

import '../../../functions.dart';
import '../../../snack.dart';

class UserMediaListMobile extends StatefulWidget {
  final User user;

  UserMediaListMobile(this.user);

  @override
  _UserMediaListMobileState createState() => _UserMediaListMobileState();
}

class _UserMediaListMobileState extends State<UserMediaListMobile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  StreamSubscription<List<Photo>>? photoStreamSubscription;
  StreamSubscription<List<Video>>? videoStreamSubscription;
  var _photos = <Photo>[];
  var _videos = <Video>[];

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
    try {
      _photos =
          await monitorBloc.getUserProjectPhotos(userId: widget.user.userId!, forceRefresh: true);
      _videos =
          await monitorBloc.getUserProjectVideos(userId: widget.user.userId!, forceRefresh: true);
      _processMedia();
    } catch (e) {
      print(e);
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key, message: 'Data refresh failed: $e');
    }
    setState(() {
      isBusy = false;
    });
  }

  var _key = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    _controller.dispose();
    photoStreamSubscription!.cancel();
    videoStreamSubscription!.cancel();
    super.dispose();
  }

  void _processMedia() {
    suitcases.clear();
    _photos.forEach((element) {
      var sc = Suitcase(photo: element, date: element.created!);
      suitcases.add(sc);
    });
    _videos.forEach((element) {
      var sc = Suitcase(video: element, date: element.created!);
      suitcases.add(sc);
    });
    if (suitcases.isNotEmpty) {
      suitcases.sort((a, b) => b.date!.compareTo(a.date!));
      latest = getFormattedDateShortest(suitcases.first.date!, context);
      earliest = getFormattedDateShortest(suitcases.last.date!, context);
    }
  }

  String? latest, earliest;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(
            widget.user.name!,
            style: Styles.whiteBoldSmall,
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh,
                size: 20,
              ),
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
                                strokeWidth: 8,
                                backgroundColor: Colors.black,
                              ),
                            )
                          : Container(),
                      SizedBox(
                        width: 28,
                      ),
                      Text(
                        'Digital Project Monitor',
                        style: Styles.whiteSmall,
                      ),
                      SizedBox(
                        width: 64,
                      ),
                      Text(
                        '${suitcases.length}',
                        style: Styles.blackBoldSmall,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 28,
                  // ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       'Latest:',
                  //       style: Styles.blackTiny,
                  //     ),
                  //     SizedBox(
                  //       width: 8,
                  //     ),
                  //     Text(
                  //       latest == null ? 'some date' : latest,
                  //       style: Styles.whiteBoldSmall,
                  //     ),
                  //     SizedBox(
                  //       width: 28,
                  //     ),
                  //     Text(
                  //       'Earliest:',
                  //       style: Styles.blackTiny,
                  //     ),
                  //     SizedBox(
                  //       width: 8,
                  //     ),
                  //     Text(
                  //       earliest == null ? 'some date' : earliest,
                  //       style: Styles.whiteBoldSmall,
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    height: 12,
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
                        'No User Media found',
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
                                  suitcase.photo!.thumbnailUrl!,
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

  var suitcases = <Suitcase>[];

  void _onMediaTapped(Suitcase suitcase) {
    if (suitcase.video != null) {
      pp('🦠 🦠 🦠 _onMediaTapped: Play video from 🦠 ${suitcase.video!.url} 🦠');
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.bottomRight,
              duration: Duration(seconds: 1),
              child: VideoMain(suitcase.video!)));
    } else {
      pp(' 🍎 🍎 🍎 _onMediaTapped: show full image from 🍎 ${suitcase.photo!.url!} 🍎');
      // Navigator.push(
      //     context,
      //     PageTransition(
      //         type: PageTransitionType.scale,
      //         alignment: Alignment.bottomRight,
      //         duration: Duration(seconds: 1),
      //         child: FullPhotoMain(suitcase.photo, )));
    }
  }
}

class Suitcase {
  Photo? photo;
  Video? video;
  String? date;

  Suitcase({this.photo, this.video, this.date});
}
