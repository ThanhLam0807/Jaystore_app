import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaystore/app/data/api.dart';
import 'package:jaystore/app/model/product.dart';
import 'package:jaystore/app/page/product/product_add.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductBuilder extends StatefulWidget {
  const ProductBuilder({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductBuilder> createState() => _ProductBuilderState();
}

class _ProductBuilderState extends State<ProductBuilder> {

  Future<List<ProductModel>> _getProducts() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getProduct(prefs.getString('accountID').toString(), prefs.getString('token').toString());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final itemProduct = snapshot.data![index];
              return _buildProduct(itemProduct, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildProduct(ProductModel pro, BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Điều chỉnh độ cong của viền
        side: const BorderSide(
            color: Colors.black, width: 1.0), // Màu và độ dày của viền
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                image: DecorationImage(
                  image: NetworkImage(pro.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,

            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: ${pro.id}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    pro.name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    NumberFormat('#,##0').format(pro.price),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.red,
                    ),
                  ),
                  // const SizedBox(height: 4.0),
                  // Text('Category: ${pro.catId}'),
                  const SizedBox(height: 4.0),
                  Text('Description: ' + pro.description),
                ],
              ),
            ),
            IconButton(
                onPressed: () async {
                    SharedPreferences pref = await SharedPreferences.getInstance();
                  setState(() async {
                    await APIRepository().removeProduct(pro.id, pref.getString('accountID').toString() , pref.getString('token').toString());
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => ProductAdd(
                              isUpdate: true,
                              productModel: pro,
                            ),
                            fullscreenDialog: true,
                          ),
                        )
                        .then((_) => setState(() {}));
                  });
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.black,
                ))
          ],
        ),
      ),
    );
  }
}
