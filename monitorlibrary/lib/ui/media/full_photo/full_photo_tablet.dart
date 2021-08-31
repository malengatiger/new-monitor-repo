import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';

class FullPhotoTablet extends StatefulWidget {
  final Photo photo;
  final Project project;

  FullPhotoTablet(this.photo, this.project);

  @override
  _FullPhotoTabletState createState() => _FullPhotoTabletState();
}

class _FullPhotoTabletState extends State<FullPhotoTablet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
