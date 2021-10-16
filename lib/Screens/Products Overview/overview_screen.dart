import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_grid.dart';
import './badge.dart';
import '../Drawer/main_drawer.dart';

import '../../Models/routes.dart';

import '../../Providers/cart.dart';
import '../../Providers/products-provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  bool _showFavOnly = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context).fetchProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productContainer = Provider.of<ProductProvider>(
    //   context,
    //   listen: false,
    // );
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("MyShop"),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cartdata, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.cartPage);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions val) {
              setState(() {
                if (val == FilterOptions.Favorites) {
                  _showFavOnly = true;
                } else {
                  _showFavOnly = false;
                }
                // ? productContainer.showFavOnly()
                // : productContainer.showAll();
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favorites"),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: MainDrawer(0),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavOnly),
    );
  }
}
