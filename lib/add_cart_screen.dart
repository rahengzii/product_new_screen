import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:product_new_screen/detail_product.dart';
import 'package:product_new_screen/mainscreen.dart';

class AddCartScreen extends StatefulWidget {
  const AddCartScreen({super.key});

  @override
  State<AddCartScreen> createState() => _AddCartScreenState();
}

class _AddCartScreenState extends State<AddCartScreen> {
  List<Product> cartItem = [];

  void _loadWishlist() async {
    final item = await Add2Cart.readModelsFromFile();

    setState(() {
      cartItem = item;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text('Cart'),
      ),
      body: cartItem.isEmpty
          ? const Center(
              child: Text("No Cart"),
            )
          : ListView.builder(
              itemCount: cartItem.length,
              itemBuilder: (context, index) {
                return Bounceable(
                  scaleFactor: 0.7,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailProduct(
                          product: cartItem[index],
                        ),
                      ),
                    ).then(
                      (value) {
                        _loadWishlist();
                      },
                    );
                  },
                  child: Dismissible(
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete),
                    ),
                    onDismissed: (direction) {
                      FileHelper.removeModelFromFile(cartItem[index]);
                    },
                    key: ValueKey<String>(cartItem[index].name),
                    child: ListTile(
                      leading: Image.network(cartItem[index].image),
                      title: Text(
                        cartItem[index].name,
                      ),
                      subtitle: Text(
                        cartItem[index].describtion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
