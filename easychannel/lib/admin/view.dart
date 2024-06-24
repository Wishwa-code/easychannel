import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $phoneNumber')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('appointments').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No appointments found.');
          }
return ListView(
  children: snapshot.data!.docs.map((DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final String customerName = data['customerName'] ?? 'No Name';
    final String doctorName = data['doctorName'] ?? 'No Doctor';
    final String phoneNumber = data['phoneNumber'] ?? 'No Phone';
    final String time = data['time'] ?? 'No Time Specified';
    final double? rating = data['rating']?.toDouble();
    final Timestamp bookingDateTimestamp = data['bookingDate'];
    final DateTime bookingDate = bookingDateTimestamp.toDate();

    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('$customerName - $doctorName', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: $time'),
            Text('Booking Date: ${DateFormat('yyyy-MM-dd').format(bookingDate)}'),
            if (rating != null)
              Text('Rating: ${rating.toStringAsFixed(1)}', style: TextStyle(color: Colors.amber)),
          ],
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(Icons.phone, color: Colors.green),
          onPressed: phoneNumber != 'No Phone' ? () => _makePhoneCall(phoneNumber) : null,
        ),
        onTap: () {

        },
      ),
    );
  }).toList(),
);

        },
      ),
    );
  }
}
