// current_room_screen.dart

import 'dart:async';
import 'package:demalu/core/color_log.dart';
import 'package:demalu/data/modules/map_module/models/member_location.dart';
import 'package:demalu/data/modules/map_module/service/location_service.dart';
import 'package:demalu/data/modules/map_module/service/maps_service.dart';
import 'package:demalu/data/modules/rooms_module/models/proposals_model.dart';
import 'package:demalu/data/modules/rooms_module/models/rooms_model.dart';
import 'package:demalu/data/modules/rooms_module/proposals_service/proposals_service.dart';
import 'package:demalu/ui/screens/home/home_screen.dart';
import 'package:demalu/ui/screens/room/proposals/create_proposal_screen.dart';
import 'package:demalu/ui/screens/room/widgets/proposals_card_widget.dart';
import 'package:demalu/ui/styles/styles.dart';
import 'package:demalu/ui/widgets/custom_appbar.dart';
import 'package:demalu/ui/widgets/custom_button.dart';
import 'package:demalu/ui/widgets/custom_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

// Вспомогательная функция для форматирования даты
String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
}

class CurrentRoomScreen extends StatefulWidget {
  const CurrentRoomScreen({super.key});

  @override
  State<CurrentRoomScreen> createState() => _CurrentRoomScreenState();
}

class _CurrentRoomScreenState extends State<CurrentRoomScreen> {
  final MapController _mapController = MapController();
  final MapsService _mapsService = MapsService();
  final LocationSocketService _socketService = LocationSocketService();
  final ProposalsService _proposalsService = ProposalsService();

  LatLng? _currentPosition;
  Room? _currentRoom;
  List<Proposal> _proposals = []; 
  bool _isLoading = true;
  bool _isProposalsLoading = false;

  final Map<int, MemberLocation> _otherMembers = {};

  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<MemberLocation>? _socketLocationSubscription;
  StreamSubscription<List<MemberLocation>>? _socketInitialSubscription;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _initLocationAndSocket();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _socketLocationSubscription?.cancel();
    _socketInitialSubscription?.cancel();
    _socketService.dispose();
    super.dispose();
  }

  // Объединяем загрузку данных комнаты и предложений
  Future<void> _loadInitialData() async {
    await _loadRoomData();
    if (_currentRoom != null) {
      await _fetchProposals();
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadRoomData() async {
    try {
      final room = await _mapsService.getMyRoom();
      if (mounted && room != null) {
        setState(() {
          _currentRoom = room;
        });
      }
    } catch (e) {
      colorLog("Error loading room data: $e", color: 'red');
    }
  }

  // Новый метод для получения списка предложений
  Future<void> _fetchProposals() async {
    if (_currentRoom == null) return;

    if (mounted) setState(() => _isProposalsLoading = true);

    try {
      final proposals = await _proposalsService.getProposals(_currentRoom!.id);
      if (mounted) {
        setState(() {
          _proposals = proposals;
        });
      }
    } catch (e) {
      colorLog("Error fetching proposals: ${e.toString()}", color: 'red');
      if (mounted) {
        // Убираем вывод SnackBar для 404, чтобы не спамить при старте
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("Ошибка загрузки предложений: ${e.toString()}"),
        //   ),
        // );
      }
    } finally {
      if (mounted) setState(() => _isProposalsLoading = false);
    }
  }

  // Новый метод для обработки голосования
  void _handleVote(int proposalId, bool isLike) async {
    try {
      await _proposalsService.vote(proposalId: proposalId, isLike: isLike);
      // После успешного голосования обновляем список предложений
      await _fetchProposals();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ... (методы _initLocationAndSocket, _checkPermissions, _handleLeaveRoom, _showLeaveConfirmation)

  Future<void> _initLocationAndSocket() async {
    final hasPermission = await _checkPermissions();
    if (!hasPermission) return;

    await _socketService.connect();

    _socketInitialSubscription = _socketService.initialLocationsStream.listen((
      members,
    ) {
      if (mounted) {
        setState(() {
          _otherMembers.clear();
          for (var member in members) {
            _otherMembers[member.userId] = member;
          }
        });
      }
    });

    _socketLocationSubscription = _socketService.locationStream.listen((
      member,
    ) {
      if (mounted) {
        setState(() {
          _otherMembers[member.userId] = member;
        });
      }
    });

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(
          locationSettings: locationSettings,
        ).listen((Position position) {
          final newPos = LatLng(position.latitude, position.longitude);

          if (mounted) {
            setState(() {
              _currentPosition = newPos;
            });
          }

          _socketService.sendLocation(
            position.latitude,
            position.longitude,
            position.accuracy,
          );
        });
  }

  Future<bool> _checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      return false;
    }
    return true;
  }

  Future<void> _handleLeaveRoom() async {
    try {
      await _mapsService.leaveRoom();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  void _showLeaveConfirmation() {
    showDialog(
      context: context,
      builder: (context) => CustomModal(
        title: "Выход",
        content: "Вы действительно хотите покинуть комнату?",
        confirmText: "Выйти",
        onConfirm: _handleLeaveRoom,
      ),
    );
  }

  // Обновляем навигацию, чтобы обновить список предложений после создания
  void _navigateToCreateProposal() async {
    if (_currentRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Подождите, данные комнаты еще загружаются."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CreateProposalScreen(currentRoomId: _currentRoom!.id),
      ),
    );

    // Если предложение было успешно создано (предполагаем, что pop(true) был вызван)
    if (result == true) {
      _fetchProposals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _currentRoom != null
            ? 'PIN: ${_currentRoom!.pin}'
            : 'Загрузка...',
        textStyle: AppTextStyles.heading2.copyWith(color: AppColors.primary),
        actions: [
          if (_currentRoom != null)
            IconButton(
              icon: const Icon(Icons.copy, color: AppColors.primary),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _currentRoom!.pin));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("PIN скопирован"),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
        ],
      ),
      body: _isLoading || _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  // ... (Код карты остается без изменений)
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _currentPosition!,
                          initialZoom: 15.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.demalu',
                          ),
                          MarkerLayer(
                            markers: [
                              _buildUserMarker(_currentPosition!, isMe: true),
                              ..._otherMembers.values.map((member) {
                                return _buildUserMarker(
                                  LatLng(member.latitude, member.longitude),
                                  isMe: false,
                                  username: member.username,
                                );
                              }).toList(),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CustomButton(
                            backgroundColor: Colors.redAccent,
                            borderRadius: 50,
                            text: "SOS",
                            onTap: () {
                              colorLog("SOS pressed", color: 'green');
                            },
                          ),
                        ),
                      ),

                      Positioned(
                        right: 10,
                        bottom: 20,
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CustomButton(
                            borderRadius: 50,
                            backgroundColor: Colors.white,
                            icon: const Icon(
                              Icons.my_location,
                              color: AppColors.primary,
                            ),
                            onTap: () {
                              if (_currentPosition != null) {
                                _mapController.move(_currentPosition!, 15);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Предложения', style: AppTextStyles.heading3),
                            CustomButton(
                              width: 160,
                              height: 40,
                              onTap: _navigateToCreateProposal,
                              text: 'Предложить место',
                              backgroundColor: AppColors.primary,
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              borderRadius: 4,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Expanded(
                          child: _isProposalsLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _proposals.isEmpty
                                  ? const Center(
                                      child: Text(
                                        "Нет активных предложений.",
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: _proposals.length,
                                      itemBuilder: (context, index) {
                                        final proposal = _proposals[index];
                                        return ProposalsCardWidget(
                                          title: proposal.proposedName,
                                          subtitle: proposal.proposedAddress,
                                          likes: proposal.likes,
                                          dislikes: proposal.dislikes,
                                          date: _formatDate(
                                            proposal.proposedDate,
                                          ),
                                          onLike: () =>
                                              _handleVote(proposal.id, true),
                                          onDislike: () =>
                                              _handleVote(proposal.id, false),
                                        );
                                      },
                                    ),
                        ),

                        const SizedBox(height: 20),
                        Center(
                          child: CustomButton(
                            width: double.infinity,
                            text: "Покинуть комнату",
                            backgroundColor: Colors.red[100],
                            textColor: Colors.red,
                            onTap: _showLeaveConfirmation,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Marker _buildUserMarker(LatLng point, {bool isMe = false, String? username}) {
    return Marker(
      point: point,
      width: isMe ? 32 : 60,
      height: isMe ? 32 : 60,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isMe && username != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(blurRadius: 2, color: Colors.black26),
                ],
              ),
              child: Text(
                username,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          Container(
            width: isMe ? 32 : 24,
            height: isMe ? 32 : 24,
            decoration: BoxDecoration(
              color: isMe
                  ? AppColors.primary
                  : Colors.green, // Другие участники зеленым
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: isMe
                ? const Icon(Icons.person, size: 16, color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }
}