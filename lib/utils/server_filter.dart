import 'package:task_vpn/models/vpn_server.dart';

class ServerFilter {
  static List<VpnServer> filterServers(List<VpnServer> servers, String searchText) {
    if (searchText.isEmpty) {
      return servers;
    }
    
    final lowerSearch = searchText.toLowerCase();
    return servers.where((server) =>
      server.cityName.toLowerCase().contains(lowerSearch) ||
      server.country.toLowerCase().contains(lowerSearch)
    ).toList();
  }

  static Map<String, List<VpnServer>> groupByCountry(List<VpnServer> servers) {
    final Map<String, List<VpnServer>> result = {};
    for (final server in servers) {
      if (!result.containsKey(server.country)) {
        result[server.country] = [];
      }
      result[server.country]!.add(server);
    }
    return result;
  }
}