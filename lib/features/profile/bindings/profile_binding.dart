import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/features/profile/controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}
