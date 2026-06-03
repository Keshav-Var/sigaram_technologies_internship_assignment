import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/core/api_service.dart';
import 'package:sigaram_technologies_internship_assignment/core/constants.dart';
import 'package:sigaram_technologies_internship_assignment/features/categories/model/product_model.dart';

class ProductsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxBool isLoading = false.obs;

  final RxList<ProductModel> products = <ProductModel>[].obs;

  late final int categoryId;

  @override
  void onInit() {
    super.onInit();

    categoryId = Get.arguments as int;

    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        ApiConstants.productsByCategory(categoryId),
      );

      products.assignAll(
        (response as List).map((e) => ProductModel.fromJson(e)).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
