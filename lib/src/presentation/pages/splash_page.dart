import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_call_app/src/config/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) context.goNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/icons/video_call.png")),
    );
  }
}
