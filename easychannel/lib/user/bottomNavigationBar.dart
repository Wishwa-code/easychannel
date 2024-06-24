import 'package:easychannel/user/DisplayDoctorsScreen.dart';
import 'package:easychannel/user/FindPharmaciesPage.dart';
import 'package:easychannel/user/SettingsScreen.dart';
import 'package:easychannel/user/ViewBookedAppointmentsScreen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  static List<Widget> _widgetOptions = <Widget>[
    DisplayDoctorsScreen(),
    ViewBookedAppointmentsScreen(),
    FindPharmaciesPage(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _selectedIndex,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.medical_services, size: 30),
          Icon(Icons.calendar_today, size: 30),
          Icon(Icons.local_pharmacy, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor, 
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
