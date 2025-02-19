import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:product_new_screen/detail_product.dart';
import 'package:product_new_screen/mainscreen.dart';

class CartScreen2 extends StatefulWidget {
  const CartScreen2({super.key});

  @override
  State<CartScreen2> createState() => _CartScreen2State();
}

class _CartScreen2State extends State<CartScreen2> {
  List<Product> cartItem = [];
  List<int> selectedItems = [];

  int sumQty = 0;

  void loadCartItem() async {
    var item = await Add2Cart.readModelsFromFile();

    setState(() {
      cartItem = item;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadCartItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Cart",
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/icons/trash.svg',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Container(
                    height: 10,
                    color: Colors.grey[200],
                  );
                },
                itemBuilder: (context, index) {
                  return buildProduct(
                    title: cartItem[index].name,
                    price:
                        "${cartItem[index].price_sign} ${cartItem[index].price_sign}${cartItem[index].price}",
                    imageUrl: cartItem[index].image,
                    qty: cartItem[index].quantity,
                    selectedColor: cartItem[index].selectedColor,
                    index: index,
                  );
                },
                itemCount: cartItem.length,
              ),
            ),
            buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget buildProduct({
    required String title,
    required String price,
    required String imageUrl,
    required int qty,
    required String selectedColor,
    int totalQty = 0,
    required int index,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(132, 158, 158, 158),
                width: 1,
              ),
            ),
            width: 100,
            height: 100,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Bounceable(
                        scaleFactor: 0.2,
                        onTap: () {
                          setState(() {
                            selectedItems.contains(index)
                                ? selectedItems.remove(index)
                                : selectedItems.add(index);

                            sumQty = selectedItems
                                .map((index) => cartItem[index].quantity)
                                .reduce((value, element) => value + element);
                          });
                        },
                        child: SvgPicture.asset(
                          height: 20,
                          width: 20,
                          selectedItems.contains(index)
                              ? 'assets/svg/Group 67-2.svg'
                              : 'assets/svg/Group 67.svg',
                        ),
                      ),
                    ],
                  ),
                  Text(
                    selectedColor,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text("Qty : $qty"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFooter() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("selected item ${selectedItems.length}"),
              Text("qty item $sumQty"),
            ],
          ),
        ),
        const Spacer(),
        Bounceable(
          onTap: () {
            List<Product> selectedProducts = selectedItems
                .map(
                  (index) => cartItem[index],
                )
                .toList();

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return BuyNowScreen(
            //         product: selectedProducts,
            //       );
            //     },
            //   ),
            // );

            Navigator.pushNamed(context, '/bn2', arguments: selectedProducts)
                .then((_) {
              setState(() {
                loadCartItem();
              });
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            color: Colors.black,
            child: Center(
              child: Text(
                "Checkout".toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void pushToBuyNow() {}
}
