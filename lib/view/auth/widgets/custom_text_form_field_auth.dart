import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class CustomTextFormFieldAuth extends StatefulWidget {
  const CustomTextFormFieldAuth({
    super.key,
    required this.hintText,
    required this.password,
    required this.prefixIconPath,
    required this.controller,
    this.validator,
  });

  final String hintText;
  final bool password;
  final Icon prefixIconPath;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  State<CustomTextFormFieldAuth> createState() =>
      _CustomTextFormFieldAuthState();
}

class _CustomTextFormFieldAuthState extends State<CustomTextFormFieldAuth> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.r),
      child: TextFormField(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        validator: widget.validator,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        cursorColor: AppColors.white,
        controller: widget.controller,
        obscureText: widget.password ? isObscure : false,
        decoration: InputDecoration(
          suffixIconColor: AppColors.white,
          hintStyle: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          fillColor: AppColors.darkBlue,
          filled: true,
          hintText: widget.hintText,
          suffixIcon:
              widget.password == true
                  ? GestureDetector(
                    onTap: () {
                      isObscure = !isObscure;
                      setState(() {});
                    },
                    child: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.lightGray,
                    ),
                  )
                  : null,
          prefixIcon: Padding(
            padding: EdgeInsets.all(10.r),
            child: widget.prefixIconPath,
          ),
          border: customBorder(),
          enabledBorder: customBorder(),
          focusedBorder: customBorder(),
          disabledBorder: customBorder(),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: AppColors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: AppColors.red),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder customBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(color: AppColors.lightGray),
    );
  }
}
