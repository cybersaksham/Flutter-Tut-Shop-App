import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/http_exception.dart';
import '../Models/serverUrl.dart';

import './product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];
  final String _authToken;
  final String _userId;

  ProductProvider(this._authToken, this._userId, this._items);

  // bool _showFavOnly = false;

  List<Product> get items {
    // return _showFavOnly ? _items.where((prod) => prod.isFav) : [..._items];
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((prod) => prod.isFav).toList();
  }

  Product findByID(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$_userId"' : '';
    final url = '${ServerURL.url}/products.json?auth=$_authToken$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      final favUrl = '${ServerURL.url}/userFavs/$_userId.json?auth=$_authToken';
      final favResponse = await http.get(favUrl);
      final favData = json.decode(favResponse.body);
      extractedData.forEach((key, value) {
        loadedProducts.add(
          Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            isFav: favData == null ? false : favData[key] ?? false,
            imageUrl: value['imageUrl'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = '${ServerURL.url}/products.json?auth=$_authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': _userId,
        }),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String prodId, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == prodId);
    final url = '${ServerURL.url}/products/$prodId.json?auth=$_authToken';
    await http.patch(
      url,
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
      }),
    );
    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  // void dltProduct(String prodId) {
  //   final url = '${ServerURL.url}/products/$prodId.json?auth=$_authToken';
  //   final existingProdIndex = _items.indexWhere((prod) => prod.id == prodId);
  //   var existingProd = _items[existingProdIndex];
  //   http.delete(url).then((response) {
  //     if (response.statusCode >= 400) {
  //       throw HttpException("Could not delete product");
  //     }
  //     existingProd = null;
  //   }).catchError((_) {
  //     _items.insert(existingProdIndex, existingProd);
  //   });
  //   _items.removeAt(existingProdIndex);
  //   notifyListeners();
  // }

  Future<void> dltProduct(String prodId) async {
    final url = '${ServerURL.url}/products/$prodId.json?auth=$_authToken';
    final existingProdIndex = _items.indexWhere((prod) => prod.id == prodId);
    var existingProd = _items[existingProdIndex];
    _items.removeAt(existingProdIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProdIndex, existingProd);
      notifyListeners();
      throw HttpException("Could not delete product");
    }
    existingProd = null;
  }

  // void showFavOnly() {
  //   _showFavOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavOnly = false;
  //   notifyListeners();
  // }
}
