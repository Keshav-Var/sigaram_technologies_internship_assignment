import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/features/categories/model/product_model.dart';

class ProductDetailController extends GetxController {
  late final ProductModel product;
  final RxInt currentPageIndex = 0.obs;
  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments as ProductModel;
    pageController = PageController();
  }

  void updateCurrentPage(int index) {
    currentPageIndex.value = index;
  }

  void nextImage() {
    if (currentPageIndex.value < product.images.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousImage() {
    if (currentPageIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
