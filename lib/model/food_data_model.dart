import 'package:restaurant_app/core/utils/app_assets.dart';

class FoodDataModel {
  String id;
  String name;
  String price;
  String imagePath;
  DateTime? createdAt;

  FoodDataModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    this.createdAt,
  });

  static List<FoodDataModel> menuFood = [
    FoodDataModel(
      id: '1',
      name: 'Margherita Pizza',
      price: '8.99',
      imagePath:
          'https://ooni.com/cdn/shop/articles/20220211142347-margherita-9920_ba86be55-674e-4f35-8094-2067ab41a671.jpg?v=1737104576&width=2048',
      createdAt: DateTime.now(),
    ),
    FoodDataModel(
      id: '2',
      name: 'Cheeseburger',
      price: '6.49',
      imagePath:
          'https://www.certifiedangusbeef.com/_next/image?url=https%3A%2F%2Fappetizing-cactus-7139e93734.media.strapiapp.com%2FUltimate_Double_Cheeseburger_da3c3f6a9b.jpeg&w=1920&q=75',
      createdAt: DateTime.now(),
    ),
    FoodDataModel(
      id: '3',
      name: 'Grilled Chicken Salad',
      price: '7.99',
      imagePath:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSaZ82rLFjCS715XTwJb0h7TlpqUzux43_1-y6C3YN5YmdF2Qj57D8GfTycvajtFoY_FxY&usqp=CAU',
      createdAt: DateTime.now(),
    ),
    FoodDataModel(
      id: '4',
      name: 'Spaghetti Bolognese',
      price: '9.49',
      imagePath:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTvPi8d5vdOvjQOOyrc8MRf31ztnivjycoA5Uc1KFfKhniLhyfEJj0_OE9pWJVWGdojAQ&usqp=CAU',
      createdAt: DateTime.now(),
    ),
    FoodDataModel(
      id: '5',
      name: 'Tacos al Pastor',
      price: '5.99',
      imagePath:
          'https://thestayathomechef.com/wp-content/uploads/2024/04/Classic-Tacos-Al-Pastor_Square-1.jpg',
      createdAt: DateTime.now(),
    ),
    FoodDataModel(
      id: '6',
      name: 'Sushi Platter',
      price: '12.99',
      imagePath:
          'https://img.freepik.com/premium-photo/assorted-sushi-platter-elegant-table-setting_711700-21906.jpg',
      createdAt: DateTime.now(),
    ),
    FoodDataModel(
      id: '7',
      name: 'Veggie Wrap',
      price: '6.75',
      imagePath:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSiLGBMpDCONZv38Klb9Z1nOktYbALCKZNEMuiasm7qNqw-mu1Xk0C8we3r_X9ZhiwPi8E&usqp=CAU',
      createdAt: DateTime.now(),
    ),
    FoodDataModel(
      id: '8',
      name: 'Butter Chicken',
      price: '10.99',
      imagePath:
          'https://sugarspunrun.com/wp-content/uploads/2025/04/Butter-chicken-1-of-1.jpg',
      createdAt: DateTime.now(),
    ),
    FoodDataModel(
      id: '9',
      name: 'Pancake Stack',
      price: '5.25',
      imagePath:
          'https://www.recipetineats.com/tachyon/2017/06/Pancakes-SQ.jpg',
      createdAt: DateTime.now(),
    ),
    FoodDataModel(
      id: '10',
      name: 'Chocolate Lava Cake',
      price: '4.99',
      imagePath:
          'https://images.getrecipekit.com/20250325120225-how-20to-20make-20chocolate-20molten-20lava-20cake-20in-20the-20microwave.png?width=650&quality=90&',
      createdAt: DateTime.now(),
    ),
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imagePath': imagePath,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  static FoodDataModel fromJson(Map<String, dynamic> json) {
    return FoodDataModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'unknown',
      price: json['price'] ?? '0.0',
      imagePath: json['imagePath'] ?? AppAssets.nullFoodImage,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        json['createdAt'] ?? DateTime.now(),
      ),
    );
  }
}
