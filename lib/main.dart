import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/config/app_colors.dart';
import 'package:laundry_app/config/app_sessions.dart';
import 'package:laundry_app/pages/auth/login_page.dart';
import 'package:laundry_app/pages/main_bottom_nav_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryColor,
          secondary: Colors.greenAccent[400]!,
        ),
        textTheme: GoogleFonts.latoTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                const MaterialStatePropertyAll(AppColors.primaryColor),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            textStyle: const MaterialStatePropertyAll(
              TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
      home: FutureBuilder(
        future: AppSessions.getUser(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const LoginPage();
          }
          return const MainBottomNavPage();
        },
      ),
    );
  }
}
