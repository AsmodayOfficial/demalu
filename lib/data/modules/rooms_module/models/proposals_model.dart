// proposals_model.dart

class Proposal {
  final int id;
  final int roomId;
  final String proposedName;
  final String proposedAddress;
  final DateTime proposedDate;
  final int likes; // Маппится на acceptCount из API
  final int dislikes; // Маппится на rejectCount из API
  final String proposerUsername;

  Proposal({
    required this.id,
    required this.roomId,
    required this.proposedName,
    required this.proposedAddress,
    required this.proposedDate,
    required this.likes,
    required this.dislikes,
    required this.proposerUsername,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    final user = json['proposer'] ?? {};

    // В API передаются proposedDateStart и proposedDateEnd.
    // Для отображения в карточке используем proposedDateStart.
    final dateString = json['proposedDateStart'] ?? json['proposedDate'] ?? '';

    return Proposal(
      id: json['id'],
      roomId: json['roomId'],
      proposedName: json['proposedName'] ?? 'Без названия',
      proposedAddress: json['proposedAddress'] ?? 'Адрес не указан',
      proposedDate: DateTime.tryParse(dateString) ?? DateTime.now(),

      // ИСПРАВЛЕНИЕ: Маппинг полей API на локальные поля likes и dislikes
      likes: json['acceptCount'] ?? 0,
      dislikes: json['rejectCount'] ?? 0,

      proposerUsername: user['username'] ?? 'Неизвестный',
    );
  }
}
