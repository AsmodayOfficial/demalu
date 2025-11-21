// lib/data/modules/map_module/models/member_location.dart

class MemberLocation {
  final int userId;
  final String username;
  final double latitude;
  final double longitude;

  MemberLocation({
    required this.userId,
    required this.username,
    required this.latitude,
    required this.longitude,
  });

  static double _safeDoubleParse(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  factory MemberLocation.fromJson(Map<String, dynamic> json) {
    final userObj = json['user'] ?? {};

    return MemberLocation(
      userId: userObj['id'] ?? 0,
      username: userObj['username'] ?? 'Unknown',
      latitude: _safeDoubleParse(json['latitude']),
      longitude: _safeDoubleParse(json['longitude']),
    );
  }
}