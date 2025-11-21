import 'dart:async';
import 'package:demalu/core/color_log.dart';
import 'package:demalu/data/modules/map_module/models/member_location.dart';
import 'package:demalu/data/modules/map_module/service/location_service.dart';
import 'package:demalu/data/modules/map_module/service/maps_service.dart';
import 'package:demalu/data/modules/rooms_module/models/rooms_model.dart';
import 'package:demalu/ui/screens/home/home_screen.dart';
import 'package:demalu/ui/styles/styles.dart';
import 'package:demalu/ui/widgets/custom_appbar.dart';
import 'package:demalu/ui/widgets/custom_button.dart';
import 'package:demalu/ui/widgets/custom_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class CurrentRoomScreen extends StatefulWidget {
  const CurrentRoomScreen({super.key});

  @override
  State<CurrentRoomScreen> createState() => _CurrentRoomScreenState();
}

class _CurrentRoomScreenState extends State<CurrentRoomScreen> {
  final MapController _mapController = MapController();
  final MapsService _mapsService = MapsService();
  final LocationSocketService _socketService = LocationSocketService();

  LatLng? _currentPosition;
  Room? _currentRoom;
  bool _isLoading = true;

  final Map<int, MemberLocation> _otherMembers = {};
  
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<MemberLocation>? _socketLocationSubscription;
  StreamSubscription<List<MemberLocation>>? _socketInitialSubscription;

  @override
  void initState() {
    super.initState();
    _loadRoomData();
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

  Future<void> _initLocationAndSocket() async {
    final hasPermission = await _checkPermissions();
    if (!hasPermission) return;

    await _socketService.connect();

    _socketInitialSubscription = _socketService.initialLocationsStream.listen((members) {
      if (mounted) {
        setState(() {
          _otherMembers.clear();
          for (var member in members) {
            _otherMembers[member.userId] = member;
          }
        });
      }
    });

    // 4. Слушаем обновления перемещений
    _socketLocationSubscription = _socketService.locationStream.listen((member) {
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

    _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      
      final newPos = LatLng(position.latitude, position.longitude);
      
      if (mounted) {
        setState(() {
          _currentPosition = newPos;
          _isLoading = false;
        });
      }

      _socketService.sendLocation(
        position.latitude, 
        position.longitude, 
        position.accuracy
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _currentRoom != null ? 'PIN: ${_currentRoom!.pin}' : 'Загрузка...',
        textStyle: AppTextStyles.heading2.copyWith(color: AppColors.primary),
        actions: [
           if (_currentRoom != null)
            IconButton(
              icon: const Icon(Icons.copy, color: AppColors.primary),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _currentRoom!.pin));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("PIN скопирован"), duration: Duration(seconds: 1)),
                );
              },
            )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentPosition == null
              ? const Center(child: Text("Не удалось определить местоположение"))
              : Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
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
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.demalu',
                              ),
                              MarkerLayer(
                                markers: [
                                  // 1. Мой маркер
                                  _buildUserMarker(_currentPosition!, isMe: true),
                                  
                                  // 2. Маркеры других участников из сокета
                                  ..._otherMembers.values.map((member) {
                                    return _buildUserMarker(
                                      LatLng(member.latitude, member.longitude),
                                      isMe: false,
                                      username: member.username, // Передаем имя
                                    );
                                  }).toList(),
                                ],
                              ),
                            ],
                          ),
                          // ... Кнопки SOS и MyLocation (оставьте как есть)
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
                    // ... Нижняя панель с кнопками
                    Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Предложения', style: AppTextStyles.heading3),
                            CustomButton(
                              width: 160,
                              height: 40,
                              onTap: () {},
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

                        const SizedBox(height: 20),
                        CustomButton(
                          text: "Покинуть комнату",
                          backgroundColor: Colors.red[100],
                          textColor: Colors.red,
                          onTap: _showLeaveConfirmation,
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
      width: isMe ? 32 : 60, // Чуть шире для других, если будем показывать имя
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
                boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black26)],
              ),
              child: Text(
                username,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          Container(
            width: isMe ? 32 : 24,
            height: isMe ? 32 : 24,
            decoration: BoxDecoration(
              color: isMe ? AppColors.primary : Colors.green, // Другие участники зеленым
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