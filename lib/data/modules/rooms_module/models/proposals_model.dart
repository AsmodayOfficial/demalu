// proposals_model.dart (Обновление для поддержки weather, prediction, details)

class Proposal {
  final int id;
  final int roomId;
  final String proposedName;
  final String proposedAddress;
  final DateTime proposedDate;
  final int likes;
  final int dislikes;
  final String proposerUsername;
  
  // НОВЫЕ ПОЛЯ для модалки:
  final String? whether;
  final String? prediction;
  final String? details;


  Proposal({
    required this.id,
    required this.roomId,
    required this.proposedName,
    required this.proposedAddress,
    required this.proposedDate,
    required this.likes,
    required this.dislikes,
    required this.proposerUsername,
    this.whether,
    this.prediction,
    this.details,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    final user = json['proposer'] ?? {};
    
    final dateString = json['proposedDateStart'] ?? '';
    
    return Proposal(
      id: json['id'],
      roomId: json['roomId'],
      proposedName: json['proposedName'] ?? 'Без названия',
      proposedAddress: json['proposedAddress'] ?? 'Адрес не указан',
      proposedDate: DateTime.tryParse(dateString) ?? DateTime.now(),
      
      likes: json['acceptCount'] ?? 0,
      dislikes: json['rejectCount'] ?? 0,
      proposerUsername: user['username'] ?? 'Неизвестный',
      
      // Парсинг новых полей
      whether: json['whether'],
      prediction: json['prediction'],
      details: json['details'],
    );
  }
}