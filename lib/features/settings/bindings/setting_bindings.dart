import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/features/settings/controller/setting_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController());
  }
}
