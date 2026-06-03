import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/core/constants.dart';
import 'package:sigaram_technologies_internship_assignment/core/firestore_service.dart';
import 'package:sigaram_technologies_internship_assignment/core/local_storage_service.dart';

class SettingsController extends GetxController {
  final FirestoreService _firestore = Get.find<FirestoreService>();

  final LocalStorageService _storage = Get.find<LocalStorageService>();

  final RxBool isLoading = false.obs;

  final RxList<String> languages = <String>[].obs;

  final RxList<String> colors = <String>[].obs;

  final RxString selectedLanguage = ''.obs;

  final RxString selectedColor = ''.obs;

  @override
  void onInit() {
    super.onInit();

    loadSettings();
    loadSavedPreferences();
  }

  Future<void> loadSettings() async {
    try {
      isLoading.value = true;

      final languageList = await _firestore.getOptions(
        collectionName: FirestoreConstants.languageOptions,
      );

      final colorList = await _firestore.getOptions(
        collectionName: FirestoreConstants.colorOptions,
      );

      languages.assignAll(languageList);
      colors.assignAll(colorList);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void loadSavedPreferences() {
    selectedLanguage.value =
        _storage.getString(StorageConstants.selectedLanguage) ?? '';

    selectedColor.value =
        _storage.getString(StorageConstants.selectedColor) ?? '';
  }

  Future<void> changeLanguage(String language) async {
    selectedLanguage.value = language;

    await _storage.saveString(StorageConstants.selectedLanguage, language);
  }

  Future<void> changeColor(String color) async {
    selectedColor.value = color;

    await _storage.saveString(StorageConstants.selectedColor, color);
  }
}
