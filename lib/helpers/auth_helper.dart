import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/access.dart';

class AuthHelper {
  static const String loginUrl = 'https://dummyjson.com/auth/login';

  static Future<Access> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Parse the response into an Access model
      final access = Access.fromJson({
        'username': data['username'],
        'email': data['email'],
        'accessToken': data['acessToken'],
      });

     
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', access.accessToken);

      return access;
    } else {
      throw Exception('Login failed. Please check your credentials.');
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
