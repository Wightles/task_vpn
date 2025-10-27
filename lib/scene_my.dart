import 'package:flutter/material.dart';
import 'package:task_vpn/city_ping.dart';

class SceneMy extends StatefulWidget {
  const SceneMy({super.key});

  @override
  State<SceneMy> createState() => _SceneMyState();
}

class _SceneMyState extends State<SceneMy> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Добавить ключ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const CityPingCard(
            cityName: 'Берлин',
            ping: '120 мс',
            imageAsset: 'assets/images/test1.png',
          ),
          const SizedBox(height: 6),
          const CityPingCard(
            cityName: 'Берлин',
            ping: '120 мс',
            imageAsset: 'assets/images/test1.png',
            showDeleteText: true,
          ),
          const SizedBox(height: 6),
          const CityPingCard(
            cityName: 'Берлин',
            ping: '120 мс',
            imageAsset: 'assets/images/test1.png',
            showDeleteText: true,
          ),
        ],
      ),
    );
  }
}