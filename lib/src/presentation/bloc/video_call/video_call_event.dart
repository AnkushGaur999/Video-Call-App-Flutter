part of 'video_call_bloc.dart';

@immutable
sealed class VideoCallEvent {}

final class VideoCallInitialize extends VideoCallEvent {}

final class VideoCallLeave extends VideoCallEvent {}

final class VideoCallToggleMic extends VideoCallEvent {}

final class VideoCallToggleVideo extends VideoCallEvent {}

final class VideoCallToggleCamera extends VideoCallEvent {}

final class VideoCallScreenShare extends VideoCallEvent {}

final class VideoCallLifecycleChanged extends VideoCallEvent {
  final AppLifecycleState state;
  VideoCallLifecycleChanged(this.state);
}

final class VideoCallUpdateReceived extends VideoCallEvent {
  final VideoCallData data;
  VideoCallUpdateReceived(this.data);
}