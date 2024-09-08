import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:jaystore/app/model/cart.dart';

class CheckoutPage extends StatefulWidget {
  final List<Cart> selectedProducts;
  final double totalAmount;

  const CheckoutPage({
    Key? key,
    required this.selectedProducts,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PayPal Checkout",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
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
                      "total": widget.totalAmount.toStringAsFixed(2),
                      "currency": "USD",
                      "details": {
                        "subtotal": widget.totalAmount.toStringAsFixed(2),
                        "shipping": '0',
                        "shipping_discount": 0
                      }
                    },
                    "description": "The payment transaction description.",
                    "item_list": {
                      "items": widget.selectedProducts.map((product) {
                        return {
                          "name": product.name,
                          "quantity": product.count,
                          "price": product.price.toStringAsFixed(2),
                          "currency": "USD",
                        };
                      }).toList(),
                    }
                  }
                ],
                note: "Contact us for any questions on your order.",
                onSuccess: (Map params) async {
                  print("onSuccess: $params");
                },
                onError: (error) {
                  print("onError: $error");
                  Navigator.pop(context);
                },
                onCancel: () {
                  print('cancelled:');
                },
              ),
            ));
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(1),
              ),
            ),
          ),
          child: const Text('Checkout'),
        ),
      ),
    );
  }
}
