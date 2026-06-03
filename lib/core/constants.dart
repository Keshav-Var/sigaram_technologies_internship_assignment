class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.escuelajs.co/api/v1';

  static const String categories = '$baseUrl/categories';

  static String productsByCategory(int categoryId) =>
      '$baseUrl/categories/$categoryId/products';
}

class FirestoreConstants {
  FirestoreConstants._();

  static const String videoLinks = 'video_links';

  static const String languageOptions = 'language_options';

  static const String colorOptions = 'color_options';

  static const String bottomTrayOptions = 'bottom_tray_options';
}

class StorageConstants {
  StorageConstants._();

  static const String selectedLanguage = 'selected_language';

  static const String selectedColor = 'selected_color';
  static const String userName = 'user_name';

  static const String userAge = 'user_age';

  static const String profileImage = 'profile_image';
}
