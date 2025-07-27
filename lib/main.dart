import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/utils/app_theme.dart';
import 'package:restaurant_app/view/auth/screens/sign_in_screen.dart';
import 'package:restaurant_app/view/auth/screens/sign_up_screen.dart';
import 'package:restaurant_app/view/home_screen/screens/cart_screen.dart';
import 'package:restaurant_app/view/home_screen/screens/menu_screen.dart';
import 'package:restaurant_app/view_model/cart_provider.dart';
import 'package:restaurant_app/view_model/user_auth_provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserAuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData,
          themeMode: ThemeMode.light,
          routes: {
            SignInScreen.routeName: (_) => SignInScreen(),
            SignUpScreen.routeName: (_) => SignUpScreen(),
            MenuScreen.routeName:
                (_) => ChangeNotifierProvider(
                  create: (context) => CartProvider(),
                  child: MenuScreen(),
                ),
            CartScreen.routeName:
                (_) => ChangeNotifierProvider(
                  create: (context) => CartProvider(),
                  child: CartScreen(),
                ),
          },
          initialRoute:
              FirebaseAuth.instance.currentUser != null
                  ? MenuScreen.routeName
                  : SignInScreen.routeName,
        );
      },
    );
  }
}
