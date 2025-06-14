import 'package:carzone_demo/data/api.dart';
import 'package:carzone_demo/data/responses/get_car_response.dart';
import 'package:carzone_demo/presentation/car_booking.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarZone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CarStoreScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Car {
  final String model;
  final int year;
  final String price;
  final String engine;
  final String transmission;
  final String mileage;
  final String fuelType;
  final List<String> features;
  final String emoji;

  Car({
    required this.model,
    required this.year,
    required this.price,
    required this.engine,
    required this.transmission,
    required this.mileage,
    required this.fuelType,
    required this.features,
    required this.emoji,
  });

  factory Car.fromData(Data data) {
    return Car(
      model: data.model ?? '',
      year: data.year ?? 0,
      price: data.price ?? '',
      engine: (data.enginePower != null ? data.enginePower.toString() : ''),
      transmission: data.transmission ?? '',
      mileage: (data.topSpeed != null ? data.topSpeed.toString() : ''),
      fuelType: data.engineType ?? '',
      features: _parseFeatures(data.features),
      emoji: (data.mainImage != null && data.mainImage!.isNotEmpty) ? data.mainImage! : '🚗',
    );
  }

  static List<String> _parseFeatures(dynamic features) {
    if (features == null) return [];
    if (features is List<String>) return features;
    if (features is String) {
      return features.split(RegExp(r'[;,]')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    return [];
  }
}

class CarStoreScreen extends StatefulWidget {
  @override
  _CarStoreScreenState createState() => _CarStoreScreenState();
}

class _CarStoreScreenState extends State<CarStoreScreen>
    with TickerProviderStateMixin {
  String currentSort = 'Default';
  final List<String> sortOptions = ['Default', 'Model', 'Year', 'Least Price', 'Highest Price'];
  bool isDropdownOpen = false;
  
  List<Car> cars = [];
  List<bool> favorites = [];
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadCars();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  Future<void> _loadCars() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = null;
    });
    try {
      final response = await Api.getCars();
      setState(() {
        cars = response;
        favorites = List.generate(cars.length, (index) => false);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e.toString();
      });
      print('Error loading cars: $e');
    }
  }

  void sortCars(String criteria) {
    setState(() {
      currentSort = criteria;
      if (criteria == 'Model') {
        cars.sort((a, b) => a.model.compareTo(b.model));
      } else if (criteria == 'Year') {
        cars.sort((a, b) => b.year.compareTo(a.year)); // Newest first
      } else if (criteria == 'Least Price') {
        cars.sort((a, b) {
          final aPrice = double.tryParse(a.price.replaceAll(',', '')) ?? double.infinity;
          final bPrice = double.tryParse(b.price.replaceAll(',', '')) ?? double.infinity;
          return aPrice.compareTo(bPrice);
        });
      } else if (criteria == 'Highest Price') {
        cars.sort((a, b) {
          final aPrice = double.tryParse(a.price.replaceAll(',', '')) ?? double.negativeInfinity;
          final bPrice = double.tryParse(b.price.replaceAll(',', '')) ?? double.negativeInfinity;
          return bPrice.compareTo(aPrice);
        });
      }
      isDropdownOpen = false;
    });
  }

  void toggleFavorite(int index) {
    setState(() {
      favorites[index] = !favorites[index];
    });
  }

  void bookCar(String carName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CarBookingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int carCount = cars.length;
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
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: Color(0xFFDAA520)))
              : hasError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Failed to load cars. Please try again later.',
                            style: TextStyle(color: Colors.white),
                          ),
                          if (errorMessage != null) ...[
                            SizedBox(height: 16),
                            Text(
                              errorMessage!,
                              style: TextStyle(color: Colors.redAccent, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ]
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Header
                        Container(
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
                              Text(
                                'Our Cars',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFDAA520),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '$carCount cars available',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        // New horizontal sort row
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: sortOptions.map((option) =>
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: ElevatedButton(
                                  onPressed: () => sortCars(option),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: currentSort == option ? Color(0xFFDAA520) : Color(0xFF1a1a2e),
                                    foregroundColor: currentSort == option ? Color(0xFF1a1a2e) : Colors.white,
                                    elevation: currentSort == option ? 2 : 0,
                                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      side: BorderSide(color: Color(0xFFDAA520).withOpacity(0.4)),
                                    ),
                                  ),
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontWeight: currentSort == option ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ).toList(),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Cars List
                        Expanded(
                          child: carCount == 0
                              ? Center(
                                  child: Text(
                                    'No cars available.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(20),
                                    itemCount: carCount,
                                    itemBuilder: (context, index) {
                                      final car = cars[index];
                                      return AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: CarCard(
                                          car: car,
                                          isFavorite: favorites.length > index ? favorites[index] : false,
                                          onFavoriteToggle: () => toggleFavorite(index),
                                          onBook: () => bookCar(car.model),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class CarCard extends StatefulWidget {
  final Car car;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onBook;

  const CarCard({
    Key? key,
    required this.car,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onBook,
  }) : super(key: key);

  @override
  _CarCardState createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _hoverController.forward(),
            onTapUp: (_) => _hoverController.reverse(),
            onTapCancel: () => _hoverController.reverse(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFDAA520).withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  // Car Image
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2a2a3e), Color(0xFF3a3a5e)],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: (widget.car.emoji.startsWith('http') && widget.car.emoji.isNotEmpty)
    ? Image.network(
        widget.car.emoji,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.directions_car, size: 80, color: Color(0xFFDAA520));
        },
      )
    : Icon(Icons.directions_car, size: 80, color: Color(0xFFDAA520)),
                    ),
                  ),

                  // Car Details
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.car.model,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    softWrap: true,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    widget.car.year.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFDAA520),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '\$${widget.car.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFDAA520),
                                    ),
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 15),

                        // Specs Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: [
                            _buildSpecItem('⚡', widget.car.engine),
                            _buildSpecItem('🔧', widget.car.transmission),
                            _buildSpecItem('📊', widget.car.mileage),
                            _buildSpecItem('⛽', widget.car.fuelType),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Features
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Key Features',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFDAA520),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  widget.car.features
                                      .map(
                                        (feature) => Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(
                                              0xFFDAA520,
                                            ).withOpacity(0.2),
                                            border: Border.all(
                                              color: Color(
                                                0xFFDAA520,
                                              ).withOpacity(0.3),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            feature,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFFDAA520),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Actions
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: widget.onBook,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFDAA520),
                                  foregroundColor: Color(0xFF1a1a2e),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('📅', style: TextStyle(fontSize: 16)),
                                    SizedBox(width: 8),
                                    Text(
                                      'Book Now',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: widget.onFavoriteToggle,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color:
                                      widget.isFavorite
                                          ? Color(0xFFDAA520)
                                          : Colors.white.withOpacity(0.1),
                                  border: Border.all(
                                    color: Color(0xFFDAA520).withOpacity(0.3),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    widget.isFavorite ? '♥' : '♡',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color:
                                          widget.isFavorite
                                              ? Color(0xFF1a1a2e)
                                              : Color(0xFFDAA520),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpecItem(String icon, String text) {
    return Row(
      children: [
        Text(icon, style: TextStyle(fontSize: 16, color: Color(0xFFDAA520))),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.7),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
