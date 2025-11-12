// Example of how to use the navigation system in your screens

import 'package:flutter/material.dart';
import 'navigation_helper.dart';

class NavigationExample extends StatelessWidget {
  const NavigationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Example')),
      body: Column(
        children: [
          // Authentication Navigation Examples
          ElevatedButton(
            onPressed: () => NavigationHelper.goToSignIn(context),
            child: const Text('Go to Sign In'),
          ),

          ElevatedButton(
            onPressed: () => NavigationHelper.goToForgotPassword(context),
            child: const Text('Go to Forgot Password'),
          ),

          ElevatedButton(
            onPressed:
                () => NavigationHelper.goToOtpVerification(
                  context,
                  email: 'user@example.com',
                ),
            child: const Text('Go to OTP Verification'),
          ),

          ElevatedButton(
            onPressed: () => NavigationHelper.goToSelectWeight(context),
            child: const Text('Go to Select Weight'),
          ),

          const Divider(),

          // Activities Navigation Examples
          ElevatedButton(
            onPressed: () => NavigationHelper.goToChooseTal3aType(context),
            child: const Text('Go to Choose Tal3a Type'),
          ),

          // ElevatedButton(
          //   onPressed: () => NavigationHelper.goToTrainingChooseCoach(context),
          //   child: const Text('Go to Choose Coach'),
          // ),
          // ElevatedButton(
          //   onPressed: () => NavigationHelper.goToTraining(context),
          //   child: const Text('Go to Training'),
          // ),
          const Divider(),

          // Utility Navigation Examples
          ElevatedButton(
            onPressed: () => NavigationHelper.goBack(context),
            child: const Text('Go Back'),
          ),

          ElevatedButton(
            onPressed:
                () => NavigationHelper.pushReplacement(
                  context,
                  '/chooseTal3aType',
                ),
            child: const Text('Push Replacement'),
          ),
        ],
      ),
    );
  }
}

// Example of how to use navigation in your existing widgets
class ExampleButton extends StatelessWidget {
  const ExampleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to OTP verification with email parameter
        NavigationHelper.goToOtpVerification(
          context,
          email: 'user@example.com',
        );
      },
      child: const Text('Verify OTP'),
    );
  }
}

// Example of how to navigate with result
class ExampleWithResult extends StatelessWidget {
  const ExampleWithResult({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Navigate and wait for result
        final result = await Navigator.pushNamed(context, '/chooseTal3aType');

        if (result != null) {
          // Handle the result
          print('Selected: $result');
        }
      },
      child: const Text('Navigate with Result'),
    );
  }
}
