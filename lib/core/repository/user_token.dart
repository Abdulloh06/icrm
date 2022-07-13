/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

class UserToken {
  static dynamic id;
  static String name = '';
  static String surname = '';
  static String phoneNumber = '';
  static bool authStatus = false;
  static bool isDark = false;
  static String email = '';
  static String username = '';
  static String userPhoto = '';
  static String languageCode = '';
  static String accessToken = '';
  static String refreshToken = '';
  static String responsibility = '';
  static String fmToken = '';
  static int inProgressTask = 0;
  static int completedTask = 0;
  static int pendingTask = 0;
  static int canceledTask = 0;
  static bool animate = true;

  static void clearAllData() {
    name = '';
    surname = '';
    phoneNumber = '';
    authStatus = false;
    username = '';
    accessToken = '';
    refreshToken = '';
    responsibility = '';
    email = '';
    id = null;
    inProgressTask = 0;
    completedTask = 0;
    pendingTask = 0;
    canceledTask = 0;
  }
}