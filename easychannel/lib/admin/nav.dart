import 'package:easychannel/admin/AddDoctorScreen.dart';
import 'package:easychannel/admin/ViewAllAppointments.dart';
import 'package:easychannel/admin/view.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';



class NavScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<NavScreen> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final _pageOptions = [
    AddDoctorScreen(),
    AppointmentPage(),
    ViewAppointmentsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.add, size: 30),
          Icon(Icons.update, size: 30),
          Icon(Icons.view_agenda, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.blue,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: _pageOptions[_page],
    );
  }
}

