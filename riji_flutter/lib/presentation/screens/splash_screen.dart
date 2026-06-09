import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riji_flutter/core/api/api_client.dart';
import 'package:riji_flutter/data/repositories/auth_repository.dart';
import 'package:riji_flutter/presentation/screens/auth_screen.dart';
import 'package:riji_flutter/presentation/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 1));
    final apiClient = Get.find<ApiClient>();
    final authRepository = AuthRepository(apiClient);
    final isLoggedIn = await authRepository.isLoggedIn();

    if (isLoggedIn) {
      Get.off(() => const HomeScreen());
    } else {
      Get.off(() => const AuthScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book, size: 80, color: Theme.of(context).primaryColor),
            const SizedBox(height: 24),
            const Text(
              '日记本',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
