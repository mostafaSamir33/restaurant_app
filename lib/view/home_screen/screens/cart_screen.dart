import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/view/home_screen/widgets/cart_card.dart';

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
  List<FoodDataModel>? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: data?.isEmpty == true || data == null ? false : true,
        child: Container(
          padding: EdgeInsets.all(20.r),
          margin: EdgeInsets.only(left: 20.r, right: 20.r, bottom: 30.r),
          decoration: BoxDecoration(
            color: AppColors.green,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            spacing: 20.r,
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
                    '\$16.48',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
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
                  minimumSize: Size(double.infinity.w, 50.h),
                ),
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.white),
        ),
        title: Text(
          'Your Cart',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseServices.getAllCartStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.orange),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(
                  color: AppColors.red,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          } else {
            data = snapshot.data ?? [];
            if (data?.isEmpty == true || data == null) {
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
            return ListView.separated(
              padding: EdgeInsets.all(20.r).copyWith(bottom: 200.r),
              itemBuilder: (context, index) {
                return CartCard(foodDataModel: data![index]);
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 20.h);
              },
              itemCount: data!.length,
            );
          }
        },
      ),
    );
  }
}
