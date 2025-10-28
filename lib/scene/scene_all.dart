import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_vpn/city_ping.dart';
import 'package:task_vpn/models/vpn_server.dart';
import 'package:task_vpn/navbar.dart';
import 'package:task_vpn/scene/scene_favorite.dart';
import 'package:task_vpn/scene/scene_my.dart';
import 'package:flutter/cupertino.dart';
import 'package:task_vpn/providers/vpn_provider.dart';

class SceneAll extends StatefulWidget {
  const SceneAll({super.key});

  @override
  State<SceneAll> createState() => _SceneAllState();
}

class _SceneAllState extends State<SceneAll> {
  String searchText = '';
  bool showNoResults = false;
  int _currentTabIndex = 0;

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
      showNoResults = value.isNotEmpty;
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentTabIndex = index;
      searchText = '';
      showNoResults = false;
    });
  }

  Widget _buildCurrentScene() {
    switch (_currentTabIndex) {
      case 0:
        return _buildAllScene();
      case 1:
        return _buildMyScene();
      case 2:
        return _buildFavoritesScene();
      default:
        return _buildAllScene();
    }
  }

  Widget _buildAllScene() {
    final vpnProvider = Provider.of<VpnProvider>(context);
    
    final filteredServers = _filterServers(vpnProvider.servers, searchText);

    if (searchText.isNotEmpty && filteredServers.isEmpty) {
      return _buildNoResults();
    }

    final Map<String, List<VpnServer>> filteredServersByCountry = {};
    for (final server in filteredServers) {
      if (!filteredServersByCountry.containsKey(server.country)) {
        filteredServersByCountry[server.country] = [];
      }
      filteredServersByCountry[server.country]!.add(server);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (searchText.isEmpty) ...[
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
              ],
              ..._buildServerList(filteredServersByCountry),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMyScene() {
    final vpnProvider = Provider.of<VpnProvider>(context);
    final myServers = vpnProvider.myServers;
    
    final filteredMyServers = _filterServers(myServers, searchText);

    if (searchText.isNotEmpty && filteredMyServers.isEmpty) {
      return _buildNoResults();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchText.isEmpty) ...[
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
          ],
          ...filteredMyServers.map((server) => Column(
            children: [
              CityPingCard(
                serverId: server.id,
                cityName: server.cityName,
                ping: server.ping,
                imageAsset: server.imageAsset,
                showDeleteText: true,
              ),
              const SizedBox(height: 6),
            ],
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildFavoritesScene() {
    final vpnProvider = Provider.of<VpnProvider>(context);
    final favoriteServersByCountry = vpnProvider.favoriteServersByCountry;

    final Map<String, List<VpnServer>> filteredFavoritesByCountry = {};
    
    for (final entry in favoriteServersByCountry.entries) {
      final country = entry.key;
      final servers = entry.value;
      final filteredServers = _filterServers(servers, searchText);
      
      if (filteredServers.isNotEmpty) {
        filteredFavoritesByCountry[country] = filteredServers;
      }
    }

    if (searchText.isNotEmpty && filteredFavoritesByCountry.isEmpty) {
      return _buildNoResults();
    }

    if (filteredFavoritesByCountry.isEmpty && searchText.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              color: Colors.grey,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Нет избранных серверов',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...filteredFavoritesByCountry.entries.map((entry) {
            final country = entry.key;
            final servers = entry.value;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  country,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                ...servers.map((server) => Column(
                  children: [
                    CityPingCard(
                      serverId: server.id,
                      cityName: server.cityName,
                      ping: server.ping,
                      imageAsset: server.imageAsset,
                    ),
                    const SizedBox(height: 6),
                  ],
                )).toList(),
                const SizedBox(height: 10),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  List<VpnServer> _filterServers(List<VpnServer> servers, String searchText) {
    if (searchText.isEmpty) {
      return servers;
    }
    
    return servers.where((server) =>
      server.cityName.toLowerCase().contains(searchText.toLowerCase()) ||
      server.country.toLowerCase().contains(searchText.toLowerCase())
    ).toList();
  }

  Widget _buildNoResults() {
    return const Center(
      child: Column(
        children: [
          SizedBox(height: 5),
          Text(
            'Нет результатов',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'По вашему запросу серверов не найдено. Попробуйте изменить запрос или проверьте написание.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildServerList(Map<String, List<VpnServer>> serversByCountry) {
    final widgets = <Widget>[];
    
    for (final entry in serversByCountry.entries) {
      final country = entry.key;
      final servers = entry.value;
      
      widgets.addAll([
        Text(
          country,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        ...servers.map((server) => Column(
          children: [
            CityPingCard(
              serverId: server.id,
              cityName: server.cityName,
              ping: server.ping,
              imageAsset: server.imageAsset,
            ),
            const SizedBox(height: 6),
          ],
        )).toList(),
        const SizedBox(height: 10),
      ]);
    }
    
    return widgets;
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
                  onTabChanged: _onTabChanged,
                ),
                const SizedBox(height: 24),
                _buildCurrentScene(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}