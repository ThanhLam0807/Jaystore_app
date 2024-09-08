import 'package:flutter/material.dart';

class ThemeDetailPage extends StatefulWidget {
  final String themeName; // Thay thế bằng các thuộc tính cần thiết cho trang chi tiết chủ đề

  const ThemeDetailPage({Key? key, required this.themeName}) : super(key: key);

  @override
  _ThemeDetailPageState createState() => _ThemeDetailPageState();
}

class _ThemeDetailPageState extends State<ThemeDetailPage> {
  Color appThemeColor = Colors.white; // Màu chủ đề mặc định

  void changeAppThemeColor(Color color) {
    setState(() {
      appThemeColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết chủ đề'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  changeAppThemeColor(Colors.white); // Thay đổi màu sắc chủ đề khi click vào Container
                },
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 4, color: Colors.grey),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Chủ đề sáng',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  changeAppThemeColor(Colors.black); // Thay đổi màu sắc chủ đề khi click vào Container
                },
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 4, color: Colors.grey),
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Chủ đề tối',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
