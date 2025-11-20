class Room {
  final int id;
  final String name;
  final String? description;
  final bool isPrivate;
  final int countMembers;
  final int maxMembers;

  Room({
    required this.id,
    required this.name,
    this.description,
    required this.isPrivate,
    required this.countMembers,
    required this.maxMembers,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'] ?? 'Без названия',
      description: json['description'],
      isPrivate: json['isPrivate'] ?? false,
      // Берем countMembers из корня JSON, если null - ставим 0
      countMembers: json['countMembers'] ?? 0, 
      maxMembers: json['maxMembers'] ?? 0,
    );
  }
}