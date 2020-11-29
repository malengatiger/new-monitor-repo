import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/ui/media/full_photo/full_photo_desktop.dart';
import 'package:monitorlibrary/ui/media/full_photo/full_photo_mobile.dart';
import 'package:monitorlibrary/ui/media/full_photo/full_photo_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FullPhotoMain extends StatelessWidget {
  final Photo photo;
  final Project project;

  FullPhotoMain(this.photo, this.project);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: FullPhotoMobile(photo, project),
      tablet: FullPhotoTablet(photo, project),
      desktop: FullPhotoDesktop(photo, project),
    );
  }
}
