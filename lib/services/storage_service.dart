
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {

Future<void> saveAccessToken(String accessToken) async {
final prefs = await SharedPreferences.getInstance();
await prefs.setString('accessToken', accessToken);
}

Future<void> saveUsername(String username) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
}

Future<String> getAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  if(accessToken == null) {
    throw Exception("Access token not found");
  }
 return accessToken;
}

Future<String> getUsername() async {
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');
  if(username == null) {
    throw Exception("Username not found");
  }
  return username;
}

Future<void> clearAccessToken() async{
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('accessToken');
}

Future<void> savePosts(String jsonString) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('saved_posts', jsonString);
}

}