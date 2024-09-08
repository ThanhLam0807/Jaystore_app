import 'package:flutter/material.dart';
import 'package:jaystore/app/model/user.dart';

class UserProfilePage extends StatefulWidget {
  final User user;

  const UserProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late TextEditingController _fullNameController;
  late TextEditingController _genderController;
  late TextEditingController _birthDayController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _idNumberController;
  late TextEditingController _schoolYearController;
  late TextEditingController _schoolKeyController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _genderController = TextEditingController(text: widget.user.gender);
    _birthDayController = TextEditingController(text: widget.user.birthDay);
    _phoneNumberController = TextEditingController(text: widget.user.phoneNumber);
    _idNumberController = TextEditingController(text: widget.user.idNumber);
    _schoolYearController = TextEditingController(text: widget.user.schoolYear);
    _schoolKeyController = TextEditingController(text: widget.user.schoolKey);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _genderController.dispose();
    _birthDayController.dispose();
    _phoneNumberController.dispose();
    _idNumberController.dispose();
    _schoolYearController.dispose();
    _schoolKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text('Thông tin người dùng', style: TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(widget.user.imageURL ?? ''),
            ),
            SizedBox(height: 10),
            Divider(thickness: 2),
            _buildUserInfoRow('Họ tên:', _fullNameController),
            Divider(thickness: 1),
            _buildUserInfoRow('Giới tính:', _genderController),
            Divider(thickness: 1),
            _buildUserInfoRow('Ngày sinh:', _birthDayController),
            Divider(thickness: 1),
            _buildUserInfoRow('Số điện thoại:', _phoneNumberController),
            Divider(thickness: 1),
            _buildUserInfoRow('CCCD:', _idNumberController),
            Divider(thickness: 1),
            _buildUserInfoRow('Năm học:', _schoolYearController),
            Divider(thickness: 1),
            _buildUserInfoRow('Khóa học:', _schoolKeyController),
            Divider(thickness: 2),
            // Add more user details as needed

            // Buttons Row
            _isEditing
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle save button press
                    setState(() {
                      widget.user.fullName = _fullNameController.text;
                      widget.user.gender = _genderController.text;
                      widget.user.birthDay = _birthDayController.text;
                      widget.user.phoneNumber = _phoneNumberController.text;
                      widget.user.idNumber = _idNumberController.text;
                      widget.user.schoolYear = _schoolYearController.text;
                      widget.user.schoolKey = _schoolKeyController.text;
                      _isEditing = false; // Disable editing mode
                    });
                  },
                  child: Text('Lưu'),
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle edit button press
                    setState(() {
                      _isEditing = true; // Enable editing mode
                    });
                  },
                  child: Text('Chỉnh sửa'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Flexible(
            child: _isEditing
                ? TextFormField(
              controller: controller,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            )
                : Text(
              controller.text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
