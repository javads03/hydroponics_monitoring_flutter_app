// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:html' as html; // Import dart:html for web-specific features
// import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb to check the platform

// class ScanPageNewl extends StatefulWidget {
//   const ScanPageNewl({Key? key}) : super(key: key);

//   @override
//   _ScanPageNewlState createState() => _ScanPageNewlState();
// }

// class _ScanPageNewlState extends State<ScanPageNewl> {
//   late File _image;
//   late List _results;
//   dynamic res;
//   bool imageSelect = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<Map<String, dynamic>> query(File imageFile) async {
//     final data = http.MultipartFile.fromBytes(
//       'file',
//       await imageFile.readAsBytes(),
//       filename: 'image.jpg',
//     );

//     final request = http.MultipartRequest(
//       'POST',
//       Uri.parse("https://api-inference.huggingface.co/models/Bazaar/cv_apple_leaf_disease_detection"),
//     );
//     request.headers['Authorization'] = "Bearer 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";
//     request.files.add(data);

//     final response = await request.send();

//     if (response.statusCode == 200) {
//       final responseBody = await response.stream.bytesToString();
//       final result = jsonDecode(responseBody);
//       return result;
//     } else {
//       throw Exception('Failed to query the model');
//     }
//   }


//   Future<void> pickImage() async {
//   if (kIsWeb) {
//     final html.FileUploadInputElement input = html.FileUploadInputElement()..accept = 'image/*';
//     input.click();

//     input.onChange.listen((e) {
//       final files = input.files;
//       if (files!.isNotEmpty) {
//         final file = files[0];
//         final image = File(html.Url.createObjectUrlFromBlob(file));
//         imageClassification(image);
//       }
//     });
//   } else {
//     _pickImageMobile();
//   }
// }

//   Future _pickImageMobile() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//     );
//     File image = File(pickedFile!.path);
//     imageClassification(image);
//   }

//   Future imageClassification(File image) async {
//     try {
//       final response = await query(image);
//       // Update the state with the results.
//       setState(() {
//         res = response;
//         _results = res;
//         imageSelect = true;
//       });
//     } catch (e) {
//       print("Error classifying image: $e");
//     }
//   }

  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Image Classification"),
//       ),
//       body: ListView(
//         children: [
//           (imageSelect)
//               ? Container(
//                   margin: const EdgeInsets.all(10),
//                   child: Image.file(_image),
//                 )
//               : Container(
//                   margin: const EdgeInsets.all(10),
//                   child: const Opacity(
//                     opacity: 0.8,
//                     child: Center(
//                       child: Text("No image selected"),
//                     ),
//                   ),
//                 ),
//           SingleChildScrollView(
//             child: Column(
//               children: (imageSelect)
//                   ? _results.map((result) {
//                       return Card(
//                         child: Container(
//                           margin: const EdgeInsets.all(10),
//                           child: Text(
//                             "${result['label']} - ${result['confidence'].toStringAsFixed(2)}",
//                             style: const TextStyle(
//                               color: Colors.red,
//                               fontSize: 20,
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList()
//                   : [],
//             ),
//           )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: pickImage,
//         tooltip: "Pick Image",
//         child: const Icon(Icons.image),
//       ),
//     );
//   }
// }
