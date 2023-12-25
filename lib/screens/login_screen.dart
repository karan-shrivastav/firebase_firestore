import 'package:firebase_application/widgets/default_textfiled.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> loginUser(
      {required String email, required String password}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          }
          return 'success';
        } else {
          return 'Authentication failed'; // Handle if userCredential.user is null
        }
      } else {
        return 'Please enter all the fields';
      }
    } catch (err) {
      return err.toString(); // Return the error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'LOGIN HERE',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              DefaultTextField(
                controller: _emailController,
                hintText: 'Email',
                color: Colors.brown,
                hintColor: Colors.white,
                enteredTextColor: Colors.white,
                cursorColor: Colors.white,
              ),
              const SizedBox(
                height: 15,
              ),
              DefaultTextField(
                controller: _passwordController,
                hintText: 'Password',
                color: Colors.brown,
                hintColor: Colors.white,
                enteredTextColor: Colors.white,
                obscureText: true,
                cursorColor: Colors.white,
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(25.0), // Set border radius here
                    ),
                    primary: Colors.white, // Set the button color to red
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    loginUser(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
