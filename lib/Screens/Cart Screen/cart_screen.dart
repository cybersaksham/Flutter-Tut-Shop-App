import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './cart_item.dart' as cart_item;

import '../../Providers/cart.dart';
import '../../Providers/orders.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$${cart.totalAmt.toStringAsFixed(2)}",
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderBtn(cart: cart)
                ],
              ),
            ),
          ),
          Expanded(
            child: cart.items.isEmpty
                ? Center(
                    child: Text("Cart is empty"),
                  )
                : ListView.builder(
                    itemBuilder: (ctx, index) => cart_item.CartItem(
                      id: cart.items.values.toList()[index].id,
                      prodId: cart.items.keys.toList()[index],
                      title: cart.items.values.toList()[index].title,
                      quantity: cart.items.values.toList()[index].quantity,
                      price: cart.items.values.toList()[index].price,
                    ),
                    itemCount: cart.items.length,
                  ),
          ),
        ],
      ),
    );
  }
}

class OrderBtn extends StatefulWidget {
  const OrderBtn({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderBtnState createState() => _OrderBtnState();
}

class _OrderBtnState extends State<OrderBtn> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.items.isEmpty || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmt,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
            },
      child: _isLoading ? CircularProgressIndicator() : Text("Checkout"),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
