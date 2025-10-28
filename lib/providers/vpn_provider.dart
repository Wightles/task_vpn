import 'package:flutter/foundation.dart';
import '../models/vpn_server.dart';

class VpnProvider with ChangeNotifier {
  final List<VpnServer> _servers = [
    VpnServer(
      id: '1',
      cityName: 'Берлин',
      country: 'Германия',
      ping: '120 мс',
      imageAsset: 'assets/images/test1.png',
    ),
    VpnServer(
      id: '2',
      cityName: 'Мюнхен',
      country: 'Германия',
      ping: '130 мс',
      imageAsset: 'assets/images/test1.png',
    ),
    VpnServer(
      id: '3',
      cityName: 'Франкфурт',
      country: 'Германия',
      ping: '125 мс',
      imageAsset: 'assets/images/test1.png',
    ),
    VpnServer(
      id: '4',
      cityName: 'Нью-Йорк',
      country: 'США',
      ping: '150 мс',
      imageAsset: 'assets/images/test2.png',
    ),
    VpnServer(
      id: '5',
      cityName: 'Лос-Анджелес',
      country: 'США',
      ping: '160 мс',
      imageAsset: 'assets/images/test2.png',
    ),
    VpnServer(
      id: '6',
      cityName: 'Чикаго',
      country: 'США',
      ping: '155 мс',
      imageAsset: 'assets/images/test2.png',
    ),
    VpnServer(
      id: '7',
      cityName: 'Париж',
      country: 'Франция',
      ping: '140 мс',
      imageAsset: 'assets/images/test3.png',
    ),
    VpnServer(
      id: '8',
      cityName: 'Марсель',
      country: 'Франция',
      ping: '145 мс',
      imageAsset: 'assets/images/test3.png',
    ),
  ];

  final Set<String> _selectedMyServers = {};

  List<VpnServer> get servers => _servers;
  
  List<VpnServer> get favoriteServers => 
      _servers.where((server) => server.isFavorite).toList();
  
  List<VpnServer> get myServers => 
      _servers.where((server) => server.country == 'Германия').toList();

  Set<String> get selectedMyServers => _selectedMyServers;

  bool isServerSelected(String serverId) {
    return _selectedMyServers.contains(serverId);
  }

  void toggleServerSelection(String serverId) {
    if (_selectedMyServers.contains(serverId)) {
      _selectedMyServers.remove(serverId);
    } else {
      _selectedMyServers.add(serverId);
    }
    notifyListeners();
  }

  void clearSelections() {
    _selectedMyServers.clear();
    notifyListeners();
  }

  void toggleFavorite(String serverId) {
    final index = _servers.indexWhere((server) => server.id == serverId);
    if (index != -1) {
      _servers[index] = _servers[index].copyWith(
        isFavorite: !_servers[index].isFavorite,
      );
      notifyListeners();
    }
  }

  List<VpnServer> getServersByCountry(String country) {
    return _servers.where((server) => server.country == country).toList();
  }

  List<String> get availableCountries {
    return _servers.map((server) => server.country).toSet().toList();
  }

  List<String> get favoriteCountries {
    return favoriteServers.map((server) => server.country).toSet().toList();
  }

  Map<String, List<VpnServer>> get favoriteServersByCountry {
    final Map<String, List<VpnServer>> result = {};
    for (final server in favoriteServers) {
      if (!result.containsKey(server.country)) {
        result[server.country] = [];
      }
      result[server.country]!.add(server);
    }
    return result;
  }

  Map<String, List<VpnServer>> get serversByCountry {
    final Map<String, List<VpnServer>> result = {};
    for (final server in _servers) {
      if (!result.containsKey(server.country)) {
        result[server.country] = [];
      }
      result[server.country]!.add(server);
    }
    return result;
  }
}