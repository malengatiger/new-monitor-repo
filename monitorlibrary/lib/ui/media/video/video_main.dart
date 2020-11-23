import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/ui/media/video/video_desktop.dart';
import 'package:monitorlibrary/ui/media/video/video_mobile.dart';
import 'package:monitorlibrary/ui/media/video/video_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class VideoMain extends StatelessWidget {
  final Video video;

  VideoMain(this.video);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: VideoMobile(video),
      tablet: VideoTablet(video),
      desktop: VideoDesktop(video),
    );
  }
}
