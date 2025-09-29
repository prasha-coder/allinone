import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sih_2/auth_service.dart';
import 'package:sih_2/app_theme.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue your wellness journey.',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.subtleTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                icon: const Icon(Icons.login, color: Colors.white),
                label: const Text('Sign in with Google'),
                onPressed: () {
                  final authService = Provider.of<AuthService>(context, listen: false);
                  authService.signInWithGoogle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

