import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gvz/pages/high_users.dart';

import 'low_users.dart';
import 'moderate_users.dart';

class UserCategory extends StatefulWidget {
  const UserCategory({super.key});

  @override
  State<UserCategory> createState() => _UserCategoryState();
}

class _UserCategoryState extends State<UserCategory> {
  List<DocumentSnapshot> high = [];
  List<DocumentSnapshot> low = [];
  List<DocumentSnapshot> moderate = [];
  bool dataLoaded = false;

  void goToHigh()
  {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HighUsers(highlist: high)));
  }

  void goToModerate()
  {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ModerateUsers(moderatelist: moderate)));
  }

  void goToLow()
  {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LowUsers(Lowlist: low)));
  }

  @override
  void initState() {
    super.initState();
    categorizeTDSValues();
  }

  Future<void> categorizeTDSValues() async {
    // Query Firestore to get all documents in the "people" collection
    QuerySnapshot peopleSnapshot =
        await FirebaseFirestore.instance.collection('people').get();

    // Iterate through the documents
    for (QueryDocumentSnapshot doc in peopleSnapshot.docs) {
      // Get the TDS array from the document
      List<dynamic> tdsArray = doc['TDS'];

      if (tdsArray.isNotEmpty) {
        // Get the last value of the TDS array
        int lastTDSValue = tdsArray.last;

        // Categorize the document based on TDS value
        if (lastTDSValue > 30) {
          high.add(doc);
        } else if (lastTDSValue < 15) {
          low.add(doc);
        } else {
          moderate.add(doc);
        }
      }
    }
    // Set dataLoaded to true when data is loaded
    setState(() {
      dataLoaded = true;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> pieChartData = [
      PieChartSectionData(
        value: high.length.toDouble(),
        title: 'High TDS',
        color: Colors.red,
      ),
      PieChartSectionData(
        value: low.length.toDouble(),
        title: 'Low TDS',
        color: Colors.green,
      ),
      PieChartSectionData(
        value: moderate.length.toDouble(),
        title: 'Mod TDS',
        color: Colors.yellow,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 226, 218),
      appBar: AppBar(
        title: Text("User categories"),
        backgroundColor: const Color.fromARGB(255, 64, 91, 76),
      ),
      body: SingleChildScrollView(
        child: Center(
          
          child: dataLoaded?(
            Column(
              children: [
                const SizedBox(height: 20,),
                TextButton(onPressed: goToHigh, style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 64, 91, 76))),child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text("       High TDS Users : ${high.length}     ",style: const TextStyle(color: Color.fromARGB(255, 209, 226, 218),fontSize: 18),),
                )),
                const SizedBox(height: 20,),
                TextButton(onPressed: goToModerate, style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 64, 91, 76)),),child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text("  Moderate TDS Users : ${moderate.length.toString()}  ",style: const TextStyle(color: Color.fromARGB(255, 209, 226, 218), fontSize: 18)),
                )),
                const SizedBox(height: 20,),
                TextButton(onPressed: goToLow, style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 64, 91, 76)),),child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text("       Low TDS Users : ${low.length.toString()}      ",style: const TextStyle(color: Color.fromARGB(255, 209, 226, 218), fontSize: 18)),
                )),
                const SizedBox(height: 25,),
                Container(
                height: 450, // Adjust the height as needed
                child: PieChart(
                  PieChartData(
                    sections: pieChartData,
                    borderData: FlBorderData(show: false),
                    centerSpaceRadius: 35.0,
                    
                    sectionsSpace: 7,
                  ),
                ),
              ),
              ]
                
            )
          ) : const CircularProgressIndicator(),
          ),
      ) 
    );
  }
  
}
