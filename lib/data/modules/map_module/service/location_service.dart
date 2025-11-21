import 'dart:async';
import 'package:demalu/core/color_log.dart';
import 'package:demalu/data/api/api_config.dart';
import 'package:demalu/data/auth/storage_service.dart';
import 'package:demalu/data/modules/map_module/models/member_location.dart';
// Важно: используем алиас IO, чтобы не путаться с dart:io
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LocationSocketService {
  IO.Socket? _socket;
  
  final _locationStreamController = StreamController<MemberLocation>.broadcast();
  Stream<MemberLocation> get locationStream => _locationStreamController.stream;

  final _initialLocationsController = StreamController<List<MemberLocation>>.broadcast();
  Stream<List<MemberLocation>> get initialLocationsStream => _initialLocationsController.stream;

  Future<void> connect() async {
    final token = await StorageService.instance.getAccessToken();
    
    if (token == null) {
      colorLog("Socket: No token found", color: 'red');
      return;
    }

    _socket = IO.io(
      ApiConfig.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket']) 
          .disableAutoConnect() 
          .setExtraHeaders({'Authorization': 'Bearer $token'}) 
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      colorLog('Socket connected', color: 'green');
    });

    _socket!.onDisconnect((_) {
      colorLog('Socket disconnected', color: 'red');
    });

    _socket!.onConnectError((data) {
      colorLog('Socket connection error: $data', color: 'red');
    });

   _socket!.on('initialRoomLocations', (data) {
      try {
        if (data is List) {
          // Парсим список с учетом новой логики
          final locations = data.map((e) => MemberLocation.fromJson(e)).toList();
          
          _initialLocationsController.add(locations);
          colorLog('Received initial locations: ${locations.length}', color: 'cyan');
        } else {
          colorLog("Received initial locations but data is not a List: $data", color: 'red');
        }
      } catch (e, stackTrace) {
        colorLog("Error parsing initialRoomLocations: $e", color: 'red');
        print(stackTrace);
      }
    });

    _socket!.on('memberLocationUpdated', (data) {
      try {
        final location = MemberLocation.fromJson(data);
        _locationStreamController.add(location);
      } catch (e) {
        print("Error parsing location update: $e");
      }
    });
  }

  void sendLocation(double lat, double lng, double accuracy) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('updateLocation', {
        'latitude': lat,
        'longitude': lng,
        'accuracy': accuracy,
      });
    }
  }

  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    _locationStreamController.close();
    _initialLocationsController.close();
  }
}