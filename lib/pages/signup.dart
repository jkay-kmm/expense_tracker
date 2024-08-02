import 'package:expense_tracker/pages/home_page.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconSplash(),
          _buildTextSplash(),
          const SizedBox(
            height: 56,
          ),
          // _buildButtomGoogle(),
          // SizedBox(height: 12),
          // _buildButtomApple(),

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
          margin: const EdgeInsets.only(top: 12),
          child: const Text(
            "Kitty",
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFF424242),
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 44),
          child: const Text(
            "Create an account",
            style: TextStyle(fontSize: 20, color: Color(0xFF424242)),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, left: 10, right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: const Text(
            "Get started by creating your account to secure your data & manage on multiple devices anytime! ",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF424242),
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  // Widget _buildButtomGoogle() {
  //   return Padding(
  //     padding: const EdgeInsets.all(48),
  //     child: SizedBox(
  //       width: double.infinity,
  //       child: ElevatedButton(
  //         onPressed: () {},
  //         style: ElevatedButton.styleFrom(
  //             backgroundColor: const Color(0xFFFFFFFF),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(4),
  //                 side: const BorderSide(
  //                   color: Color(0xFFBDBDBD),
  //                 ))),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Image.asset(
  //               "assets/images/google.png",
  //               width: 24,
  //               height: 24,
  //               fit: BoxFit.contain,
  //             ),
  //             Container(
  //               margin: const EdgeInsets.only(left: 10),
  //               child: const Text(
  //                 "Sign up with Google",
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: Color(0xFF424242),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
//

// Widget _buildButtomApple(){
//   return Column(
//     children: [
//       Padding(
//         padding: const EdgeInsets.all(48),
//         child: SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFFFFFFF),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4),
//                     side: const BorderSide(
//                       color: Color(0xFFBDBDBD),
//                     ))),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   "assets/images/apple.png",
//                   width: 24,
//                   height: 24,
//                   fit: BoxFit.contain,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(left: 10),
//                   child: const Text(
//                     "Sign up with Apple",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Color(0xFF424242),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }
}
// }