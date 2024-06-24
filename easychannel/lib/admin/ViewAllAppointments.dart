import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewAppointmentsScreen extends StatefulWidget {
  @override
  _ViewAppointmentsScreenState createState() => _ViewAppointmentsScreenState();
}

class _ViewAppointmentsScreenState extends State<ViewAppointmentsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedDoctor;
  DateTime selectedDate = DateTime.now();
  List<String> doctorsList = []; 
  TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  fetchDoctors() async {
    var doctorsSnapshot = await _firestore.collection('doctors').get();
    var fetchedDoctorsList = doctorsSnapshot.docs.map((doc) => doc.data()['name'].toString()).toList();
    setState(() {
      doctorsList = fetchedDoctorsList;
    });
  }

  Future<void> updateAllCurrentNumbers() async {
    if (selectedDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a doctor.')));
      return;
    }


    final newCurrentNumber = int.tryParse(numberController.text);
    if (newCurrentNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid number.')));
      return;
    }


    QuerySnapshot querySnapshot = await _firestore
        .collection('appointments')
        .where('doctorName', isEqualTo: selectedDoctor)
        .where('date', isEqualTo: DateFormat('MM/dd/yyyy').format(selectedDate))
        .get();


    WriteBatch batch = _firestore.batch();
    for (var doc in querySnapshot.docs) {
      batch.update(doc.reference, {'currentNumber': newCurrentNumber});
    }


    await batch.commit();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All numbers updated successfully.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Appointments'),
        backgroundColor: Color(0xFF2596be),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedDoctor,
            hint: Text('Select Doctor'),
            onChanged: (String? newValue) {
              setState(() {
                selectedDoctor = newValue;
              });
            },
            items: doctorsList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
            child: Text('Select Date'),
          ),
          TextField(
            controller: numberController,
            decoration: InputDecoration(
              labelText: 'New Current Number',
              hintText: 'Enter number',
            ),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: updateAllCurrentNumbers,
            child: Text('Update Current Number'),
          ),
      
        ],
      ),
    );
  }
}
