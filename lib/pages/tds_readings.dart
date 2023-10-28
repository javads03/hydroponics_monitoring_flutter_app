import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TDSReadings extends StatefulWidget {
  const TDSReadings({Key? key}) : super(key: key);

  @override
  State<TDSReadings> createState() => _TDSReadingsState();
}

class _TDSReadingsState extends State<TDSReadings> {
  late String loggedInUserEmail;
  final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  final collectionRef = FirebaseFirestore.instance.collection('reading');

  @override
  void initState() {
    super.initState();
    fetchLoggedInUser(); // Fetch the logged-in user's email when the widget initializes
  }

  Future<void> fetchLoggedInUser() async {
    setState(() {
      loggedInUserEmail = currentUserEmail!;
    });
  }

  void deleteReading(String documentId) {
    collectionRef.doc(documentId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 226, 218),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 91, 76),
        title: Text('TDS Readings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reading')
            .where('email', isEqualTo: loggedInUserEmail)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final userDataList = snapshot.data!.docs
              .map((doc) => {
                    ...doc.data() as Map<String, dynamic>,
                    'documentId':
                        doc.id, // Add the document ID to the userData map
                  })
              .toList();
          // Use the userDataList as needed

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: userDataList.map((userData) {
                final datestamp = userData['date'];
                final tds = userData['TDS'];
                final documentId = userData[
                    'documentId']; // Retrieve the document ID from Firestore
                DateTime dateTime = DateTime.parse(datestamp);

                // Extract date, month, and year from the DateTime
                int date = dateTime.day;
                int month = dateTime.month;
                int year = dateTime.year;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Date: $date / $month / $year'),
                    const SizedBox(width: 20),
                    Text('TDS: $tds'),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () => deleteReading(documentId),
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 64, 91, 76),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
