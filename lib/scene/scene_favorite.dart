import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_vpn/city_ping.dart';
import 'package:task_vpn/providers/vpn_provider.dart';
import 'package:flutter/cupertino.dart';

class SceneFavorites extends StatefulWidget {
  const SceneFavorites({super.key});

  @override
  State<SceneFavorites> createState() => _SceneFavoritesState();
}

class _SceneFavoritesState extends State<SceneFavorites> {
  @override
  Widget build(BuildContext context) {
    final vpnProvider = Provider.of<VpnProvider>(context);
    final favoriteServersByCountry = vpnProvider.favoriteServersByCountry;

    if (favoriteServersByCountry.isEmpty) {
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
          ...favoriteServersByCountry.entries.map((entry) {
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
}