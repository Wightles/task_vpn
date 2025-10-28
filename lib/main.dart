import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_vpn/scene/scene_all.dart';
import 'package:task_vpn/providers/vpn_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => VpnProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPN App',
      theme: ThemeData.dark(),
      home: const SceneAll(),
    );
  }
}