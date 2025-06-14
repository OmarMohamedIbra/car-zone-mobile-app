// User model
class User {
  final int? id;
  final String fname;
  final String lname;
  final String email;
  final String password;
  final String phoneNo;
  final String address;

  User({
    this.id,
    required this.fname,
    required this.lname,
    required this.email,
    required this.password,
    required this.phoneNo,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        fname: json['fname'],
        lname: json['lname'],
        email: json['email'],
        password: json['password'] ?? '',
        phoneNo: json['phone_no'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {
        'fname': fname,
        'lname': lname,
        'email': email,
        'password': password,
        'phone_no': phoneNo,
        'address': address,
      };
}

// Brand model
class Brand {
  final int? id;
  final String name;
  final String? image;

  Brand({this.id, required this.name, this.image});

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json['id'],
        name: json['name'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
      };
}

// Comment model
class Comment {
  final int? id;
  final int userId;
  final String body;

  Comment({this.id, required this.userId, required this.body});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'],
        userId: json['user_id'] is int ? json['user_id'] : int.parse(json['user_id'].toString()),
        body: json['body'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'body': body,
      };
}

// Event model
class Event {
  final int? id;
  final String? name;
  final String? description;
  final String? date;
  final String? location;

  Event({this.id, this.name, this.description, this.date, this.location});

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        date: json['date'],
        location: json['location'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'date': date,
        'location': location,
      };
}

// Car model
class Car {
  final int? id;
  final String? fname;
  final String? lname;
  final String? email;
  final String? password;
  final String? phoneNo;
  final String? address;

  Car({this.id, this.fname, this.lname, this.email, this.password, this.phoneNo, this.address});

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        id: json['id'],
        fname: json['fname'],
        lname: json['lname'],
        email: json['email'],
        password: json['password'],
        phoneNo: json['phone_no'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {
        'fname': fname,
        'lname': lname,
        'email': email,
        'password': password,
        'phone_no': phoneNo,
        'address': address,
      };
}

// Booking model
class Booking {
  final int? id;
  final int? userId;
  final double? depositAmount;
  final double? depositPaid;
  final String? depositChargedAt;
  final double? amount;
  final String? email;
  final String? token;

  Booking({this.id, this.userId, this.depositAmount, this.depositPaid, this.depositChargedAt, this.amount, this.email, this.token});

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'],
        userId: json['user_id'],
        depositAmount: (json['deposit_amount'] != null) ? double.tryParse(json['deposit_amount'].toString()) : null,
        depositPaid: (json['deposit_paid'] != null) ? double.tryParse(json['deposit_paid'].toString()) : null,
        depositChargedAt: json['deposit_charged_at'],
        amount: (json['amount'] != null) ? double.tryParse(json['amount'].toString()) : null,
        email: json['email'],
        token: json['token'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'deposit_amount': depositAmount,
        'deposit_paid': depositPaid,
        'deposit_charged_at': depositChargedAt,
        'amount': amount,
        'email': email,
        'token': token,
      };
}

// Reaction model
class Reaction {
  final int? id;
  final int userId;
  final int commentId;
  final String type;

  Reaction({this.id, required this.userId, required this.commentId, required this.type});

  factory Reaction.fromJson(Map<String, dynamic> json) => Reaction(
        id: json['id'],
        userId: json['user_id'] is int ? json['user_id'] : int.parse(json['user_id'].toString()),
        commentId: json['comment_id'] is int ? json['comment_id'] : int.parse(json['comment_id'].toString()),
        type: json['type'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'comment_id': commentId,
        'type': type,
      };
}
