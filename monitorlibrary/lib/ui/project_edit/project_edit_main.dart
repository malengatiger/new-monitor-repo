import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/ui/project_edit/project_edit_desktop.dart';
import 'package:monitorlibrary/ui/project_edit/project_edit_mobile.dart';
import 'package:monitorlibrary/ui/project_edit/project_edit_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ProjectEditMain extends StatelessWidget {
  final Project? project;

  ProjectEditMain(this.project);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: ProjectEditMobile(project),
      tablet: ProjectEditTablet(project),
      desktop: ProjectEditDesktop(project),
    );
  }
}
