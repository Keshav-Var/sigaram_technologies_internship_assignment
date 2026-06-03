import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigaram_technologies_internship_assignment/core/helper_widgets.dart';

import '../controller/product_detail_controller.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.product;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: GradientAppBar(
        leading: const BackButton(color: Colors.white),
        title: product.title,
        subtitle: product.category.name,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 320,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: controller.pageController,
                    itemCount: product.images.length,
                    onPageChanged: controller.updateCurrentPage,
                    itemBuilder: (_, index) {
                      return CachedNetworkImage(
                        imageUrl: product.images[index],
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image,
                            size: 72,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    left: 12,
                    top: 0,
                    bottom: 0,
                    child: Obx(() {
                      final isFirst = controller.currentPageIndex.value == 0;
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isFirst ? 0.3 : 1,
                        child: IconButton(
                          onPressed: controller.previousImage,
                          icon: const Icon(
                            Icons.chevron_left,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ),
                  Positioned(
                    right: 12,
                    top: 0,
                    bottom: 0,
                    child: Obx(() {
                      final isLast =
                          controller.currentPageIndex.value ==
                          product.images.length - 1;
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isLast ? 0.3 : 1,
                        child: IconButton(
                          onPressed: controller.nextImage,
                          icon: const Icon(
                            Icons.chevron_right,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(product.images.length, (index) {
                          final active =
                              controller.currentPageIndex.value == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: active ? 12 : 8,
                            height: active ? 12 : 8,
                            decoration: BoxDecoration(
                              color: active ? Colors.white : Colors.white70,
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(
                            (0.12 * 255).round(),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          product.category.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 18,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.description,
                          style: const TextStyle(height: 1.6),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.shopping_bag_outlined),
                                label: const Text('Add to Cart'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.primary.withAlpha(
                                    (0.3 * 255).round(),
                                  ),
                                ),
                                color: theme.cardColor,
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
