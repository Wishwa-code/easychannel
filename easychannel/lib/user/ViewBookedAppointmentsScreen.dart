import 'package:easychannel/user/RatingPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewBookedAppointmentsScreen extends StatefulWidget {
  @override
  _ViewBookedAppointmentsScreenState createState() =>
      _ViewBookedAppointmentsScreenState();
}

class _ViewBookedAppointmentsScreenState
    extends State<ViewBookedAppointmentsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
@override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    String userEmail = currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Booked Appointments', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2596be),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('appointments')
                        .where('customerEmail', isEqualTo: userEmail)
                        .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching appointments.'));
          }
          if (snapshot.data?.docs.isEmpty ?? true) {
            return Center(child: Text('No appointments found.'));
          }

          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              var appointment = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              DateTime appointmentDate = DateFormat('MM/dd/yyyy').parse(appointment['date']);  

              return Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  ),
  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12), 
  child: InkWell(
    borderRadius: BorderRadius.circular(15),
    onTap: () {
      var appointmentId = snapshot.data!.docs[index].id; 
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RatingPage(appointmentId: appointmentId),
        ),
      );
    },
    child: Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  appointment['doctorName'] ?? 'N/A',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (appointment['rating'] != null)
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text(
                      '${appointment['rating'].toString()}',
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Date: ${DateFormat('EEE, MMM d, yyyy').format(appointmentDate)}', 
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(height: 4),
          Text(
            'Number: ${appointment['number']}',
            style: TextStyle(
              color: Colors.white, 
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Time: ${appointment['time']}',
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(height: 4),
          Text(
            'Status: ${appointment['status']}',
            style: TextStyle(color: appointment['status'] == 'Pending' ? Colors.orange : Colors.green),
          ),
        ],
      ),
    ),
  ),
  elevation: 2,
);

            },
          );
        },
      ),
    );
  }
    }