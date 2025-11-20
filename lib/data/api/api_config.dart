class ApiConfig {
  static const String baseUrl = 'https://scarcely-correct-mongrel.ngrok-free.app';
  static const String loginEndpoint = '/api/v1/auth/login';
  static const String registerEndpoint = '/api/v1/auth/register';
  static const String refreshEndpoint = '/api/v1/auth/refresh';
  static const String logoutEndpoint = '/api/v1/auth/logout';
  static const String roomsEndpoint = '/api/v1/rooms';
  static const String joinRoomEndpoint = '/api/v1/rooms/join';
  static const String myRoomEndpoint = '/api/v1/rooms/my';
}