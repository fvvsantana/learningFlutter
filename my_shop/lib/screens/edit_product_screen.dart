import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _ProductData {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();

  final _productData = _ProductData();

  var _firstCall = true;
  final _initialData = _ProductData();
  var _isEditing = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_firstCall) {
      final String productId = ModalRoute.of(context).settings.arguments;
      // If editing
      if (productId != null) {
        _isEditing = true;
        final product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initialData.id = product.id;
        _initialData.title = product.title;
        _initialData.description = product.description;
        _initialData.price = product.price;
        _initialData.imageUrl = product.imageUrl;
        _initialData.isFavorite = product.isFavorite;

        _imageUrlController.text = _initialData.imageUrl;
      }
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImage);

    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }

  void _updateImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _submitData() {
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    _form.currentState.save();

    if (_isEditing) {
      Provider.of<Products>(context, listen: false).updateProduct(Product(
        id: _initialData.id,
        isFavorite: _initialData.isFavorite,
        title: _productData.title,
        description: _productData.description,
        imageUrl: _productData.imageUrl,
        price: _productData.price,
      ));
    } else {
      Provider.of<Products>(context, listen: false).addProduct(Product(
        id: DateTime.now().toString(),
        title: _productData.title,
        description: _productData.description,
        imageUrl: _productData.imageUrl,
        price: _productData.price,
      ));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isEditing? const Text('Edit Product') : const Text('Add Product'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _submitData),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _initialData.title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_priceFocusNode),
                  onSaved: (title) => _productData.title = title,
                  validator: (value) =>
                      value.isEmpty ? 'Please provide a value' : null,
                ),
                TextFormField(
                  initialValue: _initialData.price != null
                      ? _initialData.price.toStringAsFixed(2)
                      : null,
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onEditingComplete: () => FocusScope.of(context)
                      .requestFocus(_descriptionFocusNode),
                  onSaved: (price) => _productData.price = double.parse(price),
                  validator: (value) =>
                      value.isEmpty ? 'Please provide a value' : null,
                ),
                TextFormField(
                  initialValue: _initialData.description,
                  decoration: InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  maxLines: 3,
                  onSaved: (description) =>
                      _productData.description = description,
                  validator: (value) =>
                      value.isEmpty ? 'Please provide a value' : null,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        focusNode: _imageUrlFocusNode,
                        controller: _imageUrlController,
                        onEditingComplete: () => setState(() {}),
                        onSaved: (imageUrl) => _productData.imageUrl = imageUrl,
                        validator: (value) =>
                            value.isEmpty ? 'Please provide a value' : null,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
