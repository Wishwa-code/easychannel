import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychannel/user/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart'; 

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8.0);
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();

    const Color buttonColor = Color(0xFF2596be);
    const Color borderColor = Color(0xFFE0E0E0);
    const Color textBoxFillColor = Color(0xFFF0F0F0);
    final FirebaseAuth _auth = FirebaseAuth.instance;

    Future<void> _registerUser() async {
      try {
        print(_emailController.text.trim());
        print(_passwordController.text.trim());
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userCredential.user != null) {

          String uid = userCredential.user!.uid;

          await FirebaseFirestore.instance.collection('user').doc(uid).set({
            'email': _emailController.text.trim(),
            'name': _nameController.text.trim(),
            'phone': _phoneController.text.trim(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration successful!')),
          );
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register: ${e.toString()}')),
        );
      }
    }

    return Scaffold(
   appBar: AppBar(
  backgroundColor: Colors.white,
  title: Text(
    'Sign up',
    style: TextStyle(
      color: Color(0xFF2596be),  
      fontWeight: FontWeight.bold,  
    ),
  ),
  centerTitle: true, 
  elevation: 0,
),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full name',
                  fillColor: textBoxFillColor,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: borderColor)),
                ),
              ),
              SizedBox(height: 16),
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
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  fillColor: textBoxFillColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: BorderSide(color: borderColor),
                  ),
                ),
                keyboardType:
                    TextInputType.number, 
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter
                      .digitsOnly,
                ],
              ),
              SizedBox(height: 32),
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
  child: Text('Sign up', style: TextStyle(fontSize: 18)),
  onPressed: _registerUser,
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
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
  },
  child: Text(
    'Already have an account? Log in',
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
