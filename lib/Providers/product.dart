import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../Models/serverUrl.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFav;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFav = false,
  });

  void _setFav(bool newVal) {
    isFav = newVal;
    notifyListeners();
  }

  Future<void> toggleFav(String token, String userId) async {
    final oldStatus = isFav;
    _setFav(!isFav);

    final url = '${ServerURL.url}/userFavs/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(isFav),
      );
      if (response.statusCode >= 400) {
        _setFav(oldStatus);
      }
    } catch (error) {
      _setFav(oldStatus);
    }
  }
}
