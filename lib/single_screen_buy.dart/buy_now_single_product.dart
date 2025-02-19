import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:product_new_screen/app_modal.dart';
import 'package:product_new_screen/coupons_code.dart';
import 'package:product_new_screen/detail_product.dart';
import 'package:product_new_screen/mainscreen.dart';
import 'package:product_new_screen/map_screen.dart';
import 'package:product_new_screen/my%20order/order_helper.dart';
import 'package:product_new_screen/payment_screen.dart';
import 'package:product_new_screen/sign%20in%20&%20sign%20out/login_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class single_product extends StatefulWidget {
  const single_product({super.key});

  @override
  State<single_product> createState() => _single_productState();
}

class _single_productState extends State<single_product> {
  var _address = '';
  int quantity = 1;
  String modalResult = '';
  int discount = 0;
  String payment_met = "Please Select";
  String coup = "apply coupon";
  var textcoup = TextEditingController();
  bool init = false;
  int userid = 0;
  String invoice = "";

  var couponsList;

  void getuserid() async {
    var pref = await SharedPreferences.getInstance();
    var username = pref.getString('username') ?? "";
    var data = await LoginHelper.getUserDetails(username);

    setState(() {
      userid = data?['user_id'];
    });
  }

  @override
  void initState() {
    super.initState();
    invoice = "INV-${DateTime.now().millisecondsSinceEpoch}";
    getuserid();
  }

  double get totalPrice {
    final productItem = ModalRoute.of(context)?.settings.arguments as Product;
    return double.parse(productItem.price) * quantity;
  }

