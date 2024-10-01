import 'package:flutter/material.dart';
import 'package:spm_project/core/services/auth_service.dart';
import 'package:spm_project/core/services/user_service.dart';
import 'package:spm_project/di/injectable.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  final AuthService authService = getit<AuthService>();
  final UserService userService = getit<UserService>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 101, 142, 212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 180),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Login to your account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 75),
                TextField(
                  controller: emailController,
                  decoration:const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.normal,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.normal,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.trim().isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    final userCredential =
                        await authService.signIn(emailController.text, passwordController.text);
                    if (userCredential != null) {
                      userService.addUser();
                      if (context.mounted) {
                        context.go('/');
                      }
                    }
                  },
                  child: const Text('Login'),
                ),
                ElevatedButton(
                    onPressed: () async {
                      final userCredential =
                          await authService.signInWithGoogle();
                      if (userCredential != null) {
                        userService.addUser();
                        if (context.mounted) {
                          context.go('/');
                        }
                      }
                    },
                    child: const Text("Login with google")),
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    height: 1.4,
                    decoration: TextDecoration.none,
                    color: Color(0xff1d1b20),
                  ),
                ),
                const Text(
                  'Register',
                  style: TextStyle(
                    height: 1.4,
                    decoration: TextDecoration.none,
                    color: Color(0xff1d1b20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
