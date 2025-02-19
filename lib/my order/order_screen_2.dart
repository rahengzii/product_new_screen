import 'package:flutter/material.dart';
import 'package:product_new_screen/my%20order/order_helper.dart';
import 'package:product_new_screen/sign%20in%20&%20sign%20out/login_helper.dart';
import 'package:product_new_screen/sign%20in%20&%20sign%20out/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderScreen2 extends StatefulWidget {
  const OrderScreen2({super.key});

  @override
  State<OrderScreen2> createState() => _OrderScreen2State();
}

class _OrderScreen2State extends State<OrderScreen2> {
  int userId = 0;
  var _orders = [];

  void getUserID() async {
    var pref = await SharedPreferences.getInstance();
    var username = pref.getString("username");

    var data = await LoginHelper.getUserDetails(username!);

    setState(() {
      userId = data?["user_id"] ?? 0;
    });
    getOrders();
  }

  void getOrders() async {
    var ordersItems = await OrderSaver.getAllOrders(userId);

    setState(() {
      _orders = ordersItems;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              var pref = await SharedPreferences.getInstance();
              await pref.remove("isLogin");
              await pref.remove("username");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignIn(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          var orderItem = _orders[index];
          return Column(
            children: [
              ListTile(
                title: Text(orderItem["invoice_id"]),
                subtitle: Text(orderItem["status"]),
              ),
              SizedBox(
                height: 100,
                child: FutureBuilder(
                  future:
                      OrderSaver.getOrderItems(orderItem["invoice_id"], userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No images available');
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Image.network(
                            snapshot.data?[index]["image_url"]);
                      },
                      itemCount: snapshot.data?.length,
                    );
                  },
                ),
              )
            ],
          );
        },
        itemCount: _orders.length,
      ),
    );
  }
}
