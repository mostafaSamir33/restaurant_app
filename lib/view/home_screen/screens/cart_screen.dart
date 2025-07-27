import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/view/home_screen/widgets/cart_card.dart';
import 'package:restaurant_app/view_model/cart_provider.dart';

import '../../../core/utils/app_colors.dart';
import '../../../model/firebase_services.dart';
import '../../../model/food_data_model.dart';
import 'menu_screen.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/CartScreen';

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool didSetState = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.white),
        ),
        title: Text(
          'Your Cart',
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
      ),
      body: StreamBuilder<List<FoodDataModel>>(
        stream: FirebaseServices.getAllCartStream(),
        builder: (context, snapshot) {
          final cartProvider = context.read<CartProvider>();

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.orange),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error.toString()}',
                style: TextStyle(
                  color: AppColors.red,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          List<FoodDataModel>? cartData = snapshot.data ?? [];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            cartProvider.data = cartData;
            cartProvider.countTotalPrice();
            if (didSetState == false) {
              setState(() {});
              didSetState = true;
            }
          });

          if (cartData.isEmpty) {
            return Center(
              child: Text(
                'Your Cart Is Empty',
                style: TextStyle(
                  color: AppColors.orange,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return Stack(
            children: [
              ListView.separated(
                padding: EdgeInsets.all(20.r).copyWith(bottom: 200.r),
                itemBuilder: (context, index) {
                  return CartCard(foodDataModel: cartData[index]);
                },
                separatorBuilder: (_, __) => SizedBox(height: 20.h),
                itemCount: cartData.length,
              ),
              Positioned(
                left: 20.r,
                right: 20.r,
                bottom: 30.r,
                child: Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            MenuScreen.routeName,
                            (route) => false,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'The Order Is on Its Way To You',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              backgroundColor: Colors.orange,
                              duration: Duration(seconds: 5),
                              showCloseIcon: true,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          minimumSize: Size(double.infinity, 50.h),
                        ),
                        child: Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
