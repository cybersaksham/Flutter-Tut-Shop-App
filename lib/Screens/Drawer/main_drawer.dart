import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Order Screen/orders_screen.dart';

import '../../Models/routes.dart';

import '../../Providers/auth.dart';

class MainDrawer extends StatelessWidget {
  final int curPage;

  MainDrawer(this.curPage);

  @override
  Widget build(BuildContext context) {
    Icon iconData(var iconType) {
      return Icon(
        iconType,
        color: Theme.of(context).accentColor,
      );
    }

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Shop App"),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: iconData(Icons.shop),
            title: Text(
              "Shop",
              style: TextStyle(
                  color: curPage == 0
                      ? Theme.of(context).accentColor
                      : Colors.black),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Routes.home);
            },
          ),
          Divider(),
          ListTile(
            leading: iconData(Icons.payment),
            title: Text(
              "Orders",
              style: TextStyle(
                  color: curPage == 1
                      ? Theme.of(context).accentColor
                      : Colors.black),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Routes.orderPage);
              // Navigator.of(context).pushReplacement(
              //   CustomRouteAnimation(
              //     builder: (ctx) => OrdersScreen(),
              //   ),
              // );
            },
          ),
          Divider(),
          ListTile(
            leading: iconData(Icons.edit),
            title: Text(
              "Manage Products",
              style: TextStyle(
                  color: curPage == 2
                      ? Theme.of(context).accentColor
                      : Colors.black),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                Routes.userProductPage,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: iconData(Icons.logout),
            title: Text(
              "Logout",
              style: TextStyle(
                  color: curPage == 3
                      ? Theme.of(context).accentColor
                      : Colors.black),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
