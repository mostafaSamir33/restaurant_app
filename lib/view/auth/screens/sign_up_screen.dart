import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/utils/app_assets.dart';
import 'package:restaurant_app/view/auth/screens/sign_in_screen.dart';

import '../../../core/utils/app_colors.dart';
import '../../../view_model/user_auth_provider.dart';
import '../widgets/custom_elevated_button_filled.dart';
import '../widgets/custom_text_form_field_auth.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/SignUpScreen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, size: 24.r, color: AppColors.orange),
        ),
        title: Text(
          'Register',
          style: TextStyle(
            color: AppColors.orange,
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 16.r,
          ).copyWith(bottom: 40.r, top: 10.r),
          children: [
            Center(child: Image.asset(AppAssets.nullFoodImage, width: 250.w)),
            SizedBox(height: 30.h),
            Align(
              alignment: Alignment(0, 0),
              child: Text(
                'Restaurant App',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            CustomTextFormFieldAuth(
              hintText: 'Name',
              password: false,
              prefixIconPath: Icon(
                Icons.person_rounded,
                color: AppColors.orange,
              ),
              controller: nameController,
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Name is required'
                          : null,
            ),
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
                  return 'Email is required';
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
              prefixIconPath: Icon(Icons.lock_rounded, color: AppColors.orange),
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
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
            CustomTextFormFieldAuth(
              hintText: 'Confirm Password',
              password: true,
              prefixIconPath: Icon(Icons.lock_rounded, color: AppColors.orange),
              controller: confirmPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirm your password';
                }
                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            CustomElevatedButtonFilled(
              buttonText: 'Create Account',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context
                      .read<UserAuthProvider>()
                      .userSignup(
                        email: emailController.text.trim(),
                        password: passwordController.text,
                        name: nameController.text,
                        context: context,
                      )
                      .then((value) {
                        if (value == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${nameController.text.trim()} Registered Successfully',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 5),
                              showCloseIcon: true,
                            ),
                          );
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(SignInScreen.routeName); //
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
                  if (context.watch<UserAuthProvider>().loading) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder:
                          (_) => Center(
                            child: CircularProgressIndicator(
                              color: AppColors.green,
                            ),
                          ),
                    );
                  } else {
                    Navigator.pop(context);
                  }
                  // Navigator.of(
                  //   context,
                  // ).pushReplacementNamed(SignInScreen.routeName);
                }
              },
            ),
            SizedBox(height: 18.h),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Already Have Account ? ',
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
                      text: 'Login',
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
