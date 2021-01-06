import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceKeys {
  static const String IS_USER_LOGGED_IN = "IS_USER_LOGGED_IN";

  static String getPrefString(SharedPreferences prefs, String key) {
    return prefs.getString(key);
  }

  static int getPrefInt(SharedPreferences prefs, String key) {
    return prefs.getInt(key);
  }

  static savePreferenceString(SharedPreferences prefs, String key, String value) {
    prefs.setString(key, value);
  }

  static savePreferenceInt(SharedPreferences prefs, String key, int value) {
    prefs.setInt(key, value);
  }

  static savePreferenceBool(SharedPreferences prefs, String key, bool value) {
    prefs.setBool(key, value);
  }
}
// final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
