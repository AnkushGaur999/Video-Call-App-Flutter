import 'package:flutter/material.dart';
import 'package:video_call_app/src/core/app_colors/app_colors.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({super.key});

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomIdController = TextEditingController();

  void _onJoinPressed() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final roomId = _roomIdController.text.trim();
      print('Joining room $roomId as $name');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Room", style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/video_call.png", width: 80, height: 80),

              SizedBox(height: 30),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Enter Your Name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Name required" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _roomIdController,
                decoration: InputDecoration(
                  hintText: "Enter Room ID",
                  prefixIcon: Icon(Icons.meeting_room),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Room ID required" : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onJoinPressed,

                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: AppColors.primaryColor,
                ),
                child: Text("Join Call", style: TextStyle(color: Colors.white)),
              ),

              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onJoinPressed,

                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: AppColors.primaryColor,
                ),
                child: Text("Create", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
