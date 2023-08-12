
import 'package:shared_preferences/shared_preferences.dart';

class SharePref {
  saveType(String type, String? key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key!, type);
  }

  removeType(String? key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(key!);
  }

  Future<String?> getType(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? '';
  }
}
