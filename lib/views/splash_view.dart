import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_application_1/views/task_list_view.dart';

class AnimatedSplashScreenPage extends StatelessWidget {
  const AnimatedSplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size size = MediaQuery.of(context).size;

    return AnimatedSplashScreen(
      duration: 2000, // Duration of animation
      splash: Image.asset(
        'assets/images/ic_launcher.png', // Replace with your splash screen image asset
         width: size.width * 0.9, // Example: 90% of screen width
        height: size.height * 0.9, 
        fit: BoxFit.contain, // Cover the entire screen with the image
      ),
      
      nextScreen: TaskListView(),
      splashTransition: SplashTransition.slideTransition,
      backgroundColor: Colors.white,
    );
  }
}
