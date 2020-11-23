import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/photo.dart';

class FullPhotoDesktop extends StatefulWidget {
  final Photo photo;

  FullPhotoDesktop(this.photo);

  @override
  _FullPhotoDesktopState createState() => _FullPhotoDesktopState();
}

class _FullPhotoDesktopState extends State<FullPhotoDesktop>
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
