import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class RatingPage extends StatefulWidget {
  final String appointmentId;

  RatingPage({required this.appointmentId});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double _rating = 0.0;
  bool _isLoading = false;
  String _waitingTimeMessage = '';
  int? _currentNumber;
  int? _userNumber;
  String? _Month;
  bool? _workingDay;
  bool? _AM_PM;
  int? _visitNo;
  String? _gender;
  bool? _mCancer;
  bool? _sCancer;
  String? _address;


  @override
  void initState() {
    super.initState();
    _fetchAppointmentDetails();
  }

  Future<void> _fetchAppointmentDetails() async {
    setState(() => _isLoading = true);

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.appointmentId)
          .get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      setState(() {
        _currentNumber = data['currentNumber'];
        _userNumber = data['number'];
        _rating = data['rating']?.toDouble() ?? 0.0; 
        _Month = data['Month'];
        _workingDay = data['WorkingDay'];
        _AM_PM = data['AM_PM'];
        _visitNo = data['Visit.No'];
        _gender = data['Gender'];
        _mCancer = data['M.cancer'];
        _sCancer = data['S.cancer'];
        _address = data['Address'];
        

      });

      if (_Month != null ) {
        await _checkWaitingTime(_Month!, _workingDay!, _AM_PM!, _visitNo!, _gender!, _mCancer!, _sCancer!, _address);
      } else {
        _waitingTimeMessage = "No waiting time, the counter is at zero.";
      }
    } catch (e) {
      _waitingTimeMessage = "Failed to fetch appointment details: $e";
    }

    setState(() => _isLoading = false);
  }

  Future<void> _checkWaitingTime(String _Month, bool _workingDay, bool _AM_PM, int _visitNo, String _gender, bool _mCancer, bool _sCancer, _address) async {
    // Call the waiting time API
    print("calling api");
    var response = await http.post(
      Uri.parse('http://192.168.8.187:5000/predict_waiting_time'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(< String, dynamic>{
        'month_input': _Month,
        'working_day_input': _workingDay.toString(),
        'am_pm_input': _AM_PM.toString(),
        'visit_no_input': _visitNo,
        'gender_input': _gender,
        'm_cancer_input': _mCancer.toString(),
        's_cancer_input': _sCancer.toString(),
        'address_input': _address,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _waitingTimeMessage =
            'Your estimated waiting time is: ${data['predicted_waiting_time']}';
      });
    } else {
      setState(() {
        _waitingTimeMessage = 'Failed to get waiting time';
      });
    }
  }

  Future<void> _submitRating() async {

    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(widget.appointmentId)
        .update({'rating': _rating});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rating submitted successfully')),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Appointment'),
        backgroundColor: Color(0xFF2596be),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
  padding: EdgeInsets.all(16.0),
  child: Center(  
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,  
      crossAxisAlignment: CrossAxisAlignment.center,  
      children: [
        RatingBar.builder(
          initialRating: _rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Color(0xFF2596be),
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => _submitRating(),
          child: Text('Submit Rating'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2596be),
            foregroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 24),
        Text(
          _waitingTimeMessage,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,  
        ),
      ],
    ),
  ),
)

    );
  }
}
