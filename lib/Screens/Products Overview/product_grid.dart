import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';

import '../../Providers/products-provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavOnly;

  ProductGrid(this.showFavOnly);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context);
    final products = showFavOnly ? productData.favItems : productData.items;

    return products.isEmpty
        ? Center(
          child: Text("Nothing to show"),
        )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: ProductItem(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
  }
}
