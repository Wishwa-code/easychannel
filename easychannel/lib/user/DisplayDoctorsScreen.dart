import 'package:easychannel/user/BookAppointmentScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayDoctorsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text("Doctors"),
        backgroundColor: Color(0xFF2596be), 
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('doctors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return InkWell(
                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookAppointmentScreen(doctorId: doc.id),
                      ),
                    );
                  },
                  child: DoctorCard(data: data),
                );
              },
            );
          }
          return Center(child: Text("No doctors available"));
        },
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> data;

  DoctorCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8),
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_circle,
                    color: Colors.grey[700], size: 28), 
                SizedBox(width: 10),
                Text(
                  data['name'] ?? 'N/A',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              data['specialization'] ?? 'Unknown Specialization',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Experience: ${data['experience'] ?? '0'} years",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Age: ${data['age'] ?? 'Unknown'}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '${data['availableStartTime'] ?? 'Unknown'} - ${data['availableEndTime'] ?? 'Unknown'}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 4),
            Text(
              data['description'] ?? 'No description provided.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
