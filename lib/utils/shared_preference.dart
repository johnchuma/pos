import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static Future<bool> getShowOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("showOnboarding") ?? true; // Default value if the key is not found
  }

  static Future<void> setShowOnboarding(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("showOnboarding", value);
  }
}