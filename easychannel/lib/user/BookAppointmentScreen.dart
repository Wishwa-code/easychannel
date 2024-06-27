import 'package:easychannel/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/services.dart';
class BookAppointmentScreen extends StatefulWidget {
  final String doctorId;

  BookAppointmentScreen({required this.doctorId});

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final borderRadius = BorderRadius.circular(8.0);
  final TextEditingController _visitNo = TextEditingController();
  String? _selectedGender;
  bool? _hasMalignantCancer;
  bool? _hasSuspectedCancer;
  String? _selectedAddress;

  static const Color buttonColor = Color(0xFF2596be);
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color textBoxFillColor = Color(0xFFF0F0F0);
  DateTime _selectedDate = DateTime.now();
  Map<String, dynamic>? _customerDetails;
  Map<String, dynamic>? _doctorDetails;
  String monthName = 'not assigned yet';
  bool isWorkingDay = false; 

@override
void initState() {
  super.initState();
  _fetchCustomerDetails();
  _fetchDoctorDetails();



      super.initState();
    tz.initializeTimeZones();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> _fetchCustomerDetails() async {
  User? user = _auth.currentUser;
  if (user != null) {
    try {
      DocumentSnapshot customerSnapshot = await _firestore.collection('user').doc(user.uid).get();
      if (customerSnapshot.exists) {
        setState(() {
          _customerDetails = customerSnapshot.data() as Map<String, dynamic>?;
        });
      } else {
        print('No customer data found');
      }
    } catch (e) {
      print('Failed to fetch customer details: $e');
    }
  } else {
    print('No user logged in');
  }
}

Future<void> _fetchDoctorDetails() async {
  try {
    DocumentSnapshot doctorSnapshot = await _firestore.collection('doctors').doc(widget.doctorId).get();
    if (doctorSnapshot.exists) {
      setState(() {
        _doctorDetails = doctorSnapshot.data() as Map<String, dynamic>?;
      });
    } else {
      print('No doctor data found');
    }
  } catch (e) {
    print('Failed to fetch doctor details: $e');
  }
}

Future<void> _scheduleNotification(int notificationTime) async {
  var androidDetails = AndroidNotificationDetails(
    'channelId', 'channelName',
    channelDescription: 'Your notification channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  var notificationDetails = NotificationDetails(android: androidDetails);


  final tz.TZDateTime scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(minutes: notificationTime));

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Appointment booked',
    'This is the content of the notification',
    scheduledTime,
    notificationDetails,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}


int calculateMinutesToTime(String timeStr) {
  final now = DateTime.now();
  final format = DateFormat('h:mm a');
  DateTime timeToday = format.parse(timeStr); 


  DateTime targetTime = DateTime(now.year, now.month, now.day, 
                                 timeToday.hour, timeToday.minute);

  if (targetTime.isBefore(now)) {

    targetTime = targetTime.add(Duration(days: 1));
  }

  int minutesUntil = targetTime.difference(now).inMinutes; 
  return minutesUntil;
}

Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate,
    firstDate: DateTime.now(),
    lastDate: DateTime(2101),
  );
  if (picked != null && picked != _selectedDate) {
    setState(() {
      _selectedDate = picked;

      // Extract month
      int month = picked.month; 
      String monthNamecal = getMonthName(month); // Get month name (e.g., "June")
      monthName = monthNamecal;
      print(monthName);

      // Determine if working day
      bool isWorkingDaycal = picked.weekday >= 1 && picked.weekday <= 5; 
      isWorkingDay = isWorkingDaycal;
      print(isWorkingDay);
    });
  }
}

// Helper function to get month name
String getMonthName(int month) {
  switch (month) {
    case 1: return "January";
    case 2: return "February";
    case 3: return "March";
    case 4: return "April";
    case 5: return "May";
    case 6: return "June";
    case 7: return "July";
    case 8: return "August";
    case 9: return "September";
    case 10: return "October";
    case 11: return "November";
    case 12: return "December";
    default: return "Invalid Month";
  }
}


