import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/ui/media/user_media_list/user_media_list_desktop.dart';
import 'package:monitorlibrary/ui/media/user_media_list/user_media_list_mobile.dart';
import 'package:monitorlibrary/ui/media/user_media_list/user_media_list_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class UserMediaListMain extends StatefulWidget {
  final User user;

  UserMediaListMain(this.user);

  @override
  _UserMediaListMainState createState() => _UserMediaListMainState();
}

class _UserMediaListMainState extends State<UserMediaListMain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var isBusy = false;
  User? user;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getMedia();
  }

  void _getMedia() async {
    setState(() {
      isBusy = true;
    });
    user = widget.user;
    if (user == null) {
      user = await Prefs.getUser();
    }

    pp('MediaListMain: 💜 💜 💜 getting media for ${user!.name}');
    await monitorBloc.getUserProjectPhotos(userId: user!.userId!, forceRefresh: true);
    await monitorBloc.getUserProjectVideos(userId: user!.userId!, forceRefresh: true);
    setState(() {
      isBusy = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isBusy
        ? SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Loading project media ...',
                  style: Styles.whiteSmall,
                ),
              ),
              body: Center(
                child: Container(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
            ),
          )
        : ScreenTypeLayout(
            mobile: UserMediaListMobile(user!),
            tablet: UserMediaListTablet(user!),
            desktop: UserMediaListDesktop(user!),
          );
  }
}
