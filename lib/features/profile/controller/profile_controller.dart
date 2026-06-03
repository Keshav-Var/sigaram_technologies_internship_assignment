import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sigaram_technologies_internship_assignment/core/constants.dart';
import 'package:sigaram_technologies_internship_assignment/core/local_storage_service.dart';

class ProfileController extends GetxController {
  final LocalStorageService _storage = Get.find<LocalStorageService>();

  final RxString name = 'Unknown'.obs;

  final RxInt age = 0.obs;

  final RxString imagePath = ''.obs;

  final RxString selectedLanguage = ''.obs;

  final RxString selectedColor = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    name.value = _storage.getString(StorageConstants.userName) ?? 'Unknown';

    age.value =
        int.tryParse(_storage.getString(StorageConstants.userAge) ?? '0') ?? 0;

    imagePath.value = _storage.getString(StorageConstants.profileImage) ?? '';

    selectedLanguage.value =
        _storage.getString(StorageConstants.selectedLanguage) ?? 'Not Selected';

    selectedColor.value =
        _storage.getString(StorageConstants.selectedColor) ?? 'Not Selected';
  }

  Future<void> updateName(String value) async {
    name.value = value;

    await _storage.saveString(StorageConstants.userName, value);
  }

  Future<void> updateAge(int value) async {
    age.value = value;

    await _storage.saveString(StorageConstants.userAge, value.toString());
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    imagePath.value = image.path;

    await _storage.saveString(StorageConstants.profileImage, image.path);
  }
}
