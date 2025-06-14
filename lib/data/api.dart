import 'dart:convert';
import 'dart:async';
import 'package:carzone_demo/data/responses/get_car_response.dart';
import 'package:carzone_demo/presentation/carStore.dart' show Car;
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:http/http.dart' as http;

class Comment {
  final int id;
  final int userId;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, int> reactionsSummary;

  Comment({
    required this.id,
    required this.userId,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    required this.reactionsSummary,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['user_id'],
      body: json['body'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      reactionsSummary: Map<String, int>.from(json['reactions_summary'] ?? {}),
    );
  }
}

class Api {
  static const String baseUrl = "http://191.96.53.235:8084";

  static Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl${'/api/login'}');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        // final data = jsonDecode(response.body);
        // final prefs = EncryptedSharedPreferences.getInstance();
        // await prefs.setString('token', data['token']);
        return true;
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        // Incorrect credentials
        return false;
      } else {
        // Server error
        throw Exception('Server error');
      }
    } on http.ClientException catch (_) {
      throw Exception('Network error');
    } catch (e) {
      throw Exception('Network error');
    }
  }

  static Timer? _refreshTimer;
  static void _cancelRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  static Future<void> refreshToken({bool scheduleNext = true}) async {
    final prefs = EncryptedSharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');
    final isCompany = prefs.getBool('isCompany') ?? false;
    final url = Uri.parse(
      isCompany ? '$baseUrl/company/refresh' : '$baseUrl/refresh',
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await prefs.setString('accessToken', data['accessToken']);
      await prefs.setString('refreshToken', data['refreshToken']);
      // Schedule next refresh based on expiresIn, but avoid multiple timers
      if (scheduleNext && data['expiresIn'] != null) {
        final int expiresIn = data['expiresIn'];
        final int refreshAfter =
            (expiresIn > 35)
                ? (expiresIn - 30)
                : (expiresIn > 5 ? expiresIn - 5 : expiresIn);

        _cancelRefreshTimer();
        _refreshTimer = Timer(Duration(seconds: refreshAfter), () async {
          await Api.refreshToken();
        });
      }
    }
  }

  static Future<String?> getAccessToken() async {
    final prefs = EncryptedSharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // --- Register implementation ---
  static Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/register');
      final body = {
        "email": email,
        "password": password,
        "fname": firstName,
        "lname": lastName,
        "phone_no": phoneNumber,
        "address": address,
      };
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 201) {
        return true;
      } else {
        // Optionally, you can parse response.body for error details
        return false;
      }
    } catch (e) {
      // Handle network/server error
      return false;
    }
  }

  // --- Company Register implementation ---
  static Future<bool> registerCompany({
    required String id,
    required String email,
    required String password,
    required String companyName,
    required String phoneNumber,
    String? about,
    required String birthDate, // Format: yyyy-MM-dd
    required String city,
    required String industry,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/company/register');
      final body = {
        "id": id,
        "email": email,
        "password": password,
        "companyName": companyName,
        "phoneNumber": phoneNumber,
        "about": about,
        "birthDate": birthDate,
        "city": city,
        "industry": industry,
      };
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        // Optionally, parse error message from backend and show to user
        // Example:
        // final error = jsonDecode(response.body)['error'] ?? 'Registration failed';
        // throw Exception(error);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<List<Car>> getCars() async {
    final url = Uri.parse('$baseUrl/api/cars');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final getCarResponse = GetCarResponse.fromJson(jsonBody);
      final cars = getCarResponse.data?.map((data) => Car.fromData(data)).toList() ?? [];
      return cars;
    } else {
      throw Exception('Failed to load cars');
    }
  }

  static Future<String> contactUs({
    required String name,
    required String email,
    required String body,
  }) async {
    final url = Uri.parse('$baseUrl/api/contact');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'body': body,
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return jsonBody['message'] ?? 'Message sent.';
    } else {
      throw Exception('Failed to send contact message');
    }
  }

  static Future<List<Comment>> getComment() async {
    final url = Uri.parse('$baseUrl/api/comments');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List data = jsonBody['data'] ?? [];
      return data.map((e) => Comment.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  static Future<Comment> createComment({
    required int userId,
    required String body,
  }) async {
    final url = Uri.parse('$baseUrl/api/comments');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'body': body,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonBody = jsonDecode(response.body);
      return Comment.fromJson(jsonBody['comment']);
    } else {
      throw Exception('Failed to create comment');
    }
  }
}
