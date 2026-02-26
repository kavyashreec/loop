import 'package:flutter/material.dart';
import '../../core/colors.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Center(
        child: Text(
          "Login Screen",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}