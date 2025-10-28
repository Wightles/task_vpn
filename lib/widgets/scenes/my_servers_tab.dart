import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_vpn/models/vpn_server.dart';
import 'package:task_vpn/widgets/city_ping.dart';
import 'package:task_vpn/providers/vpn_provider.dart';
import 'package:task_vpn/utils/server_filter.dart';
import 'package:task_vpn/widgets/scenes/common/no_results_widget.dart';

class MyServersTab extends StatelessWidget {
  final String searchText;

  const MyServersTab({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    final vpnProvider = Provider.of<VpnProvider>(context);
    final myServers = vpnProvider.myServers;
    final filteredMyServers = ServerFilter.filterServers(myServers, searchText);

    if (searchText.isNotEmpty && filteredMyServers.isEmpty) {
      return const NoResultsWidget();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchText.isEmpty) ...[
            _buildAddKeyButton(),
            const SizedBox(height: 10),
            _buildSelectedServerSection(vpnProvider, myServers),
          ],
          ...filteredMyServers.where((server) => server.id != vpnProvider.selectedServerId).map((server) => Column(
            children: [
              CityPingCard(
                serverId: server.id,
                cityName: server.cityName,
                ping: server.ping,
                imageAsset: server.imageAsset,
                showDeleteText: true,
              ),
              const SizedBox(height: 8),
            ],
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildSelectedServerSection(VpnProvider vpnProvider, List<dynamic> myServers) {
    if (vpnProvider.selectedServerId == null) return const SizedBox();

    final selectedServer = vpnProvider.servers.firstWhere(
      (server) => server.id == vpnProvider.selectedServerId && myServers.any((s) => s.id == server.id),
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
          showDeleteText: true,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAddKeyButton() {
    return Container(
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
    );
  }
}