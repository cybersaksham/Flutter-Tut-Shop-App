import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/product.dart';
import '../../Providers/products-provider.dart';

class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: "",
    description: "",
    price: 0,
    imageUrl: "",
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final prodId = ModalRoute.of(context).settings.arguments.toString();
      if (prodId != "") {
        _editedProduct = Provider.of<ProductProvider>(
          context,
          listen: false,
        ).findByID(prodId);
      } else {
        _editedProduct = Product(
          id: null,
          title: "",
          description: "",
          price: 0,
          imageUrl: "",
        );
      }
      _initValues = {
        'title': _editedProduct.title,
        'description': _editedProduct.description,
        'price': _editedProduct.price.toString(),
      };
      _imageURLController.text = _editedProduct.imageUrl;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageFocusNode.removeListener(_updateImageURL);
    _imageFocusNode.dispose();
    _imageURLController.dispose();
    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageFocusNode.hasFocus) {
      String val = _imageURLController.text;
      if (val.isEmpty ||
          (!val.startsWith("http") && !val.startsWith("http")) ||
          (!val.endsWith("png") &&
              !val.endsWith("jpg") &&
              !val.endsWith("jpeg"))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final _isvalid = _form.currentState.validate();
    if (!_isvalid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error occurred!"),
            content: Text("Something went wrong."),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editedProduct.id == null ? "Add Product" : "Edit Product",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: "Title"),
                      initialValue: _initValues['title'],
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return "This field is required.";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                          title: val,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Price"),
                      initialValue: _initValues['price'],
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return "This field is required.";
                        }
                        if (double.tryParse(val) == null) {
                          return "Enter a valid price.";
                        }
                        if (double.parse(val) <= 0) {
                          return "Enter greater then zero.";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(val),
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Description"),
                      initialValue: _initValues['description'],
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descFocusNode,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "This field is required.";
                        }
                        if (val.length < 10) {
                          return "Should be atleast 10 characters long";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: val,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageURLController.text.isEmpty
                              ? Text("No Image")
                              : FittedBox(
                                  child: Image.network(
                                    _imageURLController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Image URL"),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageURLController,
                            focusNode: _imageFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            validator: (val) {
                              if (val.isEmpty) {
                                return "This field is required.";
                              }
                              if (!val.startsWith("http") &&
                                  !val.startsWith("http")) {
                                return "Enter a valid URL";
                              }
                              if (!val.endsWith("png") &&
                                  !val.endsWith("jpg") &&
                                  !val.endsWith("jpeg")) {
                                return "Enter a valid URL";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: val,
                                id: _editedProduct.id,
                                isFav: _editedProduct.isFav,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
