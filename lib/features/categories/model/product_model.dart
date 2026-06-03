class ProductModel {
  final int id;
  final String title;
  final String slug;
  final double price;
  final String description;
  final String image;
  final List<String> images;
  final ProductCategory category;

  ProductModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.image,
    required this.images,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final images = List<String>.from(json['images'] ?? []);

    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      image: images.isNotEmpty ? images.first : '',
      images: images,
      category: ProductCategory.fromJson(json['category'] ?? {}),
    );
  }
}

class ProductCategory {
  final int id;
  final String name;
  final String slug;
  final String image;

  ProductCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
