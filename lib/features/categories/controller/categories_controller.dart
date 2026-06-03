import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/core/api_service.dart';
import 'package:sigaram_technologies_internship_assignment/core/constants.dart';
import 'package:sigaram_technologies_internship_assignment/features/categories/bindings/product_binding.dart';
import 'package:sigaram_technologies_internship_assignment/features/categories/model/category_model.dart';
import 'package:sigaram_technologies_internship_assignment/features/categories/view/products_page.dart';

class CategoriesController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxBool isLoading = false.obs;

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(ApiConstants.categories);

      categories.assignAll(
        (response as List).map((e) => CategoryModel.fromJson(e)).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void moveToProducts(int categoryId) {
    Get.to(
      () => const ProductsPage(),
      binding: ProductsBinding(),
      arguments: categoryId,
    );
  }
}
