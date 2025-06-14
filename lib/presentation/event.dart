import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarZone Events',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Segoe UI'),
      home: CarEventsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CarEventsScreen extends StatefulWidget {
  @override
  _CarEventsScreenState createState() => _CarEventsScreenState();
}

class _CarEventsScreenState extends State<CarEventsScreen>
    with TickerProviderStateMixin {
  String selectedFilter = 'all';
  int selectedNavIndex = 3; // Events tab
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
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
              _buildHeader(),
              _buildFilterTabs(),
              Expanded(child: _buildEventsList()),
            ],
          ),
        ),
      ),
    ); // Close Scaffold without bottomNavigationBar
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🎪', style: TextStyle(fontSize: 24)),
              SizedBox(width: 10),
              Text(
                'Car Events',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFDAA520),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            '12 events this month',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterTab('All Events', 'all'),
          SizedBox(width: 10),
          _buildFilterTab('Active', 'active'),
          SizedBox(width: 10),
          _buildFilterTab('Past Events', 'expired'),
          SizedBox(width: 10),
          _buildFilterTab('This Week', 'this-week'),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String title, String value) {
    bool isActive = selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color:
              isActive
                  ? Color(0xFFDAA520).withOpacity(0.2)
                  : Colors.white.withOpacity(0.1),
          border: Border.all(
            color:
                isActive
                    ? Color(0xFFDAA520)
                    : Color(0xFFDAA520).withOpacity(0.3),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Color(0xFFDAA520) : Colors.white.withOpacity(0.7),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    List<EventData> filteredEvents = _getFilteredEvents();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: filteredEvents.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: _buildEventCard(filteredEvents[index], index),
          );
        },
      ),
    );
  }

  Widget _buildEventCard(EventData event, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(
          color:
              event.isExpired
                  ? Colors.white.withOpacity(0.2)
                  : Color(0xFFDAA520).withOpacity(0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildEventHeader(event), _buildEventDetails(event)],
            ),
            Positioned(top: 15, right: 15, child: _buildEventStatus(event)),
          ],
        ),
      ),
    );
  }

  Widget _buildEventStatus(EventData event) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient:
            event.isExpired
                ? null
                : LinearGradient(
                  colors: [Color(0xFF28a745), Color(0xFF20c997)],
                ),
        color: event.isExpired ? Colors.grey.withOpacity(0.8) : null,
      ),
      child: Text(
        event.isExpired ? 'EXPIRED' : 'ACTIVE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEventHeader(EventData event) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 100, 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 14,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('📅', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text(
                    event.date,
                    style: TextStyle(
                      color: Color(0xFFDAA520),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🕐', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 6),
                  Text(
                    event.time,
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text('📍', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  event.location,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetails(EventData event) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Topics',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFDAA520),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          ...event.topics
              .map(
                (topic) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Color(0xFFDAA520),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          topic,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          SizedBox(height: 20),
          _buildEventActions(event),
        ],
      ),
    );
  }

  Widget _buildEventActions(EventData event) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed:
                event.isExpired ? null : () => _registerEvent(event.name),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  event.isExpired
                      ? Colors.grey.withOpacity(0.6)
                      : Color(0xFFDAA520),
              foregroundColor:
                  event.isExpired
                      ? Colors.white.withOpacity(0.7)
                      : Color(0xFF1a1a2e),
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: event.isExpired ? 0 : 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(event.isExpired ? '❌' : '✅'),
                SizedBox(width: 8),
                Text(
                  event.isExpired ? 'Event Ended' : 'Register Now',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        if (!event.isExpired) ...[
          SizedBox(width: 10),
          _buildActionButton('🔔', () => _toggleReminder()),
        ],
        SizedBox(width: 10),
        _buildActionButton('📤', () => _shareEvent(event.name)),
      ],
    );
  }

  Widget _buildActionButton(String icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: Color(0xFFDAA520).withOpacity(0.3)),
          shape: BoxShape.circle,
        ),
        child: Center(child: Text(icon, style: TextStyle(fontSize: 16))),
      ),
    );
  }

  List<EventData> _getFilteredEvents() {
    List<EventData> allEvents = _getAllEvents();

    switch (selectedFilter) {
      case 'active':
        return allEvents.where((event) => !event.isExpired).toList();
      case 'expired':
        return allEvents.where((event) => event.isExpired).toList();
      case 'this-week':
        return allEvents.where((event) => event.isThisWeek).toList();
      default:
        return allEvents;
    }
  }

  List<EventData> _getAllEvents() {
    return [
      EventData(
        name: 'Cairo Auto Show 2025',
        date: 'June 20, 2025',
        time: '10:00 AM',
        location: 'Cairo International Convention Center',
        topics: [
          'Latest Electric Vehicle Technology',
          'Luxury Car Showcase',
          'Automotive Innovation Panel',
          'Test Drive Experience',
        ],
        isExpired: false,
        isThisWeek: true,
      ),
      EventData(
        name: 'BMW Driving Experience',
        date: 'June 25, 2025',
        time: '2:00 PM',
        location: 'New Administrative Capital Track',
        topics: [
          'Professional Racing Techniques',
          'BMW M Series Performance',
          'Track Safety Guidelines',
          'Advanced Driving Skills',
        ],
        isExpired: false,
        isThisWeek: false,
      ),
      EventData(
        name: 'Classic Cars Exhibition',
        date: 'June 5, 2025',
        time: '11:00 AM',
        location: 'Downtown Cairo Exhibition Hall',
        topics: [
          'Vintage Car Restoration',
          'Classic Car Investment',
          'Automotive History Timeline',
          'Collector\'s Market Insights',
        ],
        isExpired: true,
        isThisWeek: false,
      ),
      EventData(
        name: 'Electric Vehicle Summit',
        date: 'June 18, 2025',
        time: '9:00 AM',
        location: 'Smart Village Conference Center',
        topics: [
          'Future of Electric Mobility',
          'Charging Infrastructure Development',
          'Battery Technology Advances',
          'Government EV Incentives',
        ],
        isExpired: false,
        isThisWeek: true,
      ),
      EventData(
        name: 'Motorsport Championship',
        date: 'May 30, 2025',
        time: '3:00 PM',
        location: 'Ain Sokhna Racing Circuit',
        topics: [
          'Professional Racing Competition',
          'Racing Car Technology',
          'Driver Safety Equipment',
          'Spectator Experience',
        ],
        isExpired: true,
        isThisWeek: false,
      ),
    ];
  }

  void _registerEvent(String eventName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully registered for "$eventName"!'),
        backgroundColor: Color(0xFFDAA520),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleReminder() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reminder set! You\'ll be notified before the event starts.',
        ),
        backgroundColor: Color(0xFFDAA520),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareEvent(String eventName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event "$eventName" link copied to clipboard!'),
        backgroundColor: Color(0xFFDAA520),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class EventData {
  final String name;
  final String date;
  final String time;
  final String location;
  final List<String> topics;
  final bool isExpired;
  final bool isThisWeek;

  EventData({
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    required this.topics,
    required this.isExpired,
    required this.isThisWeek,
  });
}
