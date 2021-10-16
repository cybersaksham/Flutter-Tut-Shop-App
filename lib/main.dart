import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './Screens/Products Overview/overview_screen.dart';
import './Screens/Product Detail/details_screen.dart';
import './Screens/Cart Screen/cart_screen.dart';
import './Screens/Order Screen/orders_screen.dart';
import './Screens/User Products/user_products_screen.dart';
import './Screens/Edit Products/edit_product_screen.dart';
import './Screens/Authentication/auth_screen.dart';
import './Screens/Splash Screen/splash_screen.dart';

import './Models/routes.dart';

import './Providers/auth.dart';
import './Providers/products-provider.dart';
import './Providers/cart.dart';
import './Providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          update: (ctx, auth, prevProducts) => ProductProvider(
            auth.token,
            auth.userId,
            prevProducts == null ? [] : prevProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, prevOrder) => Orders(
            auth.token,
            auth.userId,
            prevOrder == null ? [] : prevOrder.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? OverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            Routes.authPage: (ctx) => AuthScreen(),
            Routes.home: (ctx) => OverviewScreen(),
            Routes.productDetail: (ctx) => ProductDetailScreen(),
            Routes.cartPage: (ctx) => CartScreen(),
            Routes.orderPage: (ctx) => OrdersScreen(),
            Routes.userProductPage: (ctx) => UserProductsScreen(),
            Routes.editProductPage: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
