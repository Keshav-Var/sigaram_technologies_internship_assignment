import 'package:get/get.dart';

import 'api_service.dart';
import 'firestore_service.dart';
import 'local_storage_service.dart';

class ServiceLocator {
  static Future<void> init() async {
    Get.put(ApiService(), permanent: true);

    Get.put(FirestoreService(), permanent: true);

    Get.put(LocalStorageService(), permanent: true);
  }
}
