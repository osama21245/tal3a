import 'package:flutter/material.dart';

class SignInHeaderWidget extends StatelessWidget {
  const SignInHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 332,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/signin_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.2)),
        child: Stack(
          children: [
            // Tal3a Logo
            Positioned(
              bottom: 20,
              right: 20,
              child: Image.asset(
                'assets/images/tal3a_logo.png',
                width: 67,
                height: 43,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
