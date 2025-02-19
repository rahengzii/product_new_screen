import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:product_new_screen/favorite_screen.dart';
import 'package:product_new_screen/mainscreen.dart';
import 'package:product_new_screen/setting_screen.dart';

class ButtomNavigationbarSreen extends StatefulWidget {
  const ButtomNavigationbarSreen({super.key});

  @override
  State<ButtomNavigationbarSreen> createState() =>
      _ButtomNavigationbarSreenState();
}

int _currentIndex = 0;
int _onTabTapped = 0;

class _ButtomNavigationbarSreenState extends State<ButtomNavigationbarSreen> {
  List<Widget> screens = [
    const Mainscreen(),
    const FavoriteScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: IndexedStack(
      //   index: _currentIndex,
      //   children: const [
      //     Mainscreen(),
      //     FavoriteScreen(),
      //     SettingScreen(),
      //   ],
      // ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == 0
                    ? 'assets/svg/home_solid.svg'
                    : 'assets/svg/home 03.svg',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                colorFilter: _currentIndex == 0
                    ? const ColorFilter.mode(Colors.black, BlendMode.srcIn)
                    : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              label: 'Home'),
          // BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == 1
                    ? 'assets/svg/love_solid.svg'
                    : 'assets/svg/love.svg',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                colorFilter: _currentIndex == 1
                    ? const ColorFilter.mode(Colors.black, BlendMode.srcIn)
                    : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              label: 'Wishilist'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == 2
                    ? 'assets/svg/setting_solid.svg'
                    : 'assets/svg/setting.svg',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                colorFilter: _currentIndex == 2
                    ? const ColorFilter.mode(Colors.black, BlendMode.srcIn)
                    : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              label: 'Setting'),
        ],
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        iconSize: 24.0,
        elevation: 8.0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
