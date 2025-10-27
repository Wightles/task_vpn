import 'package:flutter/material.dart';
import 'package:task_vpn/city_ping.dart';
import 'package:task_vpn/navbar.dart';
import 'package:flutter/cupertino.dart';

class SceneAll extends StatefulWidget {
  const SceneAll({super.key});

  @override
  State<SceneAll> createState() => _SceneAllState();
}

class _SceneAllState extends State<SceneAll> {
  String searchText = '';
  bool showNoResults = false;

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
      showNoResults = value.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 18, 36, 50),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.chevron_back,
                        color: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Точки доступа',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FilterMenu(
                  onSearchChanged: _onSearchChanged,
                  showNoResults: showNoResults,
                ),
                const SizedBox(height: 24),
                
                if (!showNoResults) ...[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Мои точки доступа',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 20),
                        const CityPingCard(
                          cityName: 'Берлин',
                          ping: '120 мс',
                          imageAsset: 'assets/images/test1.png',
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Германия',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
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
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'США',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
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
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 5),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Нет результатов',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'По вашему запросу серверов не найдено. Попробуйте изменить запрос или проверьте написание.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}