import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';
import '../models/user.dart';

class ApiService {
  final http.Client _client = http.Client();
  String? _accessToken;
  String? _refreshToken;

  // Token management
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('accessToken');
    _refreshToken = prefs.getString('refreshToken');
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  bool get isAuthenticated => _accessToken != null;

  Map<String, String> _getHeaders({bool requiresAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (requiresAuth && _accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  // Auth endpoints
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
    File? avatar,
    File? coverImage,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}');
    
    var request = http.MultipartRequest('POST', url);
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['fullName'] = fullName;

    if (avatar != null) {
      request.files.add(await http.MultipartFile.fromPath('avatar', avatar.path));
    }
    if (coverImage != null) {
      request.files.add(await http.MultipartFile.fromPath('coverImage', coverImage.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      if (data['data']?['accessToken'] != null && data['data']?['refreshToken'] != null) {
        await saveTokens(data['data']['accessToken'], data['data']['refreshToken']);
      }
      return data;
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}');
    final response = await _client.post(
      url,
      headers: _getHeaders(),
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data']?['accessToken'] != null && data['data']?['refreshToken'] != null) {
        await saveTokens(data['data']['accessToken'], data['data']['refreshToken']);
      }
      return data;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<void> logout() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.logout}');
    try {
      await _client.post(
        url,
        headers: _getHeaders(requiresAuth: true),
      );
    } finally {
      await clearTokens();
    }
  }

  Future<User> getCurrentUser() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.currentUser}');
    final response = await _client.get(
      url,
      headers: _getHeaders(requiresAuth: true),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data['data']);
    } else {
      throw Exception('Failed to get current user: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateAccountDetails({
    required String fullName,
    required String email,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.updateAccount}');
    final response = await _client.patch(
      url,
      headers: _getHeaders(requiresAuth: true),
      body: json.encode({
        'fullName': fullName,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update account: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.changePassword}');
    final response = await _client.post(
      url,
      headers: _getHeaders(requiresAuth: true),
      body: json.encode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to change password: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateAvatar(File avatar) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.updateAvatar}');
    
    var request = http.MultipartRequest('PATCH', url);
    request.headers['Authorization'] = 'Bearer $_accessToken';
    request.files.add(await http.MultipartFile.fromPath('avatar', avatar.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update avatar: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateCoverImage(File coverImage) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.updateCoverImage}');
    
    var request = http.MultipartRequest('PATCH', url);
    request.headers['Authorization'] = 'Bearer $_accessToken';
    request.files.add(await http.MultipartFile.fromPath('coverImage', coverImage.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update cover image: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getChannelProfile(String username) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.channelProfile(username)}'
    );
    final response = await _client.get(
      url,
      headers: _getHeaders(requiresAuth: true),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get channel profile: ${response.body}');
    }
  }

  Future<List<dynamic>> getUserHistory() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userHistory}');
    final response = await _client.get(
      url,
      headers: _getHeaders(requiresAuth: true),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to get user history: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> refreshAccessToken() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.refreshToken}');
    final response = await _client.post(
      url,
      headers: _getHeaders(),
      body: json.encode({
        'refreshToken': _refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data']?['accessToken'] != null && data['data']?['refreshToken'] != null) {
        await saveTokens(data['data']['accessToken'], data['data']['refreshToken']);
      }
      return data;
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }
}
