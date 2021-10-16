import 'package:flutter/material.dart';

class Routes {
  static const String authPage = '/authPage';
  static const String home = '/overview';
  static const String productDetail = '/product-details';
  static const String cartPage = '/cart-page';
  static const String orderPage = '/order-page';
  static const String userProductPage = '/userProducts-page';
  static const String editProductPage = '/editProducts-page';
}

class CustomRouteAnimation<T> extends MaterialPageRoute<T> {
  CustomRouteAnimation({
    WidgetBuilder builder,
    RouteSettings settings,
  }) : super(
          builder: builder,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name == "/") {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == "/") {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
