import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  static late SharedPreferences _prefs;
  static const String _themeKey = "theme";
  static const String _localeKey = "locale";
  static const String _onboardingKey = "onboarding_seen";

  // بتتنادى مرة واحدة في main قبل runApp
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // القيم بتتقري من المحفوظ، ولو مفيش بتاخد الـ default
  ThemeMode themeMode =
  _prefs.getString(_themeKey) == "dark" ? ThemeMode.dark : ThemeMode.light;
  String locale = _prefs.getString(_localeKey) ?? "en";
  bool onboardingSeen = _prefs.getBool(_onboardingKey) ?? false;

  void changeTheme(ThemeMode theme) {
    themeMode = theme;
    _prefs.setString(_themeKey, theme == ThemeMode.dark ? "dark" : "light");
    notifyListeners();
  }

  void changeLocale(String loc) {
    locale = loc;
    _prefs.setString(_localeKey, loc);
    notifyListeners();
  }

  void finishOnboarding() {
    onboardingSeen = true;
    _prefs.setBool(_onboardingKey, true);
    notifyListeners();
  }
}