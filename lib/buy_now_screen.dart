import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:product_new_screen/mainscreen.dart';
import 'package:product_new_screen/payment_screen.dart';

class BuyNowScreen extends StatefulWidget {
  const BuyNowScreen({super.key, required List<Product> product});

  @override
  State<BuyNowScreen> createState() => _BuyNowScreenState();
}

var image =
    'https://www.nyxcosmetics.com/dw/image/v2/AANG_PRD/on/demandware.static/-/Sites-cpd-nyxusa-master-catalog/default/dwb9e0511a/ProductImages/2016/Face/Cheek_Contour_Duo_Palette/800897012007_cheekcontourduopalette_doubledate_main.jpg?sw=390\u0026sh=390\u0026sm=fit';
double number = 1.0;
var subtotal = 0.0;

class _BuyNowScreenState extends State<BuyNowScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Product?; //widget.product
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Divider(
                      thickness: 10,
                      color: Colors.grey[200],
                    ),
                    delivery(context),
                    Divider(
                      thickness: 12,
                      color: Colors.grey[200],
                    ),
                    Bounceable(
                      onTap: () {
                        _showContactBottomSheet(
                          context,
                          tittle: 'Contact Number',
                        );
                      },
                      child: contact(),
                    ),
                    Divider(
                      thickness: 12,
                      color: Colors.grey[200],
                    ),
                    payment(context),
                    Divider(
                      thickness: 12,
                      color: Colors.grey[200],
                    ),
                    product_buy(args!),
                    Divider(
                      thickness: 12,
                      color: Colors.grey[200],
                    ),
                    Bounceable(
                      hitTestBehavior: HitTestBehavior.translucent,
                      onTap: () {
                        _showCouponBottomSheet(
                          context,
                          tittle: 'Coupon',
                        );
                      },
                      child: coupon(),
                    ),
                    Divider(
                      thickness: 12,
                      color: Colors.grey[200],
                    ),
                    order_summary(args),
                  ],
                ),
              ),
            ),
            total_buy(),
          ],
        ),
      ),
    );
  }

  Widget product_buy(Product data) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Image.network(
              data.image,
              width: 120,
              height: 120,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Text(
                      "USD ${data.price_sign}${data.price}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Color Red',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (number != 1) {
                            number--;
                            subtotal = double.parse(data.price) * number;
                          }
                        });
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: const Icon(Icons.remove),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '$number',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          number++;
                          subtotal = double.parse(data.price) * number;
                        });
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

var getcontext = '';
void _showContactBottomSheet(BuildContext context, {required String tittle}) {
  showModalBottomSheet(
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
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size(400, 45)),
                onPressed: () {
                  Navigator.pop(context, getcontext);
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      );
    },
  );
}

void _showCouponBottomSheet(BuildContext context, {required String tittle}) {
  showModalBottomSheet(
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
              const SizedBox(
                height: 10,
              ),
              TextField(
                // keyboardType: const TextInputType.numberWithOptions(),
                // keyboardType: const TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size(400, 45)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      );
    },
  );
}

var result;
Widget showresult(dynamic result) {
  if (result is String) {
    return Text(result);
  } else {
    return const Text('Select location');
  }
}

Widget delivery(BuildContext context) {
  return Bounceable(
    onTap: () async {
      result = await Navigator.pushNamed(context, '/map_screen');
    },
    child: Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/png/Delivery Scooter@3x.png",
              width: 30,
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Location',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      showresult(result),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget contact() {
  return Container(
    child: Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/png/Phone@3x.png',
                width: 30,
                height: 30,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Number',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    getcontext.isEmpty
                        ? 'Enter your contact number'
                        : getcontext,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget payment(BuildContext context) {
  return Bounceable(
    onTap: () {
      Navigator.pushNamed(
        context,
        '/payment_screen',
        arguments: const PaymentScreen(),
      );
    },
    child: Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/png/Cash in Hand@3x.png',
              height: 30,
              width: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Cash on Delivery',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget coupon() {
  return Container(
    child: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Image.asset(
            'assets/png/Voucher@3x.png',
            width: 30,
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coupon',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  'Enter code to get discount',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget order_summary(Product data) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                'assets/png/Purchase Order@3x.png',
                width: 30,
                height: 30,
                color: Colors.black,
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                child: Text(
                  'Order Summary ($number  item)',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 2,
            color: Colors.grey[200],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const Spacer(),
                Text(
                  'US \$$subtotal',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Row(
              children: [
                Text(
                  'Discount',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                Spacer(),
                Text(
                  '........',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 15),
                ),
                const Spacer(),
                Text(
                  'US \$$subtotal',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    ),
  );
}

Widget total_buy() {
  return Container(
    child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: [
          Text(
            'USD \$$subtotal',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Bounceable(
            onTap: () {},
            child: Container(
              width: 150,
              height: 50,
              color: Colors.black,
              alignment: Alignment.center,
              child: const Text(
                'PLACEE ORDER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
