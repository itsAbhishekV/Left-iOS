import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  Future<void> saveUserData(String name, String dob, int colorIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save data
    prefs.setString('user_name', name);
    prefs.setString('dob', dob);
    prefs.setInt('theme_color', colorIndex);
  }

  // Get user's name
  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  // Get user's dob
  Future<String?> getDob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('dob');
  }

  // Get theme color
  Future<int?> getColorIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? colorValue = prefs.getInt('theme_color');
    return colorValue;
  }

  // Clear user data
  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('dob');
    await prefs.remove('theme_color');
  }
}
