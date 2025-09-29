import 'package:go_router/go_router.dart';
import 'package:video_call_app/src/presentation/pages/join_room_page.dart';
import 'package:video_call_app/src/presentation/pages/login_page.dart';
import 'package:video_call_app/src/presentation/pages/splash_page.dart';
import 'package:video_call_app/src/presentation/pages/video_call_page.dart';

class AppRoutes {
  /// Route names for navigation
  ///

  static const String splash = 'splash';
  static const String login = 'login';
  static const String joinRoom = 'joinRoom';
  static const String dashboard = 'dashboard';
  static const String videoCall = 'videoCall';

  static const String _splash = '/';
  static const String _login = '/login';
  static const String _joinRoom = '/joinRoom';
  static const String _videoCall = '/videoCall';

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: splash,
        path: _splash,
        builder: (context, state) => SplashPage(),
      ),
      GoRoute(
        name: login,
        path: _login,
        builder: (context, state) => LoginPage(),
      ),

      GoRoute(
        name: joinRoom,
        path: _joinRoom,
        builder: (context, state) => JoinRoomPage(),
      ),

      GoRoute(
        name: videoCall,
        path: _videoCall,
        builder: (context, state) => VideoCallPage(),
      ),

    ],
  );
}
