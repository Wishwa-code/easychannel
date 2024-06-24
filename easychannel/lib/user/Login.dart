import 'package:easychannel/admin/nav.dart';
import 'package:easychannel/user/SignUpScreen.dart';
import 'package:easychannel/user/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8.0);
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _nameController = TextEditingController();
    const Color buttonColor = Color(0xFF2596be);
    const Color borderColor = Color(0xFFE0E0E0);
    const Color textBoxFillColor = Color(0xFFF0F0F0);
    final FirebaseAuth _auth = FirebaseAuth.instance;

    Future<void> _login() async {
      if (_emailController.text == "admin@gmail.com" &&
          _passwordController.text == "admin123") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => NavScreen()),
        );
      } else {
        try {
          final UserCredential userCredential =
              await _auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          if (userCredential.user != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          }
        } on FirebaseAuthException catch (e) {
          String errorMessage = 'An error occurred during login';
          if (e.code == 'user-not-found') {
            errorMessage = 'No user found with this email.';
          } else if (e.code == 'wrong-password') {
            errorMessage = 'Wrong password provided.';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An unexpected error occurred')),
          );
        }
      }
    }

    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 80),  

              Text(
                "Let's start here",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  fillColor: textBoxFillColor,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: borderColor)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  fillColor: textBoxFillColor,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: borderColor)),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                obscureText: true,
              ),
              SizedBox(height: 32),
           ElevatedButton(
  child: Text('Login', style: TextStyle(fontSize: 18)),
  onPressed: _login,
  style: ElevatedButton.styleFrom(
    backgroundColor: buttonColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: borderRadius),
    padding: EdgeInsets.symmetric(vertical: 16.0),
  ),
),
SizedBox(height: 16),
Text(
  'By signing in, I agree with Terms of Use and Privacy Policy',
  style: TextStyle(color: Colors.grey),
  textAlign: TextAlign.center,
),
SizedBox(height: 20), 
TextButton(
  onPressed: () {
    Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignUpScreen()),
        );
  },
  child: Text(
    'Don\'t have an account? Sign up',
    style: TextStyle(
      color: Color(0xFF2596be),  
    ),
  ),
)

            ],
          ),
        ),
      ),
    );
  }
}
