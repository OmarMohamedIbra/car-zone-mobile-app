class GetCarResponse {
  List<Data>? data;

  GetCarResponse({this.data});

  GetCarResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? supplierId;
  int? categoryId;
  int? brandId;
  int? branchId;
  String? model;
  int? year;
  int? userId;
  int? isSold;
  int? isBooked;
  Map<String, dynamic>? bookingUser;
  String? price;
  int? doors;
  double? acceleration;
  int? topSpeed;
  int? fuelEfficiency;
  String? color;
  String? engineType;
  int? enginePower;
  int? engineCylinder;
  int? engineCubicCapacityType;
  String? transmission;
  String? features;
  String? performance;
  String? safety;
  int? isAvailable;
  String? mainImage;
  List<String>? images;
  int? depositAmount;

  Data(
      {this.id,
      this.supplierId,
      this.categoryId,
      this.brandId,
      this.branchId,
      this.model,
      this.year,
      this.userId,
      this.isSold,
      this.isBooked,
      this.bookingUser,
      this.price,
      this.doors,
      this.acceleration,
      this.topSpeed,
      this.fuelEfficiency,
      this.color,
      this.engineType,
      this.enginePower,
      this.engineCylinder,
      this.engineCubicCapacityType,
      this.transmission,
      this.features,
      this.performance,
      this.safety,
      this.isAvailable,
      this.mainImage,
      this.images,
      this.depositAmount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] is double ? (json['id'] as double).toInt() : json['id'];
    supplierId = json['supplier_id'] is double ? (json['supplier_id'] as double).toInt() : json['supplier_id'];
    categoryId = json['category_id'] is double ? (json['category_id'] as double).toInt() : json['category_id'];
    brandId = json['brand_id'] is double ? (json['brand_id'] as double).toInt() : json['brand_id'];
    branchId = json['branch_id'] is double ? (json['branch_id'] as double).toInt() : json['branch_id'];
    model = json['model'];
    year = json['year'] is double ? (json['year'] as double).toInt() : json['year'];
    userId = json['user_id'] is double ? (json['user_id'] as double).toInt() : json['user_id'];
    isSold = json['is_sold'] is double ? (json['is_sold'] as double).toInt() : json['is_sold'];
    isBooked = json['is_booked'] is double ? (json['is_booked'] as double).toInt() : json['is_booked'];
    if (json['booking_user'] == null) {
      bookingUser = null;
    } else if (json['booking_user'] is Map<String, dynamic>) {
      bookingUser = Map<String, dynamic>.from(json['booking_user']);
    } else {
      bookingUser = null;
    }
    price = json['price'];
    doors = json['doors'] is double ? (json['doors'] as double).toInt() : json['doors'];
    acceleration = json['acceleration'] is int
        ? (json['acceleration'] as int).toDouble()
        : json['acceleration'];
    topSpeed = json['top_speed'] is double ? (json['top_speed'] as double).toInt() : json['top_speed'];
    fuelEfficiency = json['fuel_efficiency'] is double ? (json['fuel_efficiency'] as double).toInt() : json['fuel_efficiency'];
    color = json['color'];
    engineType = json['engine_type'];
    enginePower = json['engine_power'] is double ? (json['engine_power'] as double).toInt() : json['engine_power'];
    engineCylinder = json['engine_cylinder'] is double ? (json['engine_cylinder'] as double).toInt() : json['engine_cylinder'];
    engineCubicCapacityType = json['engine_cubic_capacity_type'] is double ? (json['engine_cubic_capacity_type'] as double).toInt() : json['engine_cubic_capacity_type'];
    transmission = json['transmission'];
    features = json['features'];
    performance = json['performance'];
    safety = json['safety'];
    isAvailable = json['is_available'] is double ? (json['is_available'] as double).toInt() : json['is_available'];
    mainImage = json['main_image'];
    if (json['images'] is List) {
      images = List<String>.from(json['images'].whereType<String>());
    } else {
      images = null;
    }
    depositAmount = json['deposit_amount'] is double ? (json['deposit_amount'] as double).toInt() : json['deposit_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['supplier_id'] = this.supplierId;
    data['category_id'] = this.categoryId;
    data['brand_id'] = this.brandId;
    data['branch_id'] = this.branchId;
    data['model'] = this.model;
    data['year'] = this.year;
    data['user_id'] = this.userId;
    data['is_sold'] = this.isSold;
    data['is_booked'] = this.isBooked;
    data['booking_user'] = this.bookingUser;
    data['price'] = this.price;
    data['doors'] = this.doors;
    data['acceleration'] = this.acceleration;
    data['top_speed'] = this.topSpeed;
    data['fuel_efficiency'] = this.fuelEfficiency;
    data['color'] = this.color;
    data['engine_type'] = this.engineType;
    data['engine_power'] = this.enginePower;
    data['engine_cylinder'] = this.engineCylinder;
    data['engine_cubic_capacity_type'] = this.engineCubicCapacityType;
    data['transmission'] = this.transmission;
    data['features'] = this.features;
    data['performance'] = this.performance;
    data['safety'] = this.safety;
    data['is_available'] = this.isAvailable;
    data['main_image'] = this.mainImage;
    data['images'] = this.images;
    data['deposit_amount'] = this.depositAmount;
    return data;
  }
}