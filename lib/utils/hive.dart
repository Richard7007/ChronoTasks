import 'package:hive/hive.dart';

class AppHive {
  static const String isLogged = 'isLogged';
  static const String boxName = "user";

  Future<void> putIsLogged({required bool value}) async {
    await Hive.box(boxName).put(isLogged, value);
  }

  bool getIsLogged() {
    return Hive.box(boxName).get(isLogged, defaultValue: false);
  }
}
