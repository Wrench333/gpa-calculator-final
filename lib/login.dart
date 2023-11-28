import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gpa_calculator/shared.dart';
import 'main.dart';
import 'shared.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        await Shared.saveLoginSharedPreference(true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The entered credentials are incorrect. Please try again with correct credentials.'),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        title: Text('Login Page'),
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
                onPressed:() async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                        ),
                      );
                    },);
                  await _signInWithEmailAndPassword();
                  Shared.saveLoginSharedPreference(true);

                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.cyan[400], fontSize: 16.0),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/sign_up');
                },
                child: Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(color: Colors.cyan[400], fontSize: 14.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
