import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:product_new_screen/detail_product.dart';
import 'package:product_new_screen/mainscreen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Product> wishlistItem = [];

  void _loadWishlist() async {
    final item = await FileHelper.readModelFromFile();

    setState(() {
      wishlistItem = item;
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
        title: const Text('Wishlist'),
      ),
      body: wishlistItem.isEmpty
          ? const Center(
              child: Text("No wishlist"),
            )
          : ListView.builder(
              itemCount: wishlistItem.length,
              itemBuilder: (context, index) {
                return Bounceable(
                  scaleFactor: 0.7,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailProduct(
                          product: wishlistItem[index],
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
                      FileHelper.removeModelFromFile(wishlistItem[index]);
                    },
                    key: ValueKey<String>(wishlistItem[index].name),
                    child: ListTile(
                      leading: Image.network(wishlistItem[index].image),
                      title: Text(
                        wishlistItem[index].name,
                      ),
                      subtitle: Text(
                        wishlistItem[index].describtion,
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
