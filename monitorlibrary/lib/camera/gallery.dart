import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:monitorlibrary/camera/camera_ui.dart';
import 'package:monitorlibrary/data/community.dart';
import 'package:monitorlibrary/data/photo.dart' as p;
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:page_transition/page_transition.dart';

class PhotoGallery extends StatefulWidget {
  final Project project;
  final Community community;

  PhotoGallery({this.project, this.community});

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  List<p.Photo> contents = List();
  List<Image> images = List();
  String name;
  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      contents = widget.project.photos;
      name = widget.project.name;
    }
    if (widget.community != null) {
      contents = widget.community.photoUrls;
      name = widget.community.name;
    }
    if (widget.project == null) {
      throw Exception('Project or Community required, Senor!');
    }
    _downloadImages();
  }

  _downloadImages() async {
    for (var content in contents) {
      var image = Image.network(
        content.url,
        fit: BoxFit.fill,
      );
      setState(() {
        images.add(image);
      });
    }
  }

  _takePicture() {
    pp('🍊 🍊 🍊 Take a picture, Boss! 🍊');
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: CameraMain(
              project: widget.project,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Project Photos',
          style: Styles.whiteSmall,
        ),
        actions: [IconButton(icon: Icon(Icons.add), onPressed: _takePicture)],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Column(
            children: <Widget>[
              Text(
                name,
                style: Styles.whiteBoldMedium,
                overflow: TextOverflow.clip,
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 2, crossAxisSpacing: 2),
        itemCount: contents.length,
        itemBuilder: (BuildContext context, int index) {
          return CachedNetworkImage(
            imageUrl: contents.elementAt(index).url,
            fit: BoxFit.fill,
            placeholder: (context, url) => Container(
                height: 48,
                width: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  backgroundColor: Colors.tealAccent,
                )),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          );
        },
      ),
    );
  }
}
