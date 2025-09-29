import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VideoCallData {
  final int? remoteUid;
  final bool localUserJoined;
  final bool isMicEnabled;
  final bool isVideoEnabled;
  final bool isFrontCamera;
  final bool remoteUserVideoEnabled;
  final bool remoteUserAudioEnabled;
  final bool isScreenSharing;
  final ConnectionStateType connectionState;
  final bool isReconnecting;
  final String? errorMessage;

  const VideoCallData({
    this.remoteUid,
    this.localUserJoined = false,
    this.isMicEnabled = true,
    this.isVideoEnabled = true,
    this.isFrontCamera = true,
    this.isScreenSharing = false,
    this.remoteUserVideoEnabled = false,
    this.remoteUserAudioEnabled = true,
    this.connectionState = ConnectionStateType.connectionStateDisconnected,
    this.isReconnecting = false,
    this.errorMessage,
  });

  VideoCallData copyWith({
    int? remoteUid,
    bool? localUserJoined,
    bool? isMicEnabled,
    bool? isVideoEnabled,
    bool? isFrontCamera,
    bool? isScreenSharing,
    bool? remoteUserVideoEnabled,
    bool? remoteUserAudioEnabled,
    ConnectionStateType? connectionState,
    bool? isReconnecting,
    String? errorMessage,
  }) {
    return VideoCallData(
      remoteUid: remoteUid ?? this.remoteUid,
      localUserJoined: localUserJoined ?? this.localUserJoined,
      isMicEnabled: isMicEnabled ?? this.isMicEnabled,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
      remoteUserVideoEnabled: remoteUserVideoEnabled ?? this.remoteUserVideoEnabled,
      remoteUserAudioEnabled: remoteUserAudioEnabled ?? this.remoteUserAudioEnabled,
      connectionState: connectionState ?? this.connectionState,
      isReconnecting: isReconnecting ?? this.isReconnecting,
      errorMessage: errorMessage, // Note: passing null clears the message
    );
  }
}