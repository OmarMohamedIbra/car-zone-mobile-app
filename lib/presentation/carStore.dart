import 'package:carzone_demo/data/api.dart';
import 'package:carzone_demo/data/responses/get_car_response.dart';
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
}

class CarStoreScreen extends StatefulWidget {
  
  @override
  _CarStoreScreenState createState() => _CarStoreScreenState();
}

class _CarStoreScreenState extends State<CarStoreScreen>
    with TickerProviderStateMixin {
  String currentSort = 'Default';
  bool isDropdownOpen = false;
  GetCarResponse? getCarResponse;
  List<bool> favorites = [false, false, false, false];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Car> cars = [
    Car(
      model: 'BMW X5',
      year: 2023,
      price: "45000",
      engine: '3.0L V6',
      transmission: 'Automatic',
      mileage: '25,000 km',
      fuelType: 'Petrol',
      features: ['Leather', 'Sunroof', 'AWD', 'Navigation'],
      emoji: '🚗',
    ),
    Car(
      model: 'Mercedes C-Class',
      year: 2022,
      price: "38500",
      engine: '2.0L Turbo',
      transmission: 'Automatic',
      mileage: '18,500 km',
      fuelType: 'Petrol',
      features: ['Premium Audio', 'Heated Seats', 'Bluetooth'],
      emoji: '🚙',
    ),
    Car(
      model: 'Audi A4',
      year: 2024,
      price: "42000",
      engine: '2.0L TFSI',
      transmission: 'S-Tronic',
      mileage: '5,000 km',
      fuelType: 'Hybrid',
      features: ['Virtual Cockpit', 'Matrix LED', 'Quattro'],
      emoji: '🏎️',
    ),
    Car(
      model: 'Toyota Camry',
      year: 2023,
      price: "28000",
      engine: '2.5L Hybrid',
      transmission: 'CVT',
      mileage: '12,000 km',
      fuelType: 'Hybrid',
      features: ['Safety Sense', 'Wireless Charging', 'JBL Audio'],
      emoji: '🚘',
    ),
  ];

  List<Car> sortedCars = [];

  @override
  void initState(){
    super.initState();
     _loadCars();
    sortedCars = List.from(cars);
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
    try {
      final response = await Api.getCars();
      setState(() {
        getCarResponse = response;
      });
    } catch (e) {
      // Handle error (e.g., show error message)
      print('Error loading cars: $e');
    }
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void sortCars(String criteria) {
    setState(() {
      currentSort = criteria;
      switch (criteria) {
        case 'By Model':
          sortedCars.sort((a, b) => a.model.compareTo(b.model));
          break;
        case 'By Year':
          sortedCars.sort((a, b) => b.year.compareTo(a.year));
          break;
        case 'By Price':
          sortedCars.sort((a, b) => a.price.compareTo(b.price));
          break;
        default:
          sortedCars = List.from(cars);
      }
      isDropdownOpen = false;
    });
  }

  void toggleFavorite(int index) {
    setState(() {
      favorites[index] = !favorites[index];
    });
  }

  void bookCar(String carModel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Booking request sent for $carModel! Our team will contact you shortly.',
        ),
        backgroundColor: Color(0xFFDAA520),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
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
          child:Column(
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
                      '${cars.length} cars available',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // Sorting Section
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sort by:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isDropdownOpen = !isDropdownOpen;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(
                            color: Color(0xFFDAA520).withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentSort,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 10),
                            AnimatedRotation(
                              turns: isDropdownOpen ? 0.5 : 0,
                              duration: Duration(milliseconds: 300),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Dropdown Options
              if (isDropdownOpen)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF1a1a2e).withOpacity(0.95),
                    border: Border.all(
                      color: Color(0xFFDAA520).withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children:
                        ['Default', 'By Model', 'By Year', 'By Price']
                            .map(
                              (option) => GestureDetector(
                                onTap: () => sortCars(option),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        currentSort == option
                                            ? Color(0xFFDAA520).withOpacity(0.2)
                                            : Colors.transparent,
                                  ),
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color:
                                          currentSort == option
                                              ? Color(0xFFDAA520)
                                              : Colors.white,
                                      fontWeight:
                                          currentSort == option
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),

              // Cars List
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: getCarResponse?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final car = sortedCars[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.only(bottom: 20),
                        child: CarCard(
                          car: Car(model: getCarResponse?.data?[index].model??"", year: getCarResponse?.data?[index].year??0, price: getCarResponse?.data?[index].price??"", engine: (getCarResponse?.data?[index].enginePower??"").toString(), transmission: getCarResponse?.data?[index].transmission??"", mileage: (getCarResponse?.data?[index].topSpeed??"").toString(), fuelType: getCarResponse?.data?[index].engineType??"", features: cars[index].features, emoji: getCarResponse?.data?[index].mainImage??""),
                          isFavorite: favorites[index],
                          onFavoriteToggle: () => toggleFavorite(index),
                          onBook: () => bookCar(car.model),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    ); // Close Scaffold without bottomNavigationBar
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
                      child: Image.network(widget.car.emoji)
                    
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.car.model,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
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
                              ],
                            ),
                            Text(
                              '\$${widget.car.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFDAA520),
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
