import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Loading...',
          style: TextStyle(fontSize: 30, color: Coloors.rustOrange),
        ),
      ),
    );
  }
}
