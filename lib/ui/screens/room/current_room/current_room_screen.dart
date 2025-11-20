import 'package:demalu/core/color_log.dart';
import 'package:demalu/ui/styles/styles.dart';
import 'package:demalu/ui/widgets/custom_appbar.dart';
import 'package:demalu/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
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
  LatLng? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    if (mounted) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Demalu',
        textStyle: AppTextStyles.heading2.copyWith(color: AppColors.primary),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentPosition == null
          ? const Center(child: Text("Не удалось определить местоположение"))
          : Column(
              // <--- ИСПОЛЬЗУЕМ COLUMN ВМЕСТО STACK КАК КОРЕНЬ
              children: [
                // 1. ВЕРХНЯЯ ЧАСТЬ: КАРТА (50% экрана)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Stack(
                    // Stack нужен только для наложения кнопок НА карту
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
                              _buildUserMarker(
                                LatLng(
                                  _currentPosition!.latitude + 0.001,
                                  _currentPosition!.longitude + 0.001,
                                ),
                              ),
                              _buildUserMarker(
                                LatLng(
                                  _currentPosition!.latitude - 0.001,
                                  _currentPosition!.longitude - 0.0005,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Кнопка SOS
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

                      // Кнопка Локации
                      Positioned(
                        right: 10,
                        bottom:
                            20, // Чуть поднял, чтобы не прилипала к низу карты
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
                              } else {
                                _getCurrentLocation();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. НИЖНЯЯ ЧАСТЬ: КОНТЕНТ
                Expanded(
                  // Занимает всё оставшееся место
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Ваш Row, который вызывал ошибку
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Предложения',
                              style: AppTextStyles
                                  .heading3, // Добавил стиль для красоты
                            ),
                            // ОБЯЗАТЕЛЬНО ограничиваем ширину кнопки или оборачиваем в Flexible
                            CustomButton(
                              width: 160, // <--- ВАЖНО: Фиксированная ширина
                              height: 40, // Можно сделать поменьше
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

                        // Здесь дальше будет ваш список комнат (ListView)
                        const SizedBox(height: 20),
                        const Center(child: Text("Здесь будет список")),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Marker _buildUserMarker(LatLng point, {bool isMe = false}) {
    return Marker(
      point: point,
      width: isMe ? 32 : 24,
      height: isMe ? 32 : 24,
      child: Container(
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : Colors.blue,
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
    );
  }
}
