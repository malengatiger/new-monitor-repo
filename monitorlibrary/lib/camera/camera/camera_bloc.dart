import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'camera_event.dart';

part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  @override
  CameraState get initialState => InitialCameraState();

  @override
  Stream<CameraState> mapEventToState(CameraEvent event) async* {
    // TODO: Add your event logic
  }
}
