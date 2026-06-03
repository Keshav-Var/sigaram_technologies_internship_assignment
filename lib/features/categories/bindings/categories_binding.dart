import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/features/categories/controller/categories_controller.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoriesController());
  }
}
