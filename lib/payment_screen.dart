import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Payment Method',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Divider(
                    thickness: 10,
                    color: Colors.grey[200],
                  ),
                  cash_on_delivery(),
                  Divider(
                    thickness: 10,
                    color: Colors.grey[200],
                  ),
                  credit_debit_card(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cash_on_delivery() {
    return Bounceable(
      onTap: () {
        Navigator.pop(
          context,
          'cash on Delivery',
        );
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Image.asset(
                'assets/png/cash 1@3x.png',
                width: 50,
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cash on Delivery',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Cash on Delivery',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget credit_debit_card() {
    return Bounceable(
      onTap: () {
        Navigator.pop(
          context,
          'cash on cart',
        );
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Image.asset(
                'assets/png/cash 2@3x.png',
                width: 50,
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Credit/Debit Card',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'VISA, Mastercard, UnionPay',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
