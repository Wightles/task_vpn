import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:task_vpn/models/vpn_server.dart';
import 'package:task_vpn/providers/vpn_provider.dart';

class CityPingCard extends StatefulWidget {
  final String serverId;
  final String cityName;
  final String ping;
  final String imageAsset;
  final double height;
  final Color borderColor;
  final bool showDeleteText;

  const CityPingCard({
    Key? key,
    required this.serverId,
    required this.cityName,
    required this.ping,
    required this.imageAsset,
    this.height = 60,
    this.borderColor = const Color.fromARGB(255, 89, 95, 130),
    this.showDeleteText = false,
  }) : super(key: key);

  @override
  State<CityPingCard> createState() => _CityPingCardState();
}

class _CityPingCardState extends State<CityPingCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final vpnProvider = Provider.of<VpnProvider>(context);
    final server = vpnProvider.servers.firstWhere(
      (server) => server.id == widget.serverId,
      orElse: () => VpnServer(
        id: widget.serverId,
        cityName: widget.cityName,
        country: '',
        ping: widget.ping,
        imageAsset: widget.imageAsset,
      ),
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : widget.borderColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  widget.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.location_city, size: 20),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cityName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.ping,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.showDeleteText && !isSelected)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  'Удалить',
                  style: TextStyle(
                    color: Colors.red[400],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  vpnProvider.toggleFavorite(widget.serverId);
                },
                child: Icon(
                  CupertinoIcons.heart_fill,
                  color: server.isFavorite
                      ? const Color.fromARGB(255, 204, 82, 204)
                      : const Color.fromARGB(255, 57, 54, 77),
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}