import 'dart:io';

//import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gvz/components/my_drawer.dart';
import 'package:gvz/pages/auth_page.dart';
import 'package:gvz/pages/home_page.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  int _selectedIndex = 1;
  File? image;
  late String output;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
      (route) => false,
    );
  }

  loadmodel() async {
    try {
      await Tflite.loadModel(
          model: "model/model_unquant.tflite", labels: "model/labels.txt");
    } catch (e) {
      print (e.toString());
    }
  }

  Future<void> classifyImage() async {
    output = ""; // Initialize output
    if (image != null) {
      //final Uint8List imageBytes = await image!.readAsBytes();

      try {
        var predictions = await Tflite.runModelOnImage(
          path: image!.path,
          numResults: 2,
          threshold: 0.1,
          imageMean: 127.5,
          imageStd: 127.5,
        );
        if (predictions != null) {
          setState(() {
            // Assuming you want to display the first label from predictions
            output = (predictions[0]['label']).toString();
            loading = false;
          });
        } else {
          output = 'got it';
        }
      } catch (e) {
        print("Error during inference: $e");
      }
    } else {
      output = "nooo";
    }

    // Display the predictions to the user
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Predictions'),
          content: Text(output ?? "No predictions",
              style: TextStyle(
                color: Colors.black,
              )),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    // final ImagePicker _picker = ImagePicker();
    // final pickedFile = await _picker.pickImage(
    //   source: ImageSource.gallery,
    // );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        image = File(result.files.first.name);
      });

      await classifyImage();
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
        body: Center(
          child: Text("Insert"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: pickImage,
          tooltip: "Pick Image",
          child: const Icon(Icons.image),
        ),
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
