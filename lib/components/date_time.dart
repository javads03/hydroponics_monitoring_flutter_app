import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePage extends StatefulWidget {
  @override
  _DateTimePageState createState() => _DateTimePageState();
}

class _DateTimePageState extends State<DateTimePage> {
  String _currentDateTime = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (_) {
      _getCurrentDateTime();
    });
  }

  void _getCurrentDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('HH : mm : ss\ndd - MM - yyyy ');
    final formattedDateTime = formatter.format(now);
    setState(() {
      _currentDateTime = formattedDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // Adjust the height as needed
      child: Container(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            
            children: [
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  
                  color: const Color.fromARGB(0, 255, 255, 255), // Added a background color for visibility
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                child: Text(
                  _currentDateTime,
                  style: TextStyle(fontSize: 24, color: Colors.green[900],fontWeight: FontWeight.w600),
                ),
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
