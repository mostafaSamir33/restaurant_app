import 'package:flutter/material.dart';
import 'package:restaurant_app/model/firebase_services.dart';

import '../model/food_data_model.dart';

class CartProvider extends ChangeNotifier {
  List<FoodDataModel> data = [];
  double totalPrice = 0.0;

  double countTotalPrice() {
    FirebaseServices.getAllCartStream();
    double totalPrice = 0.0;
    for (int i = 0; i < data.length; i++) {
      double foodPrice = double.parse(data[i].price);
      totalPrice = totalPrice + foodPrice;
      foodPrice = 0.0;
    }
    this.totalPrice = totalPrice;
    notifyListeners();
    return totalPrice;
  }

  void removeFoodPriceFromTotalPrice({required FoodDataModel foodDataModel}) {
    double totalPrice = countTotalPrice();
    double removedFoodPrice = double.parse(foodDataModel.price);
    double updatedTotalPrice = totalPrice - removedFoodPrice;
    this.totalPrice = updatedTotalPrice;
    notifyListeners();
  }
}
