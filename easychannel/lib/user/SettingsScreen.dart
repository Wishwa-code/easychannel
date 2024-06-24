import 'package:easychannel/user/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
void _logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();  
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged out successfully!'),
        backgroundColor: Colors.green,
      ),
    );

 Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to log out. Error: $e'), 
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    final String email = user?.email ?? "No email registered";

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(email),
            subtitle: Text("Email Address"),
            leading: Icon(Icons.email, color: Colors.blueGrey),
          ),
          Divider(),
         
          ListTile(
            title: Text("Privacy Policy"),
            leading: Icon(Icons.privacy_tip_outlined, color: Colors.blueGrey),
            onTap: () {
      
            },
          ),
          ListTile(
            title: Text("Terms & Conditions"),
            leading: Icon(Icons.description, color: Colors.blueGrey),
            onTap: () {

            },
          ),
          Divider(),
      
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () => _logout(context),
              child: Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2596be),
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 16),
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
