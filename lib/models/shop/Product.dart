class Product {
  final String? id;
  final String? name;
  final String? imageUrl;
  final double price;

  Product({
    this.id,
    this.name,
    this.imageUrl,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
