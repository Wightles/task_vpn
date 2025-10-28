import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_vpn/widgets/city_ping.dart';
import 'package:task_vpn/models/vpn_server.dart';
import 'package:task_vpn/providers/vpn_provider.dart';
import 'package:task_vpn/utils/server_filter.dart';
import 'package:task_vpn/widgets/scenes/common/no_results_widget.dart';

class AllServersTab extends StatelessWidget {
  final String searchText;

  const AllServersTab({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    final vpnProvider = Provider.of<VpnProvider>(context);
    final filteredServers = ServerFilter.filterServers(vpnProvider.servers, searchText);

    if (searchText.isNotEmpty && filteredServers.isEmpty) {
      return const NoResultsWidget();
    }

    final serversByCountry = ServerFilter.groupByCountry(filteredServers);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (searchText.isEmpty) ...[
                _buildMyAccessPointsSection(),
                const SizedBox(height: 20),
                _buildSelectedServerSection(vpnProvider, filteredServers),
              ],
              _buildServerList(serversByCountry, vpnProvider),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedServerSection(VpnProvider vpnProvider, List<VpnServer> filteredServers) {
    if (vpnProvider.selectedServerId == null) return const SizedBox();

    final selectedServer = vpnProvider.servers.firstWhere(
      (server) => server.id == vpnProvider.selectedServerId,
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

  Widget _buildMyAccessPointsSection() {
    return Column(
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
              backgroundColor: const Color(0xFF2563EB),
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
      ],
    );
  }

  Widget _buildServerList(Map<String, List<VpnServer>> serversByCountry, VpnProvider vpnProvider) {
    final filteredServersByCountry = <String, List<VpnServer>>{};
    
    for (final entry in serversByCountry.entries) {
      final country = entry.key;
      final servers = entry.value.where((server) => server.id != vpnProvider.selectedServerId).toList();
      
      if (servers.isNotEmpty) {
        filteredServersByCountry[country] = servers;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in filteredServersByCountry.entries) ...[
          Padding(
            padding: const EdgeInsets.only(left: 0, bottom: 8),
            child: Text(
              entry.key,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          ...entry.value.map((server) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CityPingCard(
              serverId: server.id,
              cityName: server.cityName,
              ping: server.ping,
              imageAsset: server.imageAsset,
            ),
          )).toList(),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}