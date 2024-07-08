import 'package:flappy/game/assets.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key, required this.onTap});

  static const id = 'main_menu';

  final VoidCallback onTap;

  @override
  Widget build(Object context) {
    return Scaffold(
      body: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(Assets.menu),
            fit: BoxFit.cover,
          )),
          child: Image.asset(Assets.message),
        ),
      ),
    );
  }
}
