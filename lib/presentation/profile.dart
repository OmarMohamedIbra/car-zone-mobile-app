import 'package:carzone_demo/data/api.dart';
import 'package:carzone_demo/presentation/auth.dart';
import 'package:carzone_demo/presentation/event.dart';
import 'package:carzone_demo/presentation/contact_support_page.dart';
import 'package:carzone_demo/presentation/feedback_page.dart';
import 'package:carzone_demo/presentation/about_carzone_page.dart';
import 'package:flutter/material.dart';
import 'package:encrypt_shared_preferences/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  bool _notificationsEnabled = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        _buildProfileHeader(),
                        const SizedBox(height: 20),
                        _buildRegisteredEvents(),
                        const SizedBox(height: 20),
                        _buildAccountSettings(),
                        const SizedBox(height: 20),
                        _buildSupportAbout(),
                        const SizedBox(height: 20),
                        _buildLogoutButton(),
                        const SizedBox(height: 100), // Space for bottom nav
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      //bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFDAA520).withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '👤',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(width: 10),
          Text(
            'My Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFFDAA520),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return FutureBuilder<Map<String, String>>(
      future: _getProfileInfo(),
      builder: (context, snapshot) {
        final name = snapshot.data?['name'] ?? '';
        final email = snapshot.data?['email'] ?? '';
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFDAA520).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, String>> _getProfileInfo() async {
    final prefs = EncryptedSharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    final email = prefs.getString('email') ?? '';
    return {'name': name, 'email': email};
  }

  Widget _buildRegisteredEvents() {
    return _buildSection(
      '🎪 Registered Events',
      Column(
        children: [
          _buildEventCard(
            'https://source.unsplash.com/random/300x200/?cars,show',
            'Cairo Auto Show 2025',
            'June 20, 2025',
            'Active',
          ),
          const SizedBox(height: 15),
          _buildEventCard(
            'https://source.unsplash.com/random/300x200/?bmw,driving',
            'BMW Driving Experience',
            'June 25, 2025',
            'Active',
          ),
          const SizedBox(height: 15),
          _buildEventCard(
            'https://source.unsplash.com/random/300x200/?electric,car',
            'Electric Vehicle Summit',
            'June 18, 2025',
            'Active',
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              _showSnackBar('Redirecting to all registered events...');
            },
            child: const Text(
              'View all registered events →',
              style: TextStyle(
                color: Color(0xFFDAA520),
                fontSize: 13,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(String imageUrl, String name, String date, String status) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFDAA520).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.car_rental, color: Colors.white),
                );
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text('📅', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 5),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF28a745), Color(0xFF20c997)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
    return _buildSection(
      '⚙️ Account Settings',
      Column(
        children: [
          _buildSettingItem(
            '🔔',
            'Notifications',
            _notificationsEnabled ? 'Enabled' : 'Disabled',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              activeColor: const Color(0xFFDAA520),
            ),
          ),
          _buildSettingItem('🌐', 'Language', 'English', onTap: () => _showSnackBar('Opening Language settings...'),trailing: SizedBox()),
          _buildSettingItem('🔒', 'Privacy', 'Standard', onTap: () => _showSnackBar('Opening Privacy settings...'),trailing: SizedBox()),
        ],
      ),
    );
  }

  Widget    _buildSupportAbout() {
    return _buildSection(
      '❤️ Support & About',
      Column(
        children: [
          _buildSettingItem('📩', 'Contact Support', '', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ContactSupportPage()))),
          _buildSettingItem('📝', 'Feedback', '', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackPage()))),
          _buildSettingItem('ℹ️', 'About CarZone', '', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutCarZonePage()))),
          _buildSettingItem('📱', 'App Version', 'v1.0.1'),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFDAA520).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFDAA520),
            ),
          ),
          const SizedBox(height: 15),
          content,
        ],
      ),
    );
  }

  Widget _buildSettingItem(String icon, String name, String value, {Widget? trailing, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFDAA520).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  if (value.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ]
                ],
              ),
            ),
            trailing ?? (onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54) : const SizedBox()),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDAA520).withOpacity(0.2),
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: const Color(0xFFDAA520).withOpacity(0.5),
              width: 1,
            ),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🚪', style: TextStyle(fontSize: 18)),
            SizedBox(width: 10),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFDAA520),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildBottomNavigation() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF1a1a2e).withOpacity(0.95),
  //       border: Border(
  //         top: BorderSide(
  //           color: const Color(0xFFDAA520).withOpacity(0.3),
  //           width: 1,
  //         ),
  //       ),
  //     ),
  //     child: BottomNavigationBar(
  //       type: BottomNavigationBarType.fixed,
  //       backgroundColor: Colors.transparent,
  //       elevation: 0,
  //       currentIndex: 4, // Profile tab
  //       selectedItemColor: const Color(0xFFDAA520),
  //       unselectedItemColor: Colors.white.withOpacity(0.6),
  //       selectedFontSize: 12,
  //       unselectedFontSize: 12,
  //       items: const [
  //         BottomNavigationBarItem(icon: Text('🏠', style: TextStyle(fontSize: 20)), label: 'Home'),
  //         BottomNavigationBarItem(icon: Text('🚗', style: TextStyle(fontSize: 20)), label: 'Cars'),
  //         BottomNavigationBarItem(icon: Text('💝', style: TextStyle(fontSize: 20)), label: 'Deals'),
  //         BottomNavigationBarItem(icon: Text('🎪', style: TextStyle(fontSize: 20)), label: 'Events'),
  //         BottomNavigationBarItem(icon: Text('👤', style: TextStyle(fontSize: 20)), label: 'Profile'),
  //       ],
  //       onTap: (index) {
  //         // Handle navigation
  //         _showSnackBar('Navigating to ${['Home', 'Cars', 'Deals', 'Events', 'Profile'][index]}...');
  //       },
  //     ),
  //   );
  // }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF16213e),
          title: const Text('Logout', style: TextStyle(color: Colors.white)),
          content: const Text('Are you sure you want to logout?', style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () {
                 Navigator.of(context).pop();},
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () {
                Api.logout(); // Call your logout API here
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()), // Replace with your login screen
                );
                _showSnackBar('You have been successfully logged out.');
              },
              child: const Text('Logout', style: TextStyle(color: Color(0xFFDAA520))),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF16213e),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Main App Widget (for testing purposes)
class CarZoneApp extends StatelessWidget {
  const CarZoneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarZone Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(const CarZoneApp());
}