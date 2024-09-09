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

  User({
    this.id,
    this.username,
    this.email,
    this.password,
    this.bio,
    this.profilePic,
    this.createdAt,
    this.updatedAt,
  });

  // Convert a User object to a map
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
    };
  }

  // Create a User object from a map
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
    );
  }
}
