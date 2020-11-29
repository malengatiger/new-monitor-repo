import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/ui/maps/project_map_main.dart';
import 'package:page_transition/page_transition.dart';

class FullPhotoMobile extends StatefulWidget {
  final Photo photo;
  final Project project;

  FullPhotoMobile(this.photo, this.project);

  @override
  _FullPhotoMobileState createState() => _FullPhotoMobileState();
}

class _FullPhotoMobileState extends State<FullPhotoMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.photo.projectName}',
            style: Styles.whiteSmall,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: Column(
              children: [
                Text(
                  '${getFormattedDateLongWithTime(widget.photo.created, context)}',
                  style: Styles.blackBoldSmall,
                ),
                SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: widget.photo.url,
              fit: BoxFit.fill,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: Container(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              value: downloadProgress.progress))),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Positioned(
              right: 20,
              bottom: 2,
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Text('Distance from Project'),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.photo.distanceFromProjectPosition
                            .toStringAsFixed(1),
                        style: Styles.blackBoldMedium,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('metres'),
                      SizedBox(
                        width: 28,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            widget.project == null
                ? Container()
                : Positioned(
                    right: 40,
                    bottom: 28,
                    child: FloatingActionButton(
                      elevation: 8,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.map,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        pp(' 😡  😡  😡  😡  😡 Go do something, Joe!');
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.scale,
                                alignment: Alignment.bottomRight,
                                duration: Duration(seconds: 1),
                                child: ProjectMapMain(widget.project)));
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
