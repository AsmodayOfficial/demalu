import 'package:demalu/ui/screens/room/widgets/room_card_widget.dart';
import 'package:demalu/ui/styles/styles.dart';
import 'package:flutter/material.dart';

class PublicRoomsScreen extends StatefulWidget {
  const PublicRoomsScreen({super.key});

  @override
  State<PublicRoomsScreen> createState() => _PublicRoomsScreenState();
}

class _PublicRoomsScreenState extends State<PublicRoomsScreen> {
  int itemCount = 10;
  int countMembers = 3;
  int maxMembers = 5;
  String roomTitle = "Горнолыжный спорт";
  String roomSubtitle = "Активный отдых на свежем воздухе";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Общее: $itemCount', style: AppTextStyles.paragraph5),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return RoomCardWidget(
                title: roomTitle,
                subtitle: roomSubtitle,
                countMembers: countMembers,
                maxMembers: maxMembers,
              );
            },
          ),
        ),
      ],
    );
  }
}
