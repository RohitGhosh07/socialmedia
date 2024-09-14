import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? username;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? password;

  @HiveField(4)
  String? bio;

  @HiveField(5)
  String? profilePic;

  @HiveField(6)
  String? createdAt;

  @HiveField(7)
  String? updatedAt;
  @HiveField(8)
  bool? following;
  @HiveField(9)
  bool? follower;

  User({
    this.id,
    this.username,
    this.email,
    this.password,
    this.bio,
    this.profilePic,
    this.createdAt,
    this.updatedAt,
    this.following,
    this.follower,
  });

  // Convert JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      bio: json['bio'],
      profilePic: json['profilePic'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      following: json['following'],
      follower: json['follower'],
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'bio': bio,
      'profilePic': profilePic,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'following': following,
      'follower': follower,
    };
  }

  // Convert User object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'bio': bio,
      'profilePic': profilePic,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'following': following,
      'follower': follower,
    };
  }

  // Create a User object from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      bio: map['bio'],
      profilePic: map['profilePic'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      following: map['following'],
      follower: map['follower'],
    );
  }
}
