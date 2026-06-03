import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/core/constants.dart';
import 'package:sigaram_technologies_internship_assignment/core/firestore_service.dart';

class DashboardController extends GetxController {
  final FirestoreService _firestore = Get.find<FirestoreService>();

  final RxBool isLoading = false.obs;

  final RxInt selectedIndex = 0.obs;

  final RxList<String> tabs = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBottomTabs();
  }

  Future<void> loadBottomTabs() async {
    try {
      isLoading.value = true;

      final result = await _firestore.getOptions(
        collectionName: FirestoreConstants.bottomTrayOptions,
      );

      tabs.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}

class NavigationIconMapper {
  static IconData getIcon(String label) {
    switch (label.toLowerCase()) {
      case 'settings':
        return Icons.settings;

      case 'categories':
        return Icons.category;

      case 'home':
        return Icons.home;

      case 'discover':
        return Icons.explore;

      case 'profile':
        return Icons.person;

      default:
        return Icons.circle;
    }
  }
}
