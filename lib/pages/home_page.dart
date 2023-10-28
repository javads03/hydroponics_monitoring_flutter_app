import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gvz/components/date_time.dart';
import 'package:gvz/components/my_button.dart';
import 'package:gvz/components/my_drawer.dart';
import 'package:gvz/components/my_textfield.dart';
import 'package:gvz/pages/auth_page.dart';
import 'package:gvz/pages/growth_schedule_page.dart';
import 'package:gvz/pages/login_page.dart';

import 'package:gvz/pages/profile_page.dart';

import 'package:gvz/pages/scan_page.dart';
import 'package:gvz/pages/tds_prediction.dart';
import 'package:gvz/pages/tds_readings.dart';
import 'user_cat.dart';


class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final TDSController = TextEditingController();

  // sign user out method
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
      (route) => false,
    );
  }

  void goToProfile() {
    Navigator.pop(context);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
  }

  int _selectedIndex = 0;
  DateTime? selectedDate;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanPage(),
        ),
      );
    }
  }

  void _showDatePicker() async {
    selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
  }

  void growthSchedule() {
    if (selectedDate != null) {
      List<DateTime> nextFourWeeksDates = [];
      DateTime? currentDate = selectedDate;

      for (int i = 0; i < 5; i++) {
        nextFourWeeksDates.add(currentDate!);
        currentDate = currentDate.add(Duration(days: 7));
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GrowthSchedulePage(dates: nextFourWeeksDates),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 209, 226, 218),
          title: const Text('No Date Selected'),
          content:
              const Text('Please select a date to view the growth schedule.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void addReadings(int TDS, String date) async {
    await FirebaseFirestore.instance
        .collection('reading')
        .add({'TDS': TDS, 'date': date, 'email': user.email!});

    String currentUserEmail = user.email!;

    // Query Firestore to find the document with matching email
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('people')
        .where('email', isEqualTo: currentUserEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assuming there is only one document with the user's email
      DocumentSnapshot doc = querySnapshot.docs.first;

      // Get the current TDS array
      List<dynamic> tdsArray = doc['TDS'];

      // Add the new value to the TDS array
      tdsArray.add(TDS);

      // Update the document with the modified array
      await FirebaseFirestore.instance
          .collection('people')
          .doc(doc.id)
          .update({'TDS': tdsArray});
    } 
    // Navigate to NutrientPage after storing the details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NutrientPrediction(tdsval: TDS.toString()),
      ),
    );
  }

  bool showLoginPage = true;

  //toggle btw login and reg
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not signed in, navigate to the login page or another appropriate page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(
                  onTap: togglePages,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 209, 226, 218),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 64, 91, 76), // Set the desired color
          ),
          actions: [
            IconButton(
              onPressed: signUserOut,
              icon: const Icon(Icons.logout),
              color: const Color.fromARGB(255, 64, 91, 76),
            )
          ],
        ),
        drawer: MyDrawer(),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                DateTimePage(),
                const SizedBox(height: 30),
                MyButton(onTap: _showDatePicker, title: 'Select Custom date'),
                const SizedBox(height: 30),
                MyButton(onTap: growthSchedule, title: 'Growth Schedule'),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        controller: TDSController,
                        hintText: 'Enter the TDS value',
                        obscureText: false,
                      ),
                    ),
                    MyButton(
                        onTap: () {
                          addReadings(int.parse(TDSController.text.trim()),
                              DateTime.now().toString());
                        },
                        title: 'Submit')
                  ],
                ),
                const SizedBox(height: 30),
                MyButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TDSReadings(),
                        ),
                      );
                    },
                    title: 'TDS Readings'),
              ])),
        )),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(25),
          child: GNav(
            mainAxisAlignment: MainAxisAlignment.center,
            selectedIndex: _selectedIndex,
            onTabChange: _onNavItemTapped,
            rippleColor: const Color.fromARGB(255, 14, 35, 15),
            hoverColor: const Color.fromARGB(255, 216, 225, 217),
            tabBackgroundColor: Color.fromARGB(255, 216, 225, 217),
            tabBorderRadius: 24,
            tabActiveBorder: Border.all(color: Colors.white),
            activeColor: Colors.green[900],
            tabs: [
              GButton(
                icon: Icons.home,
                text: '   Home',
              ),
              GButton(
                icon: Icons.qr_code_scanner,
                text: '   Scan',
              ),
            ],
          ),
        ));
  }
}
