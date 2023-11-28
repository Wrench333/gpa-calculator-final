import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUpWithEmailAndPassword() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("Signed up: ${userCredential.user?.email}");

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      print("Error during sign-up: $e");

      String errorMessage = 'An error occured. Please try again. ';

      if (e.code == 'invalid-email') {
        errorMessage = "Please provide an valid email.";
      } else if (e.code == 'weak-password') {
        errorMessage = "Password should be at least 6 characters.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$errorMessage'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        title: Text('Sign Up Page'),
      ),
      body: Container(
        color: Colors.cyan[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _signUpWithEmailAndPassword,
                child: Text('Sign Up',style: TextStyle(color: Colors.cyan[400],fontSize: 16.0),),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context,'/login');
                },
                child: Text('Already have an account? Login',style: TextStyle(color: Colors.cyan[400],fontSize: 14.0),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}