class FoodDataModel {
  String id;
  String name;
  String price;
  String imagePath;

  FoodDataModel({
    this.id = '',
    required this.name,
    required this.price,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price, 'imagePath': imagePath};
  }

  static FoodDataModel fromJson(Map<String, dynamic> json) {
    return FoodDataModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'unknown',
      price: json['price'] ?? '0.0',
      imagePath: json['imagePath'] ?? '',
    );
  }
}
