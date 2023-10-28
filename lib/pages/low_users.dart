
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LowUsers extends StatefulWidget {
  final List<DocumentSnapshot> Lowlist;
  const LowUsers({super.key, required this.Lowlist});

  @override
  State<LowUsers> createState() => _LowUsersState();
}

class _LowUsersState extends State<LowUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 226, 218),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 91, 76),
        title: Text('Low TDS Customers'),
      ),
      body: ListView.builder(
        itemCount: widget.Lowlist.length,
        itemBuilder: (context, index) {
          DocumentSnapshot doc = widget.Lowlist[index];
          String name = doc[
              'name']; 
          String address =
              doc['address']; 
          String email =
              doc['email']; 
          int phone =
              doc['phone']; 
          List<dynamic> TDSarr = doc['TDS'];
          int TDS = TDSarr[TDSarr.length - 1];

          return ListTile(
            title: Text('Name: $name'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address: $address',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 64, 91, 76))),
                Text('Email: $email',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 64, 91, 76))),
                Text('Phone: $phone',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 64, 91, 76))),
                Text('TDS: $TDS',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 64, 91, 76))),
              ],
            ),
          );
        },
      ),
    );
  }
}
