import 'package:flutter/material.dart';
import 'package:delivery/Res/AppColors.dart';
import 'package:delivery/View/Home.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:delivery/Navigation/bottom_navigation_bar_with_fab.dart';

class BottomNavigationBarWithFAB extends StatefulWidget {
  const BottomNavigationBarWithFAB({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarWithFAB> createState() =>
      _BottomNavigationBarWithFABState();
}

class _BottomNavigationBarWithFABState
    extends State<BottomNavigationBarWithFAB> {
  int _currentIndex = 0;
  final List<Widget> _interfaces = [
    Home(),
    // Add your other interfaces here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _interfaces[_currentIndex],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: MiddleButton(
        onPressed: () {
          // Add your logic here for the middle button
        },
        icon: 'assets/images/middle.svg',
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: SvgPicture.asset(
                  'assets/images/speed.svg',
                  height: 28,
                  width: 28,
                  color: _currentIndex == 0 ? darkCerulean : Colors.grey,
                ),
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/images/tic.svg',
                  height: 28,
                  width: 28,
                  color: _currentIndex == 1 ? darkCerulean : Colors.grey,
                ),
                onPressed: () {
                  _onItemTapped(1);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MiddleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String icon;

  const MiddleButton({required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: ciel,
      onPressed: onPressed,
      tooltip: 'Middle',
      child: SvgPicture.asset(
        icon,
        height: 35,
        width: 35,
      ),
    );
  }
}
