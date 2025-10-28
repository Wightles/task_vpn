import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_vpn/widgets/city_ping.dart';
import 'package:task_vpn/models/vpn_server.dart';
import 'package:task_vpn/providers/vpn_provider.dart';
import 'package:task_vpn/utils/server_filter.dart';
import 'package:task_vpn/widgets/scenes/common/no_results_widget.dart';

class FavoritesTab extends StatelessWidget {
  final String searchText;

  const FavoritesTab({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    final vpnProvider = Provider.of<VpnProvider>(context);
    final favoriteServersByCountry = vpnProvider.favoriteServersByCountry;

    final Map<String, List<VpnServer>> filteredFavoritesByCountry = {};
    
    for (final entry in favoriteServersByCountry.entries) {
      final country = entry.key;
      final servers = entry.value;
      final filteredServers = ServerFilter.filterServers(servers, searchText);
      
      if (filteredServers.isNotEmpty) {
        filteredFavoritesByCountry[country] = filteredServers;
      }
    }

    if (searchText.isNotEmpty && filteredFavoritesByCountry.isEmpty) {
      return const NoResultsWidget();
    }

    if (filteredFavoritesByCountry.isEmpty && searchText.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.heart_fill,
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
          if (searchText.isEmpty) _buildSelectedServerSection(vpnProvider),
          ...filteredFavoritesByCountry.entries.map((entry) {
            final country = entry.key;
            final servers = entry.value.where((server) => server.id != vpnProvider.selectedServerId).toList();
            
            if (servers.isEmpty) return const SizedBox();
            
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
                    const SizedBox(height: 8),
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

  Widget _buildSelectedServerSection(VpnProvider vpnProvider) {
    if (vpnProvider.selectedServerId == null) return const SizedBox();

    final selectedServer = vpnProvider.servers.firstWhere(
      (server) => server.id == vpnProvider.selectedServerId && server.isFavorite,
      orElse: () => VpnServer(
        id: '',
        cityName: '',
        country: '',
        ping: '',
        imageAsset: '',
      ),
    );

    if (selectedServer.id.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CityPingCard(
          serverId: selectedServer.id,
          cityName: selectedServer.cityName,
          ping: selectedServer.ping,
          imageAsset: selectedServer.imageAsset,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}