import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:product_new_screen/detail_product.dart';
import 'package:product_new_screen/mainscreen.dart';
import 'package:product_new_screen/product.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var displayProduct = [];
  int selectedIndex = 0;
  var txt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: txt,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            hintText: 'Search anything you like',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              displayProduct = products.where((pro) {
                return pro["name"].toLowerCase().contains(value.toLowerCase());
              }).toList();
              if (txt.text.isEmpty) {
                displayProduct.clear();
              }
            });
          },
        ),
      ),
      body: SafeArea(
          child: displayProduct.isEmpty
              ? Center(
                  child: const Text(
                    "No data",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: displayProduct.length,
                  itemBuilder: (context, index) {
                    var pro = Product.fromjSON(displayProduct[index]);
                    return product_add(pro);
                  },
                )),
    );
  }

  Widget product_add(Product item) {
    return Bounceable(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProduct(product: item),
          ),
        );
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Image.network(
                    item.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            item.describtion,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Price: ${item.price_sign}${item.price}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
