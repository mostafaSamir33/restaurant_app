import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/model/food_data_model.dart';
import 'package:restaurant_app/view/auth/screens/sign_in_screen.dart';
import 'package:restaurant_app/view/home_screen/screens/cart_screen.dart';

import '../../../model/firebase_services.dart';
import '../widgets/menu_card.dart';

class MenuScreen extends StatefulWidget {
  static const String routeName = '/MenuScreen';

  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < FoodDataModel.menuFood.length; i++) {
      FirebaseServices.addFoodToMenu(FoodDataModel.menuFood[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(CartScreen.routeName);
        },
        child: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: AppColors.green,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Icon(Icons.shopping_cart, color: AppColors.white),
              Text(
                'Go To The Cart',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: Text(
          'Menu',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                useSafeArea: true,
                builder:
                    (context) => AlertDialog(
                      title: Text(
                        'Exit',
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      actionsAlignment: MainAxisAlignment.center,
                      content: Text(
                        'Are You Sure You Want To Exit',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      icon: Icon(
                        Icons.exit_to_app_rounded,
                        color: AppColors.red,
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                'No',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            ElevatedButton(
                              onPressed: () async {
                                await FirebaseServices.signOut();
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  SignInScreen.routeName,
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              );
            },
            icon: Icon(Icons.exit_to_app_rounded, color: AppColors.white),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseServices.getAllMenuStream(),
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
            List<FoodDataModel> data = snapshot.data ?? [];
            return ListView.separated(
              padding: EdgeInsets.all(20.r).copyWith(bottom: 80.r),
              itemBuilder: (context, index) {
                return MenuCard(foodDataModel: data[index]);
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 20.h);
              },
              itemCount: data.length,
            );
          }
        },
      ),
    );
  }
}
