import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/content.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/settlement.dart';
import 'package:monitorlibrary/functions.dart';

class PhotoGallery extends StatefulWidget {
  final Project project;
  final Settlement settlement;

  PhotoGallery({this.project, this.settlement});

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  List<Content> contents = List();
  List<Image> images = List();
  String name;
  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      contents = widget.project.photoUrls;
      name = widget.project.name;
    }
    if (widget.settlement != null) {
      contents = widget.settlement.photoUrls;
      name = widget.settlement.settlementName;
    }
    if (contents.isEmpty) {
      throw Exception('Project or Settlement required, Senor!');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gallery'),
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
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 2, crossAxisSpacing: 2),
          itemCount: contents.length,
          itemBuilder: (BuildContext context, int index) {
            return CachedNetworkImage(
              imageUrl: contents.elementAt(index).url,
              fit: BoxFit.fill,
              placeholder: (context, url) => Container(height: 48, width: 48,
                  child: CircularProgressIndicator(
                    strokeWidth: 4, backgroundColor: Colors.tealAccent,
                  )),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            );
          },
        ),
        );
  }
}
