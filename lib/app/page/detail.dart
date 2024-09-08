import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jaystore/app/data/sharepre.dart';
import 'package:jaystore/app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_profile_page.dart'; // Thay thế bằng tên file và đường dẫn thực tế của trang thông tin người dùng
import 'theme_detail_page.dart'; // Thêm import cho trang chi tiết chủ đề

class Detail extends StatefulWidget {
  const Detail({Key? key}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late User user;

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  void getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strUser = pref.getString('user');
    if (strUser != null) {
      setState(() {
        user = User.fromJson(jsonDecode(strUser));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle mystyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(

                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 0.0,
                ),
              ),
              child: Stack(
                children: [
                  SizedBox(
                    height: 180,
                    child: AppBar(
                      backgroundColor: Colors.blueGrey[300],
                      automaticallyImplyLeading: false,
                    ),
                  ),
                  Positioned(
                    left: 131,
                    top: 100,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                        image: DecorationImage(
                          image: NetworkImage(user.imageURL ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 250,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          "${user.fullName ?? ''}",
                          style: mystyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserProfilePage(user: user)),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Thông tin người dùng',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.navigate_next),
                            onPressed: () {
                              // Xử lý sự kiện khi nhấn nút chỉnh sửa
                              // Ví dụ: mở màn hình chỉnh sửa thông tin người dùng
                            },
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 20,
                    thickness: 1,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Xử lý sự kiện khi nhấn vào "Chuyển đổi chủ đề"
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ThemeDetailPage(themeName: 'Chủ đề của bạn')),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.settings,
                                color: Colors.black,
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Chuyển đổi chủ đề',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.navigate_next),
                            onPressed: () {
                              // Xử lý sự kiện khi nhấn nút cài đặt
                              // Ví dụ: mở màn hình cài đặt chủ đề
                            },
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 20,
                    thickness: 1,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Đổi mật khẩu',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.navigate_next),
                            onPressed: () {
                              // Xử lý sự kiện khi nhấn nút cài đặt
                              // Ví dụ: mở màn hình cài đặt chủ đề
                            },
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserProfilePage(user: user)),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.support_agent,
                                color: Colors.black,
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Giúp đỡ & Hỗ trợ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.navigate_next),
                            onPressed: () {
                              // Xử lý sự kiện khi nhấn nút chỉnh sửa
                              // Ví dụ: mở màn hình chỉnh sửa thông tin người dùng
                            },
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 20,
                    thickness: 1,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Xử lý sự kiện khi nhấn vào "Chuyển đổi chủ đề"
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ThemeDetailPage(themeName: 'Chủ đề của bạn')),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.black,
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Đánh giá ứng dụng',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.navigate_next),
                            onPressed: () {
                              // Xử lý sự kiện khi nhấn nút cài đặt
                              // Ví dụ: mở màn hình cài đặt chủ đề
                            },
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 20,
                    thickness: 1,
                  ),
                  GestureDetector(
                    onTap: () {
                      logOut(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.black,
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Đăng xuất',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.navigate_next),
                            onPressed: () {
                              // Xử lý sự kiện khi nhấn nút cài đặt
                              // Ví dụ: mở màn hình cài đặt chủ đề
                            },
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}
