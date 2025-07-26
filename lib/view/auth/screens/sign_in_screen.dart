import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/view/auth/screens/sign_up_screen.dart';
import 'package:restaurant_app/view/home_screen/screens/menu_screen.dart';

import '../../../core/utils/app_assets.dart';
import '../../../view_model/user_auth_provider.dart';
import '../widgets/custom_elevated_button_filled.dart';
import '../widgets/custom_text_form_field_auth.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = '/SignInScreen';

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.r),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 28.h),
                Image.asset(AppAssets.nullFoodImage, width: 250.w),
                SizedBox(height: 30.h),
                Text(
                  'Restaurant App',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 69.h),
                CustomTextFormFieldAuth(
                  hintText: 'Email',
                  password: false,
                  prefixIconPath: Icon(
                    Icons.email_rounded,
                    color: AppColors.orange,
                  ),
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email Is Required';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}',
                    ).hasMatch(value)) {
                      return 'Enter valid email';
                    }
                    return null;
                  },
                ),
                CustomTextFormFieldAuth(
                  hintText: 'Password',
                  password: true,
                  prefixIconPath: Icon(
                    Icons.lock_rounded,
                    color: AppColors.orange,
                  ),
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password Is Required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return 'Password must contain at least one uppercase letter';
                    }
                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return 'Password must contain at least one number';
                    }
                    if (!RegExp(
                      r'[!@#\$&*~%^()\-_+=<>?/.,;:{}\[\]]',
                    ).hasMatch(value)) {
                      return 'Password must contain at least one special character';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 34.h),
                CustomElevatedButtonFilled(
                  buttonText: 'Login',
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final authProvider = Provider.of<UserAuthProvider>(
                        context,
                        listen: false,
                      );
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (_) => Center(
                              child: CircularProgressIndicator(
                                color: AppColors.orange,
                              ),
                            ),
                      );
                      await authProvider
                          .userLogin(
                            email: emailController.text.trim(),
                            password: passwordController.text,
                            context: context,
                          )
                          .then((value) {
                            Navigator.pop(context);
                            if (value == null) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                MenuScreen.routeName,
                                (route) => false,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${authProvider.userModel?.name ?? 'User'} Logged In Successfully',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  backgroundColor: AppColors.green,
                                  duration: Duration(seconds: 5),
                                  showCloseIcon: true,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    value,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 5),
                                  showCloseIcon: true,
                                ),
                              );
                            }
                          });
                    }
                  },
                ),

                SizedBox(height: 23.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Don’t Have Account ? ',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        text: 'Create One',
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap =
                                  () => Navigator.pushNamed(
                                    context,
                                    SignUpScreen.routeName,
                                  ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
