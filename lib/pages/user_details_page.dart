import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class UserDetailsPage extends StatefulWidget {
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  List<DocumentSnapshot> usersData = []; // Store user data from Firestore

  @override
  void initState() {
    super.initState();
    getUsersData(); // Retrieve user data from Firestore
  }

  void getUsersData() async {
    // Query Firestore collection to get user data
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('user')
        .orderBy('email')
        .get();

    setState(() {
      usersData = snapshot.docs;
    });
  }

  // Classify users into categories based on TDS value
  List<DocumentSnapshot> classifyUsers(String category) {
    return usersData.where((user) {
      // Retrieve the last recorded TDS value for each user
      List<dynamic> readings = user['reading'];
      if (readings.isNotEmpty) {
        int lastTDSValue = readings.last['TDS'];
        if (category == 'High' && lastTDSValue > 30) {
          return true;
        } else if (category == 'Low' && lastTDSValue < 15) {
          return true;
        } else if (category == 'Moderate' &&
            lastTDSValue >= 15 &&
            lastTDSValue <= 30) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Classify users into three categories
    List<DocumentSnapshot> highTDSUsers = classifyUsers('High');
    List<DocumentSnapshot> lowTDSUsers = classifyUsers('Low');
    List<DocumentSnapshot> moderateTDSUsers = classifyUsers('Moderate');

    // Create data for the pie chart
    int totalUsers = usersData.length;
    int highTDSCount = highTDSUsers.length;
    int lowTDSCount = lowTDSUsers.length;
    int moderateTDSCount = moderateTDSUsers.length;

    // Create data for the pie chart
    List<PieChartSectionData> pieChartData = [
      PieChartSectionData(
        value: highTDSCount.toDouble(),
        title: 'High TDS',
        color: Colors.red,
      ),
      PieChartSectionData(
        value: lowTDSCount.toDouble(),
        title: 'Low TDS',
        color: Colors.green,
      ),
      PieChartSectionData(
        value: moderateTDSCount.toDouble(),
        title: 'Moderate TDS',
        color: Colors.yellow,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display pie chart
            Container(
              height: 300, // Adjust the height as needed
              child: PieChart(
                PieChartData(
                  sections: pieChartData,
                  borderData: FlBorderData(show: false),
                  centerSpaceRadius: 40.0,
                  sectionsSpace: 0,
                ),
              ),
            ),
            SizedBox(height: 20.0),

            // Display user counts in each category
            Text('High TDS Users: $highTDSCount'),
            Text('Low TDS Users: $lowTDSCount'),
            Text('Moderate TDS Users: $moderateTDSCount'),

            SizedBox(height: 20.0),

            // Display user details if needed
            // Example: You can create a ListView.builder to display user details
          ],
        ),
      ),
    );
  }
}
