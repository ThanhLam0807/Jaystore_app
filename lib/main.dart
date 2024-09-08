import 'package:flutter/material.dart';
import 'package:jaystore/app/page/auth/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Chủ đề sáng
        brightness: Brightness.light,
        primaryColor: Colors.blue, // Màu chủ đạo
        // Các thuộc tính khác
      ),
      darkTheme: ThemeData(
        // Chủ đề tối
        brightness: Brightness.dark,
        primaryColor: Colors.indigo, // Màu chủ đạo
        // Các thuộc tính khác
      ),
      themeMode: ThemeMode.light, // Chủ đề mặc định ban đầu
      home: LoginScreen(),
      // initialRoute: "/",
      // onGenerateRoute: AppRoute.onGenerateRoute,  -> sử dụng auto route (pushName)
    );
  }
}
