import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/utils/app_assets.dart';
import 'package:restaurant_app/model/firebase_services.dart';
import 'package:restaurant_app/model/food_data_model.dart';

import '../../../core/utils/app_colors.dart';
import '../../../view_model/cart_provider.dart';

class CartCard extends StatelessWidget {
  final FoodDataModel foodDataModel;

  const CartCard({super.key, required this.foodDataModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBluePlus,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.network(
                  foodDataModel.imagePath,
                  width: 150.w,
                  height: 150.h,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(color: AppColors.orange),
                    );
                  },
                  errorBuilder:
                      (context, error, stackTrace) => SizedBox(
                        width: 150.w,
                        height: 150.h,
                        child: Image.asset(
                          AppAssets.nullFoodImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                ),
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodDataModel.name,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    '\$${foodDataModel.price}',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: TextButton(
                onPressed: () async {
                  context.read<CartProvider>().removeFoodPriceFromTotalPrice(
                    foodDataModel: foodDataModel,
                  );
                  await FirebaseServices.deleteFood(foodDataModel);
                },
                child: Text(
                  'Remove',
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
