import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/features/categories/view/categories_page.dart';
import 'package:sigaram_technologies_internship_assignment/features/dashboard/controller/dashboard_controller.dart';
import 'package:sigaram_technologies_internship_assignment/features/discover/view/discover_page.dart';
import 'package:sigaram_technologies_internship_assignment/features/home/view/home_page.dart';
import 'package:sigaram_technologies_internship_assignment/features/profile/view/profile_page.dart';
import 'package:sigaram_technologies_internship_assignment/features/settings/view/setting_page.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const SettingsPage(),
      const CategoriesPage(),
      const HomePage(),
      const DiscoverPage(),
      const ProfilePage(),
    ];

    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 16,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: BottomNavigationBar(
              currentIndex: controller.selectedIndex.value,
              onTap: controller.changeTab,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).cardColor,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Colors.grey[600],
              showUnselectedLabels: true,
              elevation: 0,
              items: controller.tabs
                  .map(
                    (tab) => BottomNavigationBarItem(
                      icon: Icon(NavigationIconMapper.getIcon(tab)),
                      label: tab,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );
    });
  }
}
