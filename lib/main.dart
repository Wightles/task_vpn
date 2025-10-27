import 'package:flutter/material.dart';
import 'package:task_vpn/scene_all.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SceneAll(),
    );
  }
}