void _submitAppointment() async {
  if (_selectedDate == null || _doctorDetails == null || _customerDetails == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please ensure all details are complete.')));
    return;
  }
  final User? user = _auth.currentUser;
  String formattedDate = DateFormat('MM/dd/yyyy').format(_selectedDate); 
  String formattedTimeRange = '${_doctorDetails?['availableStartTime'] ?? ''} - ${_doctorDetails?['availableEndTime'] ?? ''}';
  print(formattedTimeRange);

  // 1. Split the time range into start and end times
  List<String> times = formattedTimeRange.split(" - ");
  String startTime = times[0]; // "1:05 PM"

  // 2. Parse the times into DateTime objects (for easier comparison)
  DateFormat format = DateFormat("h:mm a"); // Format matches the input
  DateTime startTimeObj = format.parse(startTime);

  // 3. Determine the overall time period (morning or afternoon)
  bool AM_PM = startTimeObj.hour < 12; // True if AM, false if PM
  print (AM_PM);

  try {

    var lastAppointmentSnapshot = await _firestore.collection('appointments')
      .where('doctorId', isEqualTo: widget.doctorId)
      .where('date', isEqualTo: formattedDate)
      .orderBy('number', descending: true)
      .limit(1)
      .get();

    int lastNumber = lastAppointmentSnapshot.docs.isEmpty ? 0 : lastAppointmentSnapshot.docs.first.data()['number'] ?? 0;
    int newNumber = lastNumber + 1;

    await _firestore.collection('appointments').add({
      'doctorId': widget.doctorId,
      'doctorName': _doctorDetails?['name'] ?? 'N/A',
      'customerName': _customerDetails?['name'] ?? 'N/A',
      'phoneNumber': _customerDetails?['phone'] ?? 'N/A',
      'date': formattedDate,
      'bookingDate': DateTime.now(),
      'status': 'Pending',
      'customerEmail': user?.email,
      'time': formattedTimeRange,
      'number': newNumber,
      'currentNumber': 0,
      'Month' : monthName,
      'WorkingDay' : isWorkingDay,
      'AM_PM' : AM_PM,
      'Visit.No' : int.parse(_visitNo.text),
      'Gender' : _selectedGender,
      'M.cancer' : _hasMalignantCancer,
      'S.cancer' : _hasSuspectedCancer,
      'Address' : _selectedAddress
    });

    String startTimeString = formattedTimeRange.split(' - ').first;

_scheduleNotification(calculateMinutesToTime(startTimeString));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Appointment submitted successfully')));

  } catch (e) {
     print('$e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit appointment: $e')));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
        backgroundColor: Color(0xFF2596be),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _doctorDetails == null || _customerDetails == null
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Text('Booking for ${_customerDetails?['name'] ?? 'N/A'}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Doctor: ${_doctorDetails?['name'] ?? 'N/A'}', style: TextStyle(fontSize: 20, color: Colors.grey[700])),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.calendar_today, color: Color(0xFF2596be)),
                        title: Text('Select Date', style: TextStyle(fontSize: 18)),
                        subtitle: Text(DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        onTap: () => _selectDate(context),
                      ),
                      SizedBox(height: 32),

                      TextFormField(
                        controller: _visitNo,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
                          labelText: 'Visit no',
                          fillColor: textBoxFillColor,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: borderRadius,
                              borderSide: BorderSide(color: borderColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: borderRadius,
                              borderSide: BorderSide(color: borderColor)),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a visit number';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid integer';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
                          labelText: 'Gender',
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
                        items: <String>['Male', 'Female']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a gender';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      DropdownButtonFormField<bool>(
                        value: _hasMalignantCancer,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
                          labelText: 'Malignant Cancer',
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
                        items: [
                          DropdownMenuItem<bool>(
                            value: true,
                            child: Text('Yes'),
                          ),
                          DropdownMenuItem<bool>(
                            value: false,
                            child: Text('No'),
                          ),
                        ],
                        onChanged: (bool? newValue) {
                          setState(() {
                            _hasMalignantCancer = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      DropdownButtonFormField<bool>(
                        value: _hasSuspectedCancer,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
                          labelText: 'Suspected Cancer',
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
                        items: [
                          DropdownMenuItem<bool>(
                            value: true,
                            child: Text('Yes'),
                          ),
                          DropdownMenuItem<bool>(
                            value: false,
                            child: Text('No'),
                          ),
                        ],
                        onChanged: (bool? newValue) {
                          setState(() {
                            _hasSuspectedCancer = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        value: _selectedAddress,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
                          labelText: 'Address',
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
                        items: <String>['In the city', 'Out of city', 'Out of province']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedAddress = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an address option';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _submitAppointment,
                        child: Text('Submit Appointment', style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2596be),
                          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}