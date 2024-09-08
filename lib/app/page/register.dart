import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jaystore/app/data/api.dart';
import 'package:jaystore/app/model/register.dart';
import 'package:jaystore/app/page/auth/login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _gender = 0;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();
  String temp = '';

  Future<String> register() async {
    return await APIRepository().register(
      Signup(
        accountID: _accountController.text,
        birthDay: '',
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        fullName: _fullNameController.text,
        phoneNumber: _phoneNumberController.text,
        schoolKey: '',
        schoolYear: '',
        gender: getGender(),
        imageUrl: _imageURLController.text,
        numberID: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông tin Đăng ký',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black, // Màu nền của AppBar
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black, // Màu nền của body
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/jaystore.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                signUpWidget(),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          String response = await register();
                          if (response == "ok") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          } else {
                            print(response);
                          }
                        },
                        child: const Text(
                          'Đăng ký ngay',
                          style: TextStyle(color: Colors.black), // Màu chữ của nút
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.white), // Màu nền của nút
                          overlayColor: MaterialStateProperty.all(
                              Colors.white.withOpacity(0.5)), // Màu khi nhấn
                          side: MaterialStateProperty.all(
                            BorderSide(color: Colors.white, width: 1), // Viền của nút
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getGender() {
    if (_gender == 1) {
      return "Nam";
    } else if (_gender == 2) {
      return "Nữ";
    }
    return "Khác";
  }

  Widget textField(TextEditingController controller, String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: label.contains('Mật khẩu'),
        onChanged: (value) {
          setState(() {
            temp = value;
          });
        },
        style: TextStyle(color: Colors.black), // Màu chữ của TextFormField
        decoration: InputDecoration(
          hintText: label, // Sử dụng hintText thay vì labelText
          hintStyle: TextStyle(color: Colors.grey), // Màu chữ mô tả khi không focus
          icon: Icon(icon, color: Colors.white), // Màu biểu tượng
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0), // Điều chỉnh chiều cao
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Viền của TextFormField
          ),
          errorText: controller.text.trim().isEmpty ? 'Please enter' : null,
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Viền lỗi khi tập trung
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70), // Viền lỗi
          ),
        ),
      ),
    );
  }

  Widget signUpWidget() {
    return Column(
      children: [
        textField(_accountController, "Tài khoản", Icons.person),
        textField(_passwordController, "Mật khẩu", Icons.password),
        textField(
          _confirmPasswordController,
          "Nhập lại mật khẩu",
          Icons.password,
        ),
        textField(_fullNameController, "Họ tên", Icons.text_fields_outlined),
        textField(_phoneNumberController, "Số điện thoại", Icons.phone),
        const Text(
          "Giới tính của bạn?",
          style: TextStyle(color: Colors.white), // Màu chữ của Text
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Nam", style: TextStyle(color: Colors.white)),
                leading: Transform.translate(
                  offset: const Offset(16, 0),
                  child: Radio(
                    value: 1,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                    activeColor: Colors.white, // Màu khi được chọn
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Nữ", style: TextStyle(color: Colors.white)),
                leading: Transform.translate(
                  offset: const Offset(16, 0),
                  child: Radio(
                    value: 2,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                    activeColor: Colors.white, // Màu khi được chọn
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Khác", style: TextStyle(color: Colors.white)),
                leading: Transform.translate(
                  offset: const Offset(16, 0),
                  child: Radio(
                    value: 3,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                    activeColor: Colors.white, // Màu khi được chọn
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _imageURLController,
          style: TextStyle(color: Colors.black), // Màu chữ của TextFormField
          decoration: const InputDecoration(
            hintText: "Image URL",
            hintStyle: TextStyle(color: Colors.grey), // Màu chữ của label
            icon: Icon(Icons.image, color: Colors.white), // Màu biểu tượng
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0), // Điều chỉnh chiều cao
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white), // Viền của TextFormField
            ),
          ),
        ),
      ],
    );
  }
}