  @override
  Widget build(BuildContext context) {
    final productItem = ModalRoute.of(context)?.settings.arguments as Product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(child: _buildBody(productItem)),
          _buildFooter(),
        ],
      ),
    );
  }

  bool is_check = false;
  int comm = 1;

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Text(
            "\$${(totalPrice - (totalPrice * (discount / 100))).toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            height: 50,
            width: 150,
            decoration: comm == 1
                ? BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                  )
                : comm == 2
                    ? BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(5),
                      )
                    : BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
            child: Center(
              child: Bounceable(
                onTap: () async {
                  setState(() {
                    is_check = !is_check;
                    comm++;
                  });

                  final productItem =
                      ModalRoute.of(context)?.settings.arguments as Product;
                  productItem.quantity = quantity;

                  await OrderSaver.saveOrder(
                      [productItem], _address, invoice, userid);
                  await Add2Cart.removeFromCart(
                      productItem, productItem.selectedColor);
                },
                child: comm == 1
                    ? const Text(
                        "Place Order",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : comm == 2
                        ? const Text(
                            "Process Order",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text(
                            "Completed",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(Product productItem) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text("Orders"),
        ),
        _buildSliverDivider(),
        SliverToBoxAdapter(
          child: Bounceable(
            onTap: () => pushToMap(context),
            child: _buildSliverListTile(
              icon: 'assets/png/Delivery Scooter@3x.png',
              title: "Shipping Address",
              subtitle: _address.isEmpty ? "Add Address" : _address,
            ),
          ),
        ),
        _buildSliverDivider(),
        SliverToBoxAdapter(
          child: Bounceable(
            onTap: () {
              onModalSave(
                title: "Contact Number",
                subtitle: "Enter Phone Number",
              );
            },
            child: _buildSliverListTile(
              icon: 'assets/png/Phone@3x.png',
              title: "Contact Number",
              subtitle: modalResult.isEmpty ? "Add Phone Number" : modalResult,
            ),
          ),
        ),
        _buildSliverDivider(),
        SliverToBoxAdapter(
          child: Bounceable(
            onTap: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentScreen(),
                ),
              );

              if (result is String) {
                setState(() {
                  payment_met = result;
                });
              }
            },
            child: _buildSliverListTile(
              icon: 'assets/png/Cash in Hand@2x.png',
              title: "Payment Method",
              subtitle: payment_met,
            ),
          ),
        ),
        _buildSliverDivider(),
        SliverToBoxAdapter(
          child: _buildSliverProduct(productItem),
        ),
        _buildSliverDivider(),
        SliverToBoxAdapter(
          child: Bounceable(
            onTap: () async {
              _showCouponBottomSheet(context, tittle: "Coupon");
            },
            child: _buildSliverListTile(
              icon: 'assets/png/Voucher@3x.png',
              title: "Coupon",
              subtitle: coup,
            ),
          ),
        ),
        _buildSliverDivider(),
        _buildSliverOrderSummary(productItem),
      ],
    );
  }

  void _showCouponBottomSheet(BuildContext context,
      {required String tittle}) async {
    var result = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  tittle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: textcoup,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(400, 45)),
                  onPressed: () {
                    Navigator.pop(context, textcoup.text);
                  },
                  child: const Text('Save'),
                )
              ],
            ),
          ),
        );
      },
    );

    if (result is String) {
      setState(() {
        coup = result;
      });

      for (int i = 0; i < coupons.length; i++) {
        if (coup == coupons[i]["code"]) {
          setState(() {
            discount = coupons[i]["value"];
          });
        }
      }
    }
  }

  Widget _buildSliverProduct(Product product) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: const Color.fromARGB(119, 158, 158, 158),
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: product.image,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "\$${product.price}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Color: ${product.selectedColor ?? 'N/A'}",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  _buildQtyBtn(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn() {
    return Row(
      children: [
        const Spacer(),
        Bounceable(
          onTap: () {
            setState(() {
              if (quantity > 1) {
                quantity--;
              }
            });
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.black),
                top: BorderSide(width: 1, color: Colors.black),
                left: BorderSide(width: 1, color: Colors.black),
              ),
            ),
            child: const Center(
              child: Icon(Icons.remove, size: 20),
            ),
          ),
        ),
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.black,
            ),
          ),
          child: Center(
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Bounceable(
          onTap: () {
            setState(() {
              quantity++;
            });
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.black),
                top: BorderSide(width: 1, color: Colors.black),
                right: BorderSide(width: 1, color: Colors.black),
              ),
            ),
            child: const Center(
              child: Icon(Icons.add, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverOrderSummary(Product product) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/png/Cash in Hand@2x.png',
                  width: 25,
                  height: 25,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 15),
                const Text(
                  "Order Summary",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Color.fromARGB(77, 158, 158, 158),
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Subtotal",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "\$${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Discount"),
                Text(discount > 0
                    ? "-\$${(totalPrice * (discount / 100)).toStringAsFixed(2)}"
                    : "-------"),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$${(totalPrice - (totalPrice * (discount / 100))).toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverListTile({String? title, String? subtitle, String? icon}) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            icon!,
            width: 25,
            height: 25,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverDivider() {
    return SliverToBoxAdapter(
      child: Container(
        height: 8,
        color: const Color.fromARGB(112, 224, 224, 224),
      ),
    );
  }

  void onModalSave(
      {required String title,
      required String subtitle,
      bool isCoupon = false}) async {
    var result =
        await AppModal().show(context, title: title, subtitle: subtitle);

    if (result is String && !isCoupon) {
      setState(() {
        modalResult = result;
      });
    } else if (result is String && isCoupon) {
      var matchingCoupon = coupons.firstWhere(
        (coupon) => coupon["code"] == result,
        orElse: () {
          IconSnackBar.show(
            context,
            label: 'No Coupon Found',
            snackBarType: SnackBarType.fail,
            labelTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          );
          return couponsList(code: '', value: 0);
        },
      );

      IconSnackBar.show(
        context,
        label: '${matchingCoupon["code"]} Applied',
        snackBarType: SnackBarType.success,
        labelTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      );

      setState(() {
        discount = matchingCoupon["value"];
      });
    }
  }

  void pushToMap(BuildContext context) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const mapsreen(),
      ),
    );

    if (result is String) {
      setState(() {
        _address = result;
      });
    }
  }
}

