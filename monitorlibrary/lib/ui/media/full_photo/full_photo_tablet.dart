import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/photo.dart';

class FullPhotoTablet extends StatefulWidget {
  final Photo photo;

  FullPhotoTablet(this.photo);

  @override
  _FullPhotoTabletState createState() => _FullPhotoTabletState();
}

class _FullPhotoTabletState extends State<FullPhotoTablet>
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
    return Container();
  }
}
