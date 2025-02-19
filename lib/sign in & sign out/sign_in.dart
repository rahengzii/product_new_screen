import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_new_screen/buttom_navigationbar_sreen.dart';
import 'package:product_new_screen/sign%20in%20&%20sign%20out/login_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool ishide = true;

  var usernameCtrl = TextEditingController();
  var passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            title(),
            const SizedBox(
              height: 50,
            ),
            username(),
            const SizedBox(
              height: 20,
            ),
            passwod(),
            const SizedBox(
              height: 20,
            ),
            button(),
            const SizedBox(
              height: 20,
            ),
            Register(),
          ],
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      child: Column(
        children: [
          Text(
            'R S',
            style: GoogleFonts.acme(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget username() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            TextFormField(
              controller: usernameCtrl,
              decoration: const InputDecoration(
                  labelText: 'Username', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }

  Widget passwod() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            TextFormField(
              controller: passCtrl,
              obscureText: ishide ? false : true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        ishide = !ishide;
                      });
                    },
                    icon: ishide
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off)),
                labelText: 'Password',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget button() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', true);
                await prefs.setString("username", usernameCtrl.text);
                if (await LoginHelper.checkUserExists(
                    usernameCtrl.text, passCtrl.text)) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const ButtomNavigationbarSreen();
                      },
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Failed")));
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('LOGIN'),
            ),
          ],
        ),
      ),
    );
  }

  Widget Register() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Don\'t have acount?  ',
            ),
            Bounceable(
              onTap: () {
                Navigator.pushNamed(context, '/register', arguments: {});
              },
              child: const Text(
                'Register',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
