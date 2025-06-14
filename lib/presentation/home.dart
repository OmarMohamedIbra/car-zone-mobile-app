import 'package:flutter/material.dart';
import 'package:carzone_demo/data/api.dart';
import 'package:carzone_demo/data/models.dart';
import 'carStore.dart' as car_store;
import 'event.dart';
import 'profile.dart' as profile;

class CarZoneHomeScreen extends StatefulWidget {
  @override
  _CarZoneHomeScreenState createState() => _CarZoneHomeScreenState();
}

class _CarZoneHomeScreenState extends State<CarZoneHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Widget> get _pages => [
    _buildHomeContent(),
    car_store.CarStoreScreen(),
    CarEventsScreen(),
    profile.CarZoneApp(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedNavIndex, children: _pages),
      floatingActionButton:
          selectedNavIndex == 0 ? _buildFloatingActionButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  void _onNavTap(int index) {
    setState(() {
      selectedNavIndex = index;
    });
  }

  Widget _buildHomeContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildSearchBar(),
                    _buildHotDealsSection(),
                    _buildTestimonialsSection(),
                    SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFDAA520).withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          FadeTransition(opacity: _fadeAnimation, child: _buildLogo()),
          SizedBox(height: 15),
          Text(
            'Welcome back',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: Color(0xFFDAA520),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Omar Mohamed',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car, size: 40, color: Color(0xFFDAA520)),
          SizedBox(width: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'CAR',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: 'ZONE',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDAA520),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(20),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search for cars, deals, services...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Color(0xFFDAA520).withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Color(0xFFDAA520).withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Color(0xFFDAA520)),
          ),
          suffixIcon: Icon(Icons.search, color: Color(0xFFDAA520)),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildHotDealsSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('🔥', style: TextStyle(fontSize: 24)),
                SizedBox(width: 10),
                Text(
                  'Hot Deals',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFDAA520),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 250,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildDealCard(
                  'LIMITED TIME',
                  'Lotus Emira',
                  'Lightweight design with agile handling',
                  '£495,000',
                  '£520,000',
                ),
                _buildDealCard(
                  'BEST SELLER',
                  'Porsche 911 GT3',
                  'Elegant sedan perfect for city driving and long trips',
                  '£380,500',
                  '£430,000',
                ),
                _buildDealCard(
                  'NEW ARRIVAL',
                  'Nissan GT-R',
                  'Latest model with cutting-edge technology',
                  '£420,000',
                  '£470,500',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealCard(
    String badge,
    String title,
    String description,
    String price,
    String originalPrice,
  ) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _fadeAnimation.value)),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: 280,
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFDAA520).withOpacity(0.2)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Selected: $title'),
                        backgroundColor: Color(0xFFDAA520),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFDAA520), Color(0xFFFFD700)],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1a1a2e),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Text("Deposit:" , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white),),
                        Row(
                          children: [
                            Text(
                              price,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFDAA520),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              originalPrice,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.5),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          );
      },
    );
  }

  Widget _buildTestimonialsSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('💬', style: TextStyle(fontSize: 24)),
              SizedBox(width: 10,),
              Text(
                'What Our Customers Say',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFDAA520),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildTestimonialCard(
            'S',
            'Sarah Ahmed',
            '"Amazing service! Found my dream car at an unbeatable price. The team was professional and made the buying process so smooth."',
          ),
          SizedBox(height: 15),
          _buildTestimonialCard(
            'M',
            'Mohamed Ali',
            '"Best car dealership in town! Great deals, honest pricing, and excellent customer service. Highly recommended!"',
          ),
          SizedBox(height: 15),
          _buildTestimonialCard(
            'F',
            'Fatima Hassan',
            '"Bought my first car from CarZone and couldn\'t be happier! They helped me find the perfect match within my budget."',
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(
    String initial,
    String name,
    String testimonial,
  ) {
    // Add a map to hold reaction counts for this card (in a real app, this would come from backend)
    Map<String, int> reactionCounts = {
      'haha': 0,
      'like': 0,
      'love': 0,
      'wow': 0,
      'sad': 0,
      'angry': 0,
    };
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _fadeAnimation.value)),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFDAA520).withOpacity(0.2)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFDAA520),
                                    Color(0xFFFFD700),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Text(
                                  initial,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1a1a2e),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  // Text('⭐⭐⭐⭐⭐', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                          testimonial,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 15),
                        _buildReactionsRow(reactionCounts),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          );
      },
    );
  }

  Widget _buildReactionsRow(Map<String, int> reactionCounts) {
    final reacts = [
      {'emoji': '😂', 'label': 'haha'},
      {'emoji': '👍', 'label': 'like'},
      {'emoji': '❤️', 'label': 'love'},
      {'emoji': '😮', 'label': 'wow'},
      {'emoji': '😢', 'label': 'sad'},
      {'emoji': '😡', 'label': 'angry'},
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: reacts.map((react) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    // In a real app, update state and backend
                    reactionCounts[react['label']!] = (reactionCounts[react['label']!] ?? 0) + 1;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reacted with ${react['label']}'),
                        backgroundColor: Color(0xFFDAA520),
                      ),
                    );
                  },
                  icon: Text(
                    react['emoji']!,
                    style: TextStyle(fontSize: 22),
                  ),
                  tooltip: react['label'],
                ),
                Container(
                  width: 24,
                  alignment: Alignment.center,
                  child: Text(
                    reactionCounts[react['label']!].toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDAA520), Color(0xFFFFD700)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFDAA520).withOpacity(0.4),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () async {
          // Show dialog to enter comment
          String commentText = '';
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xFF1a1a2e),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  'Add Comment',
                  style: TextStyle(color: Colors.white),
                ),
                content: TextField(
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Type your comment...',
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (value) {
                    commentText = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel', style: TextStyle(color: Color(0xFFDAA520))),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (commentText.trim().isNotEmpty) {
                        try {
                          // Example: userId = 1
                          // await Api.createComment(Comment(userId: 1, body: commentText.trim()));
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Comment added!'), backgroundColor: Color(0xFFDAA520)),
                          );
                        } catch (e) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to add comment'), backgroundColor: Colors.red),
                          );
                        }
                      }
                    },
                    child: Text('Send', style: TextStyle(color: Color(0xFFDAA520))),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(Icons.add, size: 30, color: Color(0xFF1a1a2e)),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1a1a2e).withOpacity(0.95),
        border: Border(
          top: BorderSide(color: Color(0xFFDAA520).withOpacity(0.3), width: 1),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: selectedNavIndex,
        onTap: _onNavTap,
        selectedItemColor: Color(0xFFDAA520),
        unselectedItemColor: Colors.white.withOpacity(0.6),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: Text('🏠', style: TextStyle(fontSize: 20)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Text('🚗', style: TextStyle(fontSize: 20)),
            label: 'Cars',
          ),
          BottomNavigationBarItem(
            icon: Text('🎪', style: TextStyle(fontSize: 20)),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Text('👤', style: TextStyle(fontSize: 20)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Main App
class CarZoneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarZone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Segoe UI',
      ),
      home: CarZoneHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(CarZoneApp());
}
