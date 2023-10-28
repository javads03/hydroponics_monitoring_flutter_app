import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HighUsers extends StatefulWidget {
  final List<DocumentSnapshot> highlist;
  const HighUsers({super.key, required this.highlist});

  @override
  State<HighUsers> createState() => _HighUsersState();
}

class _HighUsersState extends State<HighUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 226, 218),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 91, 76),
        title: Text('High TDS Customers'),
      ),
      body: ListView.builder(
        itemCount: widget.highlist.length,
        itemBuilder: (context, index) {
          DocumentSnapshot doc = widget.highlist[index];
          String name = doc['name']; 
          String address = doc['address']; 
          String email = doc['email']; 
          int phone = doc['phone']; 
          List<dynamic> TDSarr = doc['TDS'];
          int TDS = TDSarr[TDSarr.length - 1];

          return ListTile(
            title: Text('Name: $name'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address: $address',style: const TextStyle(color: Color.fromARGB(255, 64, 91, 76))),
                Text('Email: $email',style: const TextStyle(color: Color.fromARGB(255, 64, 91, 76))),
                Text('Phone: $phone',style: const TextStyle(color: Color.fromARGB(255, 64, 91, 76))),
                Text('TDS: $TDS',style: const TextStyle(color: Color.fromARGB(255, 64, 91, 76))),
              ],
            ),
          );
        },
      ),
    );
  }
}