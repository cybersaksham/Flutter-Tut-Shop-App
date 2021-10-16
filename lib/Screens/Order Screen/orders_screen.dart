import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './order_item.dart' as ordItem;
import '../Drawer/main_drawer.dart';

import '../../Providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  // bool _isLoading = false;

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) async {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await Provider.of<Orders>(context, listen: false).fetchOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: MainDrawer(1),
      body: FutureBuilder(
        future: Provider.of<Orders>(
          context,
          listen: false,
        ).fetchOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text("Some error occurred!"),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) {
                  return orderData.orders.isEmpty
                      ? Center(
                          child: Text("Nothing to show"),
                        )
                      : ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (ctx, i) => ordItem.OrderItem(
                            orderData.orders[i],
                          ),
                        );
                },
              );
            }
          }
        },
      ),
    );
  }
}
