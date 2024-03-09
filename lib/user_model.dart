

class ProductModel {
  final String title;
  final String description;
  final String image;
  int? id;

  ProductModel({
    required this.title,
    required this.description,
    required this.image,
    required this.id
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      title: json['product_title'],
      description: json['product_description'],
      image: json['product_image'],
      id: json['product_id'], // corrected the key name
    );
  }

  Map<String, dynamic> toMap() {
    return {
    'product_title': title,
    'product_description': description,
    'product_image': image,
    'product_id': id, // corrected the key name
    };
    }
}