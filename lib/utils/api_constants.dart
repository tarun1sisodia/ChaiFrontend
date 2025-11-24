class ApiConstants {
  // Update this with your actual backend URL
  static const String baseUrl = 'http://localhost:8000';
  static const String apiVersion = '/api/v1';
  
  // User endpoints
  static const String register = '$apiVersion/users/register';
  static const String login = '$apiVersion/users/login';
  static const String logout = '$apiVersion/users/logout';
  static const String refreshToken = '$apiVersion/users/refresh-token';
  static const String currentUser = '$apiVersion/users/current-user';
  static const String updateAccount = '$apiVersion/users/update-account';
  static const String changePassword = '$apiVersion/users/change-password';
  static const String updateAvatar = '$apiVersion/users/avatar-update';
  static const String updateCoverImage = '$apiVersion/users/coverImage-update';
  static const String userHistory = '$apiVersion/users/history';
  
  // Channel endpoints
  static String channelProfile(String username) => 
      '$apiVersion/users/c/$username';
}
