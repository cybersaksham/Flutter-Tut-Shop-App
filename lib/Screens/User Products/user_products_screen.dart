import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './user_product_item.dart';
import '../Drawer/main_drawer.dart';

import '../../Models/routes.dart';

import '../../Providers/products-provider.dart';

class UserProductsScreen extends StatelessWidget {
  Future<void> _refreshPage(BuildContext ctx) async {
    await Provider.of<ProductProvider>(ctx, listen: false).fetchProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                Routes.editProductPage,
                arguments: "",
              );
            },
          )
        ],
      ),
      drawer: MainDrawer(2),
      body: FutureBuilder(
        future: _refreshPage(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshPage(context),
                    child: Consumer<ProductProvider>(
                      builder: (ctx, productData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: productData.items.isEmpty
                            ? Center(
                                child: Text("Nothing to show"),
                              )
                            : ListView.builder(
                                itemCount: productData.items.length,
                                itemBuilder: (_, i) => Column(
                                  children: <Widget>[
                                    UserProductItem(
                                      productData.items[i].id,
                                      productData.items[i].title,
                                      productData.items[i].imageUrl,
                                    ),
                                    Divider(),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
