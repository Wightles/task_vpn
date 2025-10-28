class VpnServer {
  final String id;
  final String cityName;
  final String country;
  final String ping;
  final String imageAsset;
  bool isFavorite;

  VpnServer({
    required this.id,
    required this.cityName,
    required this.country,
    required this.ping,
    required this.imageAsset,
    this.isFavorite = false,
  });

  VpnServer copyWith({
    String? id,
    String? cityName,
    String? country,
    String? ping,
    String? imageAsset,
    bool? isFavorite,
  }) {
    return VpnServer(
      id: id ?? this.id,
      cityName: cityName ?? this.cityName,
      country: country ?? this.country,
      ping: ping ?? this.ping,
      imageAsset: imageAsset ?? this.imageAsset,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VpnServer &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}