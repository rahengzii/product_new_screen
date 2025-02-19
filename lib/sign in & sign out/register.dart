import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:product_new_screen/sign%20in%20&%20sign%20out/login_helper.dart';
import 'package:product_new_screen/sign%20in%20&%20sign%20out/sign_in.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool ishide = false;
  var firs_tname = TextEditingController();
  var last_name = TextEditingController();
  var user_name = TextEditingController();
  var pass = TextEditingController();
  var compass = TextEditingController();

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                profile(),
                const SizedBox(
                  height: 10,
                ),
                firstname(),
                const SizedBox(
                  height: 20,
                ),
                lastname(),
                const SizedBox(
                  height: 20,
                ),
                username(),
                const SizedBox(
                  height: 20,
                ),
                password(),
                const SizedBox(
                  height: 20,
                ),
                compassword(),
                const SizedBox(
                  height: 20,
                ),
                button(),
                const SizedBox(
                  height: 20,
                ),
                login(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profile() {
    return Stack(
      children: [
        Bounceable(
          onTap: () {},
          child: Container(
            width: 100,
            height: 100,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              border: Border.all(width: 2),
            ),
          ),
        ),
        const Positioned(
          top: 60,
          left: 70,
          child: Icon(
            Icons.camera_alt,
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget firstname() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please input at least 1 charactar';
                }
                return null;
              },
              controller: firs_tname,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget lastname() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please input at least 1 charactar';
                }
                return null;
              },
              controller: last_name,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget username() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please input at least 1 charactar';
                } else if (RegExp(".*\\d+.*").hasMatch(value)) {
                  return "Has Number";
                }
                return null;
              },
              controller: user_name,
              decoration: const InputDecoration(
                labelText: 'username',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget password() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please input at least 1 number';
                } else if (RegExp(".*[a-zA-Z].*").hasMatch(value)) {
                  return 'has string';
                }
                return null;
              },
              controller: pass,
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
                      : const Icon(Icons.visibility_off),
                ),
                labelText: 'Password',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget compassword() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please input at least 1 number';
                } else if (RegExp(".*[a-zA-Z].*").hasMatch(value)) {
                  return 'has string';
                }
                return null;
              },
              controller: compass,
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
                      : const Icon(Icons.visibility_off),
                ),
                labelText: 'Confirm Password',
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
                if (formkey.currentState!.validate()) {
                  await LoginHelper.registerUser(user_name.text, pass.text,
                      firs_tname.text, last_name.text);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignIn(),
                      ));
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

  Widget login() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have account?   '),
            Bounceable(
              onTap: () async {
                await LoginHelper.registerUser(
                    user_name.text, pass.text, firs_tname.text, last_name.text);
                Navigator.pop(context);
              },
              child: const Text(
                'Login',
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
