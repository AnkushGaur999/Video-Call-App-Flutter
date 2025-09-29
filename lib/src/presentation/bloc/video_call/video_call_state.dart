part of 'video_call_bloc.dart';

@immutable
class VideoCallState {
  final VideoCallData data;
  final bool isInitializing;
  final bool isInitialized;

  const VideoCallState({
    required this.data,
    this.isInitializing = true,
    this.isInitialized = false,
  });

  VideoCallState copyWith({
    VideoCallData? data,
    bool? isInitializing,
    bool? isInitialized,
  }) {
    return VideoCallState(
      data: data ?? this.data,
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  toString() {
    return 'VideoCallState(data: $data, isInitializing: $isInitializing, isInitialized: $isInitialized)';
  }
}

final class VideoCallInitial extends VideoCallState {
  const VideoCallInitial() : super(data: const VideoCallData());
}
