import 'package:demalu/ui/styles/styles.dart';
import 'package:demalu/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class CurrentRoomScreen extends StatefulWidget {
  const CurrentRoomScreen({super.key});

  @override
  State<CurrentRoomScreen> createState() => _CurrentRoomScreenState();
}

class _CurrentRoomScreenState extends State<CurrentRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Demalu',
        textStyle: AppTextStyles.heading2.copyWith(
          color: AppColors.primary,
        ),
      ),
      body: const Center(child: Text('Options')),
    );
  }
}
