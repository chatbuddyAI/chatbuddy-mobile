import 'package:chat_buddy/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'ChatBuddy',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Home(title: 'ChatBudy'),
    );
  }
}