import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_call_app/src/config/services/call_service.dart';
import 'package:video_call_app/src/data/models/video_call_data.dart';

part 'video_call_event.dart';

part 'video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final CallService _callService;
  late final VoidCallback _dataListener;

  RtcEngine get rtcEngine => _callService.engine;

  VideoCallBloc({required CallService callService})
    : _callService = callService,
      super(VideoCallInitial()) {
    on<VideoCallInitialize>(_onInitialize);
    on<VideoCallLeave>(_onLeave);
    on<VideoCallToggleMic>(_onToggleMic);
    on<VideoCallToggleVideo>(_onToggleVideo);
    on<VideoCallToggleCamera>(_onToggleCamera);
    on<VideoCallScreenShare>(_onToggleScreenShare);
    on<VideoCallLifecycleChanged>(_onLifecycleChanged);
    on<VideoCallUpdateReceived>(_onUpdateReceived);
  }

  Future<void> _onInitialize(
    VideoCallInitialize event,
    Emitter<VideoCallState> emit,
  ) async {
    emit(state.copyWith(isInitializing: true, isInitialized: false));
    final isInitialized = await _callService.initialize();
    _dataListener = () =>
        add(VideoCallUpdateReceived(_callService.callDataStream.value));
    _callService.callDataStream.addListener(_dataListener);

    emit(state.copyWith(isInitializing: false, isInitialized: isInitialized));
  }

  Future<void> _onLeave(
    VideoCallLeave event,
    Emitter<VideoCallState> emit,
  ) async {
    await _callService.leaveChannel();
  }

  Future<void> _onToggleMic(
    VideoCallToggleMic event,
    Emitter<VideoCallState> emit,
  ) async {
    final newMicState = !state.data.isMicEnabled;
    await _callService.toggleMic(newMicState);
  }

  Future<void> _onToggleVideo(
    VideoCallToggleVideo event,
    Emitter<VideoCallState> emit,
  ) async {
    final newVideoState = !state.data.isVideoEnabled;
    await _callService.toggleVideo(newVideoState);
  }

  Future<void> _onToggleCamera(
    VideoCallToggleCamera event,
    Emitter<VideoCallState> emit,
  ) async {
    await _callService.toggleCamera();
  }

  Future<void> _onToggleScreenShare(
    VideoCallScreenShare event,
    Emitter<VideoCallState> emit,
  ) async {
    final newScreenSharingState = !state.data.isScreenSharing;
    await _callService.toggleScreenShare(newScreenSharingState);
  }

  void _onUpdateReceived(
    VideoCallUpdateReceived event,
    Emitter<VideoCallState> emit,
  ) {
    emit(
      state.copyWith(
        data: event.data,
        isInitializing: false,
        isInitialized: true,
      ),
    );
  }

  Future<void> _onLifecycleChanged(
    VideoCallLifecycleChanged event,
    Emitter<VideoCallState> emit,
  ) async {
    if (event.state == AppLifecycleState.detached) {
      add(VideoCallLeave());
    }
  }

  @override
  Future<void> close() {
    _callService.callDataStream.removeListener(_dataListener);
    _callService.leaveChannel();
    return super.close();
  }
}
