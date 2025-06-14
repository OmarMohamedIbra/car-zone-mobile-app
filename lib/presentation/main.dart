import 'package:carzone_demo/presentation/auth.dart';
import 'package:carzone_demo/presentation/home.dart';
import 'package:flutter/material.dart';
import 'package:encrypt_shared_preferences/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EncryptedSharedPreferences.initialize("carzoneappkey123"); // 16 digits
  runApp(CarZoneApp());
}

class CarZoneApp extends StatefulWidget {
  const CarZoneApp({super.key});

  @override
  State<CarZoneApp> createState() => _CarZoneAppState();
}

class _CarZoneAppState extends State<CarZoneApp> {
  Widget? _startPage;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final prefs = EncryptedSharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      _startPage = token != null && token.isNotEmpty ? CarZoneHomeScreen() : CarZoneAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_startPage == null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _startPage,
    );
  }
}
