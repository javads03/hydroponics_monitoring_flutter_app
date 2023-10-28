// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:gvz/components/my_drawer.dart';
// import 'package:gvz/pages/auth_page.dart';
// import 'package:gvz/pages/home_page.dart';
// import 'package:tflite_web/tflite_web.dart';


// class ScanPage extends StatefulWidget {
//   const ScanPage({super.key});

//   @override
//   State<ScanPage> createState() => _ScanPageState();
// }

// class _ScanPageState extends State<ScanPage> {
//   int _selectedIndex = 1;
//   File? image;
//   late String output;

//   void initState() {
//     super.initState();

//     loadmodel();
//   }

//   void _onNavItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     if (index == 0) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomePage(),
//         ),
//       );
//     }
//   }

//   void signUserOut() async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => AuthPage()),
//       (route) => false,
//     );
//   }

//   loadmodel() async {
//     try {
//       await TfliteWeb.loadModel(
//     model: "assets/model/model_unquant.tflite",
//     labels: "assets/model/labels.txt",
//   );
//     } catch (e) {
//       throw (e.toString());
//     }
//   }

//   Future<void> classifyImage() async {
//   output = ""; // Initialize output
//   if (image != null) {
//     final predictions = await TfliteWeb.runModelOnImage(
//       path: image!.path,
//       numResults: 2,
//       threshold: 0.1,
//       imageMean: 127.5,
//       imageStd: 127.5,
//     );
//     if (predictions != null) {
//       setState(() {
//         output = predictions[0]['label'];
//       });
//     } else {
//       output = 'got it';
//     }
//   } else {
//     output = "nooo";
//   }

//   // Display the predictions to the user in a dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Predictions'),
//         content: Text(output ?? "No predictions",
//             style: TextStyle(
//               color: Colors.black,
//             )),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('OK'),
//           ),
//         ],
//       );
//     },
//   );
// }


//   void pickImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     // final ImagePicker _picker = ImagePicker();
//     // final pickedFile = await _picker.pickImage(
//     //   source: ImageSource.gallery,
//     // );
//     if (result != null && result.files.isNotEmpty) {
//       setState(() {
//         image = File(result.files.first.name);
//       });

//       await classifyImage();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: const Color.fromARGB(255, 209, 226, 218),
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           iconTheme: const IconThemeData(
//             color: Color.fromARGB(255, 64, 91, 76), // Set the desired color
//           ),
//           actions: [
//             IconButton(
//               onPressed: signUserOut,
//               icon: const Icon(Icons.logout),
//               color: const Color.fromARGB(255, 64, 91, 76),
//             )
//           ],
//         ),
//         drawer: MyDrawer(),
//         body: Center(
//           child: Text("Insert"),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: pickImage,
//           tooltip: "Pick Image",
//           child: const Icon(Icons.image),
//         ),
//         bottomNavigationBar: Container(
//           margin: const EdgeInsets.all(25),
//           child: GNav(
//             mainAxisAlignment: MainAxisAlignment.center,
//             selectedIndex: _selectedIndex,
//             onTabChange: _onNavItemTapped,
//             rippleColor: const Color.fromARGB(255, 14, 35, 15),
//             hoverColor: const Color.fromARGB(255, 216, 225, 217),
//             tabBackgroundColor: Color.fromARGB(255, 216, 225, 217),
//             tabBorderRadius: 24,
//             tabActiveBorder: Border.all(color: Colors.white),
//             activeColor: Colors.green[900],
//             tabs: [
//               GButton(
//                 icon: Icons.home,
//                 text: '   Home',
//               ),
//               GButton(
//                 icon: Icons.qr_code_scanner,
//                 text: '   Scan',
//               ),
//             ],
//           ),
//         ));
//   }
// }
