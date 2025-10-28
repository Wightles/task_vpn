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

  double _getAdaptivePadding(BuildContext context, [double basePadding = 8]) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return basePadding * 0.7;
    if (screenWidth < 400) return basePadding * 0.85;
    if (screenWidth > 600) return basePadding * 1.5;
    return basePadding;
  }

  double _getAdaptiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth < 360 ? 0.85 : 
                 screenWidth < 400 ? 0.9 :
                 screenWidth > 600 ? 1.2 : 1.0;
    return baseSize * scale;
  }

  double _getAdaptiveIconSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return 16;
    if (screenWidth > 600) return 32;
    return 24;
  }

  double _getAdaptiveImageSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return 28;
    if (screenWidth > 600) return 44;
    return 36;
  }

  double _getAdaptiveHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 700) return 50;
    if (screenHeight > 1000) return 80;
    return widget.height;
  }

  double _getAdaptiveBorderRadius(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return 8;
    if (screenWidth > 600) return 16;
    return 12;
  }

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

    final bool isServerSelected = vpnProvider.selectedServerId == widget.serverId;

    return GestureDetector(
      onTap: () {
        if (isServerSelected) {
          vpnProvider.deselectServer();
        } else {
          vpnProvider.selectServer(widget.serverId);
        }
      },
      child: Container(
        width: double.infinity,
        height: _getAdaptiveHeight(context),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(_getAdaptiveBorderRadius(context)),
          border: Border.all(
            color: isServerSelected ? Colors.blue : widget.borderColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: _getAdaptivePadding(context, 12)),
            Container(
              width: _getAdaptiveImageSize(context),
              height: _getAdaptiveImageSize(context),
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
                      child: Icon(Icons.location_city, size: _getAdaptiveIconSize(context) * 0.8),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: _getAdaptivePadding(context, 12)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cityName,
                    style: TextStyle(
                      fontSize: _getAdaptiveFontSize(context, 16),
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.ping,
                    style: TextStyle(
                      fontSize: _getAdaptiveFontSize(context, 12),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.showDeleteText && !isServerSelected)
              Padding(
                padding: EdgeInsets.only(right: _getAdaptivePadding(context, 8)),
                child: Text(
                  'Удалить',
                  style: TextStyle(
                    color: Colors.red[400],
                    fontSize: _getAdaptiveFontSize(context, 14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(right: _getAdaptivePadding(context, 16)),
              child: GestureDetector(
                onTap: () {
                  vpnProvider.toggleFavorite(widget.serverId);
                },
                child: Icon(
                  CupertinoIcons.heart_fill,
                  color: server.isFavorite
                      ? const Color.fromARGB(255, 204, 82, 204)
                      : const Color.fromARGB(255, 57, 54, 77),
                  size: _getAdaptiveIconSize(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}