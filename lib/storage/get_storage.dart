import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Storage extends GetxController {
  final box = GetStorage();

  Future<void> initStorage() async {
    await GetStorage.init();
  }

  void storeValue(String constant, dynamic value) {
    box.write(constant, value);
  }

  getValue(String constant) {
    return box.read(constant);
  }

  clearData() {
    return box.erase();
  }
}
