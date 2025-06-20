import 'package:flutter/material.dart';
import 'package:carzone_demo/data/api.dart' as api;
import 'package:carzone_demo/data/models.dart';
import 'carStore.dart' as car_store;
import 'event.dart';
import 'profile.dart' as profile;
import 'package:encrypt_shared_preferences/provider.dart';

class CarZoneHomeScreen extends StatefulWidget {
  @override
  _CarZoneHomeScreenState createState() => _CarZoneHomeScreenState();
}

class _CarZoneHomeScreenState extends State<CarZoneHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int selectedNavIndex = 0;
  String? _userName;
  Future<List<api.Comment>>? _commentsFuture;

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
    _loadUserName();
    _commentsFuture = api.Api.getComment();
  }

  Future<void> _loadUserName() async {
    final prefs = EncryptedSharedPreferences.getInstance();
    final name = await prefs.getString('name');
    setState(() {
      _userName = name;
    });
  }

  void _reloadComments() {
    setState(() {
      _commentsFuture = api.Api.getComment();
    });
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
            _userName ?? '',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
    return FutureBuilder<List<api.Comment>>(
      future: _commentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Color(0xFFDAA520)));
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load comments', style: TextStyle(color: Colors.red)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No comments yet.', style: TextStyle(color: Colors.white70)));
        }
        final comments = snapshot.data!;
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
              ...comments.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: _buildCommentCard(c),
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentCard(api.Comment comment) {
    bool _showReactions = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => _showReactions = true),
          onExit: (_) => setState(() => _showReactions = false),
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - _fadeAnimation.value)),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xFFDAA520).withOpacity(0.2)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            comment.body,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              height: 1.6,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            comment.createdAt.toLocal().toString().split(' ')[0],
                            style: TextStyle(fontSize: 12, color: Colors.white54),
                          ),
                          SizedBox(height: 10),
                          AnimatedOpacity(
                            opacity: _showReactions ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: _showReactions ? _buildReactionsRow(comment.reactionsSummary, enableReact: true, commentId: comment.id) : SizedBox.shrink(),
                          ),
                          if (!_showReactions)
                            _buildReactionsRow(comment.reactionsSummary, enableReact: false, commentId: comment.id),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildReactionsRow(Map<String, int> reactionCounts, {bool enableReact = false, int? commentId}) {
    final reacts = [
      {'emoji': '😂', 'label': 'haha'},
      {'emoji': '👍', 'label': 'like'},
      {'emoji': '❤️', 'label': 'love'},
      {'emoji': '😮', 'label': 'wow'},
      {'emoji': '😢', 'label': 'sad'},
      {'emoji': '😡', 'label': 'angry'},
    ];
    return StatefulBuilder(
      builder: (context, setState) {
        // Make a local copy to update UI instantly
        final localCounts = Map<String, int>.from(reactionCounts);
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: reacts.map((react) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Column(
                  children: [
                    IconButton(
                      onPressed: enableReact && commentId != null ? () async {
                        final prefs = EncryptedSharedPreferences.getInstance();
                        final userId = await prefs.getInt('user_id');
                        if (userId != null) {
                          try {
                            await api.Api.createReact(
                              userId: userId,
                              commentId: commentId,
                              type: react['label']!,
                            );
                            // Reload comments to update reaction counters
                            if (mounted) {
                              _reloadComments();
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Reacted with ${react['label']}'),
                                backgroundColor: Color(0xFFDAA520),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to react'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('You must be logged in to react.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } : null,
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
                        (localCounts[react['label']] ?? 0).toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
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
                          // Example: userId = 1 (replace with actual user id if available)
                          await api.Api.createComment(userId: 1, body: commentText.trim());
                          Navigator.of(context).pop();
                          setState(() {}); // Refresh comments
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
                    child: Text('Add', style: TextStyle(color: Color(0xFFDAA520))),
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
