class ApiConfig {
  static const String baseUrl = 'https://scarcely-correct-mongrel.ngrok-free.app';
  static const String loginEndpoint = '/api/v1/auth/login';
  static const String registerEndpoint = '/api/v1/auth/register';
  static const String refreshEndpoint = '/api/v1/auth/refresh';
  static const String logoutEndpoint = '/api/v1/auth/logout';

  static const String countries = '/api/v1/countries';
  static const String cities = '/api/v1/countriescities/';
  static String getCitiesByid(int countryId) {
    return '$countries/$countryId/cities';
  }

}