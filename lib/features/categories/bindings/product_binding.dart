import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/features/categories/controller/product_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductsController());
  }
}
