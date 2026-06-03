import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/core/helper_widgets.dart';

import '../controller/categories_controller.dart';

class CategoriesPage extends GetView<CategoriesController> {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const GradientAppBar(
        title: 'Categories',
        subtitle: 'Browse by category',
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          itemCount: controller.categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.86,
          ),
          itemBuilder: (context, index) {
            final category = controller.categories[index];

            return InkWell(
              onTap: () => controller.moveToProducts(category.id),
              borderRadius: BorderRadius.circular(24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: category.image,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: theme.colorScheme.primary.withAlpha((0.12 * 255).round()),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: theme.colorScheme.primary.withAlpha((0.12 * 255).round()),
                          child: const Icon(
                            Icons.image,
                            size: 48,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              const Color(0xA6000000),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x2EFFFFFF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              'View products',
                              style: TextStyle(
                                color: const Color(0xF2FFFFFF),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
