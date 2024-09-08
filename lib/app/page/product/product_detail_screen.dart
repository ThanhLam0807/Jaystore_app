import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaystore/app/model/product.dart';
import 'package:jaystore/app/model/cart.dart';
import 'package:jaystore/app/data/sqlite.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  final Future<void> Function() onSave;

  const ProductDetailScreen({
    Key? key,
    required this.product,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sản phẩm'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 250.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 30.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    NumberFormat('#,##0 VND').format(product.price),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Hiển thị mô tả sản phẩm
            Text(
              product.description,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 40),
            // Text "Chọn màu"
            Text(
              'Chọn màu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            // 4 Container nhỏ sắp xếp theo hàng ngang
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorOption(Colors.white, Colors.blue.shade700), // Màu xanh, đường chéo màu đỏ
                _buildColorOption(Colors.white, Colors.black), // Màu xanh lá cây, đường chéo màu cam
                _buildColorOption(Colors.white, Colors.brown.shade500), // Màu đen, đường chéo màu vàng
                _buildColorOption(Colors.black, Colors.blue.shade900), // Màu vàng, đường chéo màu tím
              ],
            ),
            SizedBox(height: 20),
            // Text "Chọn Size"
            Text(
              'Chọn Size',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            // Các Container size
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSizeOption('S'),
                _buildSizeOption('M'),
                _buildSizeOption('L'),
                _buildSizeOption('XL'),
              ],
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await onSave();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Bạn đã thêm vào giỏ hàng thành công',
                        style: TextStyle(color: Colors.green),
                      ),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'Thêm vào giỏ hàng',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color1, Color color2) {
    return GestureDetector(
      onTap: () {
        // Xử lý khi nhấn vào Container màu sắc
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 2, color: Colors.grey),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color1, color2],
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 5),
      ),
    );
  }

  Widget _buildSizeOption(String size) {
    return GestureDetector(
      onTap: () {
        // Xử lý khi nhấn vào Container size
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 2, color: Colors.black),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 5),
      ),
    );
  }
}
