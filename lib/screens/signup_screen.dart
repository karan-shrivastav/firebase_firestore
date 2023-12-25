import 'package:firebase_application/screens/login_screen.dart';
import 'package:firebase_application/widgets/default_textfiled.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reenterPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool passwordsMatch = true;

  void _validatePasswords() {
    setState(() {
      passwordsMatch =
          _passwordController.text == _reenterPasswordController.text;
    });
  }

  Future<String> signUpUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);
        res = 'success';
        if (res == 'success') {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }
        }
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'Password should be at least 6 characters';
      }
    } catch (err) {
      print("Hello");
      res = err.toString();
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'SIGNUP HERE',
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
                    cursorColor: Colors.white,
                    controller: _emailController,
                    hintText: 'Email',
                    color: Colors.brown,
                    hintColor: Colors.white,
                    enteredTextColor: Colors.white,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DefaultTextField(
                    cursorColor: Colors.white,
                    controller: _passwordController,
                    hintText: 'Password',
                    color: Colors.brown,
                    hintColor: Colors.white,
                    enteredTextColor: Colors.white,
                    onChanged: (_) => _validatePasswords(),
                      obscureText: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DefaultTextField(
                    cursorColor: Colors.white,
                    controller: _reenterPasswordController,
                    hintText: 'Reenter Password',
                    color: Colors.brown,
                    hintColor: Colors.white,
                    enteredTextColor: Colors.white,
                    obscureText: true,
                    suffixIcon: passwordsMatch
                        ? const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 22,
                          )
                        : SizedBox(),
                    onChanged: (_) => _validatePasswords(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 5),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        primary: Colors.white,
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (passwordsMatch) {
                          signUpUser(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        }
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
