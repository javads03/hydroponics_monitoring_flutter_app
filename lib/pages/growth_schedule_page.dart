import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GrowthSchedulePage extends StatefulWidget {
  final List<DateTime> dates;

  GrowthSchedulePage({required this.dates});

  @override
  State<GrowthSchedulePage> createState() => _GrowthSchedulePageState();
}

class _GrowthSchedulePageState extends State<GrowthSchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 226, 218),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 91, 76),
        title: Text('Growth Schedule'),
      ),
      body: ListView.builder(
        itemCount: widget.dates.length,
        itemBuilder: (context, index) {
          DateTime date = widget.dates[index];
          String formattedDate = DateFormat('MMM dd, yyyy').format(date);
          int serialNumber = index + 1;
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: Container(
              alignment: Alignment.center,
              width: 80,
              height: 40,
              child: Text(
                'Week  ' + serialNumber.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ), // Display the serial number
            title: Text(
              formattedDate,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
