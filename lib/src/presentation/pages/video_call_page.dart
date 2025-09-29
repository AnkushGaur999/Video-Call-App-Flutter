import 'dart:math';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_call_app/src/config/routes/app_routes.dart';
import 'package:video_call_app/src/core/app_colors/app_colors.dart';
import 'package:video_call_app/src/data/models/video_call_data.dart';
import 'package:video_call_app/src/presentation/bloc/video_call/video_call_bloc.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({super.key});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage>
    with WidgetsBindingObserver {
  late final VideoCallBloc _bloc;

  bool _isControlesVisibles = true;

  @override
  void initState() {
    _bloc = context.read<VideoCallBloc>()..add(VideoCallInitialize());
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bloc.add(VideoCallLeave());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _bloc.add(VideoCallLifecycleChanged(state));
    super.didChangeAppLifecycleState(state);
  }

  Future<void> _showEndCallDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Call'),
        content: const Text('Are you sure you want to end this call?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('End Call'),
          ),
        ],
      ),
    );

    if (result == true) {
      _bloc.add(VideoCallLeave());
      if (mounted) context.goNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCallBloc, VideoCallState>(
      builder: (context, state) {
        final data = state.data;

        return WillPopScope(
          onWillPop: () async {
            await _showEndCallDialog();
            return false;
          },
          child: Scaffold(
            backgroundColor: const Color(0xFF1a1a1a),
            body: Stack(
              children: [
                if (state.isInitialized)
                  _buildVideoViews(
                    data,
                    context.read<VideoCallBloc>().rtcEngine,
                  ),
                _buildTopBar(data),
                if (state.isInitializing) _buildLoadingOverlay(),
                _buildBottomControls(data),
                if (data.errorMessage != null)
                  _buildErrorOverlay(data.errorMessage!),
                if (data.isReconnecting) _buildReconnectingOverlay(),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Widget Builders ---

  Widget _buildVideoViews(VideoCallData data, RtcEngine engine) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isControlesVisibles = !_isControlesVisibles;
              });
            },
            child: _buildRemoteVideo(data, engine),
          ),
        ),
        Positioned(
          top: 40,
          left: 10,
          child: GestureDetector(
            onTap: () {
              // Swap logic here
            },
            child: Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildLocalVideo(data, engine),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRemoteVideo(VideoCallData data, RtcEngine engine) {
    if (data.remoteUid == null) {
      return Container(
        color: const Color(0xFF1a1a1a),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 60,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Waiting for other to join...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!data.remoteUserVideoEnabled) {
      return Container(
        color: const Color(0xFF1a1a1a),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withValues(alpha: 0.3),
                      AppColors.primaryColor.withValues(alpha: 0.1),
                    ],
                  ),
                  border: Border.all(color: AppColors.primaryColor, width: 2),
                ),
                child: const Icon(
                  Icons.person_off,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: engine,
            canvas: VideoCanvas(uid: data.remoteUid),
            connection: const RtcConnection(channelId: 'test'),
          ),
        ),
        if (!data.remoteUserAudioEnabled)
          Positioned(
            top: 80,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.mic_off, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Muted',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLocalVideo(VideoCallData data, RtcEngine engine) {
    if (!data.isVideoEnabled || !data.localUserJoined) {
      return Container(
        color: const Color(0xFF2a2a2a),
        child: const Center(
          child: Icon(Icons.videocam_off, size: 40, color: Colors.white54),
        ),
      );
    }

    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  Widget _buildTopBar(VideoCallData data) {
    return Positioned(
      top: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          bottom: 16,
          left: 16,
          right: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Material(
                color: Colors.white.withValues(alpha: 0.6),
                child: IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          scrollable: true,
                          title: Text("Friends List"),
                          content: SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 400,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue.withValues(
                                                    alpha: 0.6),
                                              ),
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              "User${Random(100).nextInt(10000)}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.video_call_outlined),
                                          SizedBox(width: 20),
                                          Icon(Icons.call, color: Colors.green),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.person_add, color: Colors.black),
                ),
              ),
            ),

            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              decoration: BoxDecoration(
                color:
                    data.connectionState ==
                        ConnectionStateType.connectionStateConnected
                    ? Colors.green.withValues(alpha: 0.8)
                    : Colors.red.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: []),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(VideoCallData data) {
    final bloc = context.read<VideoCallBloc>();
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Visibility(
        visible: _isControlesVisibles,
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            top: 20,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: Icons.flip_camera_ios,
                label: 'Switch',
                onPressed: () => bloc.add(VideoCallToggleCamera()),
              ),
              _buildControlButton(
                icon: data.isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                label: data.isVideoEnabled ? 'Camera' : 'Camera Off',
                onPressed: () => bloc.add(VideoCallToggleVideo()),
                isActive: data.isVideoEnabled,
              ),
              _buildControlButton(
                icon: Icons.call_end,
                label: 'End',
                onPressed: _showEndCallDialog,
                color: Colors.red,
                isEndCall: true,
              ),
              _buildControlButton(
                icon: data.isMicEnabled ? Icons.mic : Icons.mic_off,
                label: data.isMicEnabled ? 'Mic' : 'Muted',
                onPressed: () => bloc.add(VideoCallToggleMic()),
                isActive: data.isMicEnabled,
              ),
              _buildControlButton(
                icon: data.isScreenSharing
                    ? Icons.stop_screen_share
                    : Icons.screen_share_rounded,
                label: 'Share',
                onPressed: () => bloc.add(VideoCallScreenShare()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
    bool isEndCall = false,
    bool isActive = true,
  }) {
    final buttonColor = color ?? (isActive ? Colors.white : Colors.white38);
    final iconColor = isEndCall
        ? Colors.white
        : (isActive ? const Color(0xFF1a1a1a) : Colors.white);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isEndCall ? 64 : 56,
          height: isEndCall ? 64 : 56,
          decoration: BoxDecoration(
            color: buttonColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(icon, color: iconColor),
            iconSize: isEndCall ? 32 : 28,
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: const Color(0xFF1a1a1a),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
            const SizedBox(height: 24),
            const Text(
              'Initializing call...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorOverlay(String errorMessage) {
    final bloc = context.read<VideoCallBloc>();
    return Container(
      color: const Color(0xFF1a1a1a),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 24),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  bloc.add(VideoCallLeave());
                  if (mounted) context.goNamed(AppRoutes.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReconnectingOverlay() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Reconnecting...',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
