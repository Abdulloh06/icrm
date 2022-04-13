/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:shared_preferences/shared_preferences.dart';

class PrefsKeys {
  static const String idKey = "id_key";
  static const String nameKey = 'name_key';
  static const String surnameKey = 'surname_key';
  static const String phoneKey = 'phone_number';
  static const String userPhoto = 'user_photo';
  static const String userName = 'user_name';
  static const String authStatus = 'authStatus';
  static const String themeKey = 'theme_key';
  static const String languageCode = 'language_code';
  static const String emailKey = 'email_key';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String responsibilityKey = "response_key";
  static const String searchHistoryKey = "history_key";
}

class SharedPreferencesService {
  static late SharedPreferencesService _instance;
  static late SharedPreferences _preferences;

  SharedPreferencesService._internal();

  static Future<SharedPreferencesService> get instance async {
    _instance = SharedPreferencesService._internal();
    _preferences = await SharedPreferences.getInstance();

    return _instance;
  }

  Future<void> setTheme(bool value) async {
    await _preferences.setBool(PrefsKeys.themeKey, value);
  }

  Future<void> setTokens(
      {required String accessToken, required String refreshToken}) async {
    await _preferences.setString(PrefsKeys.accessTokenKey, accessToken);
    await _preferences.setString(PrefsKeys.refreshTokenKey, refreshToken);
  }

  Future<void> setUserInfo({required Map<String, dynamic> data, required bool fromSignUp}) async {
    if(fromSignUp) {
      await _preferences.setString(PrefsKeys.phoneKey, data['user']['phone_number'] ?? "");
      await _preferences.setString(PrefsKeys.emailKey, data['user']['email'] ?? "");
    }else {
      await _preferences.setInt(PrefsKeys.idKey, data['data']['id']);
      await _preferences.setString(PrefsKeys.nameKey, data['data']['first_name'] ?? "");
      await _preferences.setString(PrefsKeys.surnameKey, data['data']['last_name'] ?? "");
      await _preferences.setString(PrefsKeys.phoneKey, data['data']['phone_number'] ?? "");
      await _preferences.setString(PrefsKeys.userName, data['data']['username'] ?? "");
      await _preferences.setString(PrefsKeys.userPhoto, data['data']['social_avatar'] ?? "");
      await _preferences.setString(PrefsKeys.emailKey, data['data']['email'] ?? "");
      await _preferences.setString(PrefsKeys.responsibilityKey, data['data']['job_title'] ?? "");
    }
  }

  Future<void> setAuth(bool value) async {
    await _preferences.setBool(PrefsKeys.authStatus, value);
  }

  bool get getTheme => _preferences.getBool(PrefsKeys.themeKey) ?? false;

  bool get getAuth => _preferences.getBool(PrefsKeys.authStatus) ?? false;

  String get getLanguageCode =>
      _preferences.getString(PrefsKeys.languageCode) ?? "ru";

  String get getName => _preferences.getString(PrefsKeys.nameKey) ?? "";

  String get getSurname => _preferences.getString(PrefsKeys.surnameKey) ?? "";

  String get getUsername => _preferences.getString(PrefsKeys.userName) ?? "";

  String get getUserPhoto => _preferences.getString(PrefsKeys.userPhoto) ?? "";

  String get getPhoneNumber => _preferences.getString(PrefsKeys.phoneKey) ?? "";

  String get getEmail => _preferences.getString(PrefsKeys.emailKey) ?? "";

  String get getAccessToken =>
      _preferences.getString(PrefsKeys.accessTokenKey) ?? "";

  String get getRefreshToken =>
      _preferences.getString(PrefsKeys.refreshTokenKey) ?? "";
  dynamic get getUserId => _preferences.getInt(PrefsKeys.idKey);
  String get getResponsibility => _preferences.getString(PrefsKeys.responsibilityKey) ?? "";
}
