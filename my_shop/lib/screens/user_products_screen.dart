import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products';

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  var fetchFuture;

  @override
  void initState() {
    fetchFuture = Provider.of<Products>(context, listen: false)
                  .fetchAndSetProducts(true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<Products>(context, listen: false)
            .fetchAndSetProducts(true),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: FutureBuilder(
              future: fetchFuture,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Consumer<Products>(
                    builder: (_, productsData, __) => ListView.builder(
                      itemCount: productsData.items.length,
                      itemBuilder: (_, i) => Column(
                        children: [
                          UserProductItem(
                            productsData.items[i].id,
                            productsData.items[i].title,
                            productsData.items[i].imageUrl,
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  );
                }else if(snapshot.hasError){
                  throw snapshot.error;
                }else{
                  return Container();
                }
              }),
        ),
      ),
    );
  }
}
