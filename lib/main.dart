import 'package:flutter/material.dart';
import 'package:product_new_screen/add_cart_screen.dart';
import 'package:product_new_screen/bn2.dart';
import 'package:product_new_screen/buttom_navigationbar_sreen.dart';
import 'package:product_new_screen/buy_now_screen.dart';
import 'package:product_new_screen/cart_screen2.dart';
import 'package:product_new_screen/mainscreen.dart';
import 'package:product_new_screen/map_screen.dart';
import 'package:product_new_screen/my%20order/orderscreen.dart';
import 'package:product_new_screen/payment_screen.dart';
import 'package:product_new_screen/product_type_screen.dart';
import 'package:product_new_screen/sign%20in%20&%20sign%20out/register.dart';
import 'package:product_new_screen/sign%20in%20&%20sign%20out/sign_in.dart';
import 'package:product_new_screen/single_screen_buy.dart/buy_now_single_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var pref = await SharedPreferences.getInstance();
  bool isLogin = pref.getBool("isLoggedIn") ?? false;
  runApp(MainApp(
    isLogin: isLogin,
  ));
}

class MainApp extends StatelessWidget {
  bool isLogin;
  MainApp({super.key, this.isLogin = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: isLogin ? '/' : '/sign_in',
      routes: {
        '/': (context) => const ButtomNavigationbarSreen(),
        '/mainscreen': (context) => const Mainscreen(),
        '/productType': (context) => const ProductTypeScreen(),
        '/buy_now_sreen': (context) => const BuyNowScreen(
              product: [],
            ),
        '/payment_screen': (context) => const PaymentScreen(),
        '/map_screen': (context) => const mapsreen(),
        '/cart_screen': (context) => const AddCartScreen(),
        '/cart_screen2': (context) => const CartScreen2(),
        '/bn2': (context) => const BuyNowScreen2(),
        '/order': (context) => const Orderscreen(),
        '/sign_in': (context) => const SignIn(),
        '/register': (context) => const Register(),
        '/single': (context) => const single_product(),
      },
    );
  }
}
