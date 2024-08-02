import 'package:expense_tracker/pages/signup.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignUp()));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: _buildBodyPage()),
      ),
    );
  }

  Widget _buildBodyPage() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconSplash(),
          _buildTextSplash(),
        ],
      ),
    );
  }

  Widget _buildIconSplash() {
    return Image.asset(
      'assets/images/Kitty-Logo.png',
    );
  }

  Widget _buildTextSplash() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 24),
          child: const Text(
            "Kitty",
            style: TextStyle(
                fontSize: 24, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: const Text(
            "Your expense manager",
            style: TextStyle(fontSize: 14, color: Color(0xFF616161)),
          ),
        )
      ],
    );
  }
}
// }