import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/features/categories/bindings/categories_binding.dart';
import 'package:sigaram_technologies_internship_assignment/features/categories/bindings/product_binding.dart';
import 'package:sigaram_technologies_internship_assignment/features/categories/bindings/product_detail_binding.dart';
import 'package:sigaram_technologies_internship_assignment/features/dashboard/bindings/dashboard_binding.dart';
import 'package:sigaram_technologies_internship_assignment/features/dashboard/view/dashboard_page.dart';
import 'package:sigaram_technologies_internship_assignment/features/discover/bindings/discover_binding.dart';
import 'package:sigaram_technologies_internship_assignment/features/home/bindings/home_binding.dart';
import 'package:sigaram_technologies_internship_assignment/features/profile/bindings/profile_binding.dart';
import 'package:sigaram_technologies_internship_assignment/features/settings/bindings/setting_bindings.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      initialBinding: BindingsBuilder(() {
        DashboardBinding().dependencies();
        SettingsBinding().dependencies();
        ProfileBinding().dependencies();
        DiscoverBinding().dependencies();
        CategoriesBinding().dependencies();
        ProductsBinding().dependencies();
        ProductDetailBinding().dependencies();
        HomeBinding().dependencies();
      }),

      home: const DashboardPage(),
    );
  }
}
