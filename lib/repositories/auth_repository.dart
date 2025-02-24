import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kingslabs_mt/core/constants/api_endpoints.dart';
import 'package:kingslabs_mt/core/constants/strings.dart';
import 'package:kingslabs_mt/services/storage_service.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "username": username,
            "password": password,
          },
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception(Strings.loginException);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      final storageService = StorageService();
      await storageService.clearAccessToken();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}