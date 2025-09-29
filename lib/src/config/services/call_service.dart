import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call_app/src/config/services/notification_service.dart';
import 'package:video_call_app/src/data/models/video_call_data.dart';

class CallService {
  static const String _appId = "30de97016060437388e6a589de24be8d";
  static const String _token =
      "007eJxTYOi+tC5D9e/yr6yTbxvm9j/cvXeq2jHG3e1/lp9mze1MWHtQgcHYICXV0tzA0MzAzMDE2NzYwiLVLNHUwjIl1cgkKdUiZcatWxkNgYwM0vGNzIwMEAjiszCUpBaXMDAAAAv1IcI=";
  static const String _channel = "test";

  late RtcEngine _engine;

  RtcEngine get engine => _engine;

  final ValueNotifier<VideoCallData> _callData = ValueNotifier(
    const VideoCallData(),
  );

  ValueListenable<VideoCallData> get callDataStream => _callData;

  Future<bool> initialize() async {
    _callData.value = _callData.value.copyWith(errorMessage: null);

    try {
      final permissions = await [
        Permission.microphone,
        Permission.camera,
      ].request();

      if (permissions[Permission.microphone] != PermissionStatus.granted ||
          permissions[Permission.camera] != PermissionStatus.granted) {
        _callData.value = _callData.value.copyWith(
          errorMessage: 'Camera and microphone permissions are required',
        );
        return false;
      }

      _engine = createAgoraRtcEngine();
      await _engine.initialize(
        const RtcEngineContext(
          appId: _appId,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );

      _setupEngineEventHandlers();

      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await _engine.enableVideo();
      await _engine.enableAudio();
      await _engine.setVideoEncoderConfiguration(
        const VideoEncoderConfiguration(
          dimensions: VideoDimensions(width: 1280, height: 720),
          frameRate: 30,
          bitrate: 2000,
        ),
      );
      await _engine.startPreview();

      await _engine.joinChannel(
        token: _token,
        channelId: _channel,
        uid: 0,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );

      return true;
    } catch (e) {
      _callData.value = _callData.value.copyWith(
        errorMessage: 'Failed to initialize: ${e.toString()}',
      );

      return false;
    }
  }

  void _setupEngineEventHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          _callData.value = _callData.value.copyWith(
            localUserJoined: true,
            errorMessage: null,
          );
        },
        onUserJoined:
            (RtcConnection connection, int remoteUid, int elapsed) async {
              await NotificationService.instance.showNotification();
              _callData.value = _callData.value.copyWith(remoteUid: remoteUid);
            },
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              if (_callData.value.remoteUid == remoteUid) {
                _callData.value = _callData.value.copyWith(
                  remoteUid: null,
                  remoteUserVideoEnabled: false,
                );
              }
            },
        onUserMuteVideo: (RtcConnection connection, int remoteUid, bool muted) {
          if (remoteUid == _callData.value.remoteUid) {
            _callData.value = _callData.value.copyWith(
              remoteUserVideoEnabled: !muted,
            );
          }
        },
        onUserMuteAudio: (RtcConnection connection, int remoteUid, bool muted) {
          if (remoteUid == _callData.value.remoteUid) {
            _callData.value = _callData.value.copyWith(
              remoteUserAudioEnabled: !muted,
            );
          }
        },
        onConnectionStateChanged:
            (
              RtcConnection connection,
              ConnectionStateType state,
              ConnectionChangedReasonType reason,
            ) {
              _callData.value = _callData.value.copyWith(
                connectionState: state,
                isReconnecting:
                    state == ConnectionStateType.connectionStateReconnecting,
              );
            },
        onError: (ErrorCodeType err, String msg) {
          _callData.value = _callData.value.copyWith(
            errorMessage: 'Connection error: $msg',
          );
        },
        onRemoteVideoStateChanged:
            (
              RtcConnection connection,
              int remoteUid,
              RemoteVideoState state,
              RemoteVideoStateReason reason,
              int elapsed,
            ) {
              if (remoteUid == _callData.value.remoteUid) {
                _callData.value = _callData.value.copyWith(
                  remoteUserVideoEnabled:
                      state == RemoteVideoState.remoteVideoStateDecoding ||
                      state == RemoteVideoState.remoteVideoStateStarting,
                );
              }
            },
      ),
    );
  }

  Future<void> leaveChannel() async {
    try {
      await _engine.leaveChannel();
      await _engine.release();
    } catch (e) {
      debugPrint('Error leaving channel: $e');
    }
    _callData.value = const VideoCallData();
  }

  Future<void> toggleCamera() async {
    await _engine.switchCamera();
    _callData.value = _callData.value.copyWith(
      isFrontCamera: !_callData.value.isFrontCamera,
    );
  }

  Future<void> toggleVideo(bool enabled) async {
    await _engine.muteLocalVideoStream(!enabled);
    _callData.value = _callData.value.copyWith(isVideoEnabled: enabled);
  }

  Future<void> toggleScreenShare(bool enabled) async {
    if (!enabled) {
      await _engine.stopScreenCapture();
      await _engine.updateChannelMediaOptions(
        const ChannelMediaOptions(
          publishCameraTrack: true,
          publishScreenCaptureVideo: false,
          publishScreenCaptureAudio: false,
        ),
      );
    } else {
      await _engine.startScreenCapture(
        const ScreenCaptureParameters2(captureAudio: true, captureVideo: true),
      );
      await _engine.updateChannelMediaOptions(
        const ChannelMediaOptions(
          publishCameraTrack: false,
          publishScreenCaptureVideo: true,
          publishScreenCaptureAudio: true,
        ),
      );
      _callData.value = _callData.value.copyWith(isVideoEnabled: true);
      //
    }
    _callData.value = _callData.value.copyWith(isScreenSharing: enabled);

  }

  Future<void> toggleMic(bool enabled) async {
    await _engine.muteLocalAudioStream(!enabled);
    _callData.value = _callData.value.copyWith(isMicEnabled: enabled);
  }

  Future<void> pauseStreams() async {
    await _engine.muteLocalAudioStream(true);
    await _engine.muteLocalVideoStream(true);
  }

  Future<void> resumeStreams() async {
    if (_callData.value.isMicEnabled) await _engine.muteLocalAudioStream(false);
    if (_callData.value.isVideoEnabled) {
      await _engine.muteLocalVideoStream(false);
    }
  }
}
