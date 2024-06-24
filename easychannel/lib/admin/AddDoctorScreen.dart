import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class AddDoctorScreen extends StatefulWidget {
  @override
  AddDoctorScreenState createState() => AddDoctorScreenState();
}








class AddDoctorScreenState extends State<AddDoctorScreen>  {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  TimeOfDay? _availableStartTime;
  TimeOfDay? _availableEndTime;

  Future<void> _pickStartTime(BuildContext context) async {
    final TimeOfDay? pickedStartTime = await showTimePicker(
      context: context,
      initialTime: _availableStartTime ?? TimeOfDay.now(),
    );
    if (pickedStartTime != null && pickedStartTime != _availableStartTime) {
      setState(() {
        _availableStartTime = pickedStartTime;
      });
    }
  }
  Future<void> _pickEndTime(BuildContext context) async {
    final TimeOfDay? pickedEndTime = await showTimePicker(
      context: context,
      initialTime: _availableEndTime ?? TimeOfDay.now(),
    );
    if (pickedEndTime != null && pickedEndTime != _availableEndTime) {
      setState(() {
        _availableEndTime = pickedEndTime;
      });
    }
  }

Future<void> addDoctor() async {
  print("hello");
  final collection = FirebaseFirestore.instance.collection('doctors');
  try {
    await collection.add({
      'name': _nameController.text.trim(),
      'specialization': _specializationController.text.trim(),
      'experience': _experienceController.text.trim(),
      'age': int.tryParse(_ageController.text.trim()) ?? 0,
      'description': _descriptionController.text.trim(),
     'availableStartTime': _availableStartTime != null ? _availableStartTime!.format(context) : null,
        'availableEndTime': _availableEndTime != null ? _availableEndTime!.format(context) : null,

    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Doctor added successfully!')),
    );
    
    _nameController.clear();
    _specializationController.clear();
    _experienceController.clear();
    _ageController.clear();
    _descriptionController.clear();
  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add doctor: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Doctor'),
        backgroundColor: Color(0xFF2596be), 
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20),
              buildTextField(
                controller: _nameController,
                labelText: 'Doctor Name',
                icon: Icons.person_outline,
              ),
              buildTextField(
                controller: _specializationController,
                labelText: 'Specialization',
                icon: Icons.medical_services_outlined,
              ),
              buildTextField(
                controller: _experienceController,
                labelText: 'Experience',
                icon: Icons.timeline_outlined,
              ),
              buildTextField(
                controller: _ageController,
                labelText: 'Age',
                icon: Icons.cake_outlined,
                keyboardType: TextInputType.number,
              ),    ListTile(
                title: Text('Available Start Time: ${_availableStartTime?.format(context) ?? "Not Set"}'),
                trailing: Icon(Icons.timer),
                onTap: () => _pickStartTime(context),
              ),
              ListTile(
                title: Text('Available End Time: ${_availableEndTime?.format(context) ?? "Not Set"}'),
                trailing: Icon(Icons.timer),
                onTap: () => _pickEndTime(context),
              ),      buildTextField(
                controller: _descriptionController,
                labelText: 'Description',
                icon: Icons.description_outlined,
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(
                  'Add Doctor',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white), 
                ),
                onPressed: () {
                 addDoctor();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 57, 48, 42), 
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }
}
