// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// import 'home_screen.dart';
//
// class MySplashScreen extends StatefulWidget {
//   const MySplashScreen({super.key});
//
//   @override
//   State<MySplashScreen> createState() => _MySplashScreenState();
// }
//
// class _MySplashScreenState extends State<MySplashScreen> {
//   late Animation<double> animation;
//   late AnimationController animationController;
//   late Animation<Color?> colorAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     //animationController = AnimationController(vsync: this, duration: Duration(seconds: 3));
//     animation = Tween<double>(begin: 0.0, end: 100.0).animate(animationController);
//     colorAnimation = ColorTween(begin: Colors.cyanAccent, end: Colors.purple).animate(animationController);
//     animationController.addListener(() {
//       setState(() {});
//     });
//
//     animationController.forward();
//     Timer(Duration(seconds: 5), () {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: AnimatedBuilder(
//           animation: animationController,
//           builder: (BuildContext context, Widget? child) {
//             return Container(
//               width: animation.value,
//               height: animation.value,
//               color: colorAnimation.value,
//               child: Icon(Icons.ac_unit_rounded),
//             );
//           },
//
//         ),
//       ),
//     );
//   }
// }
