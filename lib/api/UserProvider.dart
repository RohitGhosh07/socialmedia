import 'package:hive/hive.dart';
import 'package:kkh_events/api/class/User.dart';

// Ensure you have registered this adapter in main
class UserProvider extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    return User(
      id: reader.readInt(),
      username: reader.readString(),
      email: reader.readString(),
      password: reader.readString(),
      bio: reader.readString(),
      profilePic: reader.readString(),
      createdAt: reader.readString(),
      updatedAt: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeInt(obj.id!);
    writer.writeString(obj.username!);
    writer.writeString(obj.email!);
    writer.writeString(obj.password!);
    writer.writeString(obj.bio!);
    writer.writeString(obj.profilePic!);
    writer.writeString(obj.createdAt!);
    writer.writeString(obj.updatedAt!);
  }

  // Function to save user data
  Future<void> saveUser(User user) async {
    var box = await Hive.openBox('userBox');
    box.put('user', user.toMap()); // Save the user as a Map
  }

  // Function to get user data
  Future<User?> getUser() async {
    var box = await Hive.openBox('userBox');
    var userData = box.get('user');

    if (userData != null) {
      return User.fromMap(Map<String, dynamic>.from(userData));
    }
    return null;
  }

  // Function to check if user data exists
  Future<bool> userExists() async {
    var box = await Hive.openBox('userBox');
    return box.containsKey('user');
  }

  Future<void> logout() async {
    try {
      // Open the Hive box
      var box = await Hive.openBox('userBox');

      // Clear all data
      await box.clear();

      // Optionally close the box if no longer needed
      // await box.close();
    } catch (e) {
      print("Error logging out: $e");
      // Handle any errors, e.g., show a snack bar or alert dialog
    }
  }
}
