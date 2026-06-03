import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/features/dashboard/controller/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController(), permanent: true);
  }
}
