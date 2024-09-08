import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaystore/app/data/sqlite.dart';
import 'package:jaystore/app/model/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jaystore/app/data/api.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Cart> cartProducts = [];
  Set<int> selectedIndices = {};
  bool editMode = false;

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  void _getProducts() async {
    List<Cart> products = await _databaseHelper.products();
    setState(() {
      cartProducts = products;
    });
  }

  double calculateTotalPayment() {
    double total = 0.0;
    for (int index in selectedIndices) {
      Cart product = cartProducts[index];
      total += product.price * product.count;
    }
    return total;
  }

  void toggleEditMode() {
    setState(() {
      editMode = !editMode;
    });
  }

  void deleteSelectedProducts() async {
    List<Cart> selectedProducts = selectedIndices.map((index) => cartProducts[index]).toList();

    for (Cart product in selectedProducts) {
      await _databaseHelper.deleteProduct(product.productID);
    }

    setState(() {
      _getProducts();
      selectedIndices.clear();
      editMode = false;
    });
  }

  void selectAll() {
    setState(() {
      if (selectedIndices.length == cartProducts.length) {
        selectedIndices.clear();
      } else {
        selectedIndices = Set<int>.from(cartProducts.asMap().keys);
      }
    });
  }

  void _handlePayment() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<Cart> selectedProducts = selectedIndices.map((index) => cartProducts[index]).toList();

    await APIRepository().addBill(
      selectedProducts,
      pref.getString('token').toString(),
    );

    _databaseHelper.clear();
    setState(() {
      selectedIndices.clear();
    });
  }

  void showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.money),
                title: Text('Thanh toán bằng tiền mặt'),
                onTap: () {
                  Navigator.pop(context);
                  _handlePayment();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SuccessPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Thanh toán bằng PayPal'),
                onTap: () {
                  Navigator.pop(context);
                  List<Cart> selectedProducts = selectedIndices.map((index) => cartProducts[index]).toList();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => PaypalCheckout(
                      sandboxMode: true,
                      clientId: "AQaK9hz8KA7NtzANsT4x3qDOXqVY7GuaZfbIDzGSr_3V2Hlw58bDD5s6ZAoUsCZ-Yh5cOGRNedck4liX",
                      secretKey: "EDxBLMht_YxGa9f4DFvI5ZTuEpT2PNVOdzrVTicAWy9ps-b1m2AECSt28c1uUui0h8rjauwO3v96fZEa",
                      returnURL: "success.snippetcoder.com",
                      cancelURL: "cancel.snippetcoder.com",
                      transactions: [
                        {
                          "amount": {
                            "total": calculateTotalPayment().toStringAsFixed(2),
                            "currency": "USD",
                            "details": {
                              "subtotal": calculateTotalPayment().toStringAsFixed(2),
                              "shipping": '0',
                              "shipping_discount": 0
                            }
                          },
                          "description": "The payment transaction description.",
                          "item_list": {
                            "items": selectedProducts.map((product) => {
                              "name": product.name,
                              "quantity": product.count,
                              "price": product.price.toStringAsFixed(2),
                              "currency": "USD"
                            }).toList()
                          }
                        }
                      ],
                      note: "Contact us for any questions on your order.",
                      onSuccess: (Map params) async {
                        print("onSuccess: $params");
                        _handlePayment();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SuccessPage()),
                        );
                      },
                      onError: (error) {
                        print("onError: $error");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => FailurePage()),
                        );
                      },
                      onCancel: () {
                        print('cancelled:');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => FailurePage()),
                        );
                      },
                    ),
                  ));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: selectAll,
            icon: Icon(
              selectedIndices.length == cartProducts.length
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: selectedIndices.length == cartProducts.length
                  ? Colors.black
                  : Colors.grey[500],
            ),
          ),
          TextButton(
            onPressed: toggleEditMode,
            child: Text(
              editMode ? 'Xong' : 'Sửa',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          IconButton(
            onPressed: deleteSelectedProducts,
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 11,
            child: cartProducts.isEmpty
                ? Center(
              child: Text('Không có sản phẩm trong giỏ hàng.'),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: cartProducts.length,
                itemBuilder: (context, index) {
                  final itemProduct = cartProducts[index];
                  return _buildProduct(itemProduct, index, context);
                },
              ),
            ),
          ),
          buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildProduct(Cart pro, int index, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  if (selectedIndices.contains(index)) {
                    selectedIndices.remove(index);
                  } else {
                    selectedIndices.add(index);
                  }
                });
              },
              child: Icon(
                selectedIndices.contains(index)
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: selectedIndices.contains(index)
                    ? Colors.black
                    : Colors.grey[500],
              ),
            ),
            const SizedBox(width: 16.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 120,
                height: 150,
                child: Image.network(
                  pro.img,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pro.name,
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(pro.des),
                  const SizedBox(height: 15.0),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 1),
                    ),
                    child: Text(
                      NumberFormat('#,##0').format(pro.price),
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(width: 1),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _databaseHelper.minus(pro);
                                });
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${pro.count}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _databaseHelper.add(pro);
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tổng tiền thanh toán: ${NumberFormat('#,##0').format(calculateTotalPayment())}',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () => showPaymentOptions(context),
            child: const Text('Thanh toán'),
          ),
        ],
      ),
    );
  }
}

// SuccessPage widget
class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán thành công'),
      ),
      body: Center(
        child: Text(
          'Thanh toán của bạn đã được xử lý thành công!',
          style: TextStyle(fontSize: 20.0, color: Colors.green),
        ),
      ),
    );
  }
}

// FailurePage widget
class FailurePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán thất bại'),
      ),
      body: Center(
        child: Text(
          'Thanh toán của bạn đã gặp sự cố. Vui lòng thử lại!',
          style: TextStyle(fontSize: 20.0, color: Colors.red),
        ),
      ),
    );
  }
}
