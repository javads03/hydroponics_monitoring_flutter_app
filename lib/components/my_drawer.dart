import "dart:html";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:gvz/components/my_list_tile.dart";
import "package:gvz/pages/auth_page.dart";
import "package:gvz/pages/home_page.dart";
import "package:gvz/pages/profile_page.dart";
//import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatefulWidget {
  //final void Function()? onProfileTap;
  //inal void Function()? signOutTap;
  //const MyDrawer({super.key, required this.onProfileTap, required this.signOutTap});
  MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void goToProfile() {
    Navigator.pop(context);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
  }

  void goToHome() {
    Navigator.pop(context);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
  }

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
      (route) => false,
    );
  }

// WhatsApp URL
  static const String whatsappNumber =
      '9778037627'; // Replace with your desired phone number
  final Uri whatsappUrl = Uri.parse('https://wa.me/$whatsappNumber');

  // Function to open WhatsApp chat with the given phone number
  void chatOnWhatsApp() async {
    window.open('https://wa.me/$whatsappNumber', '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: const Color.fromARGB(255, 216, 225, 217),
        child: Column(
          children: [
            const DrawerHeader(
                child: Icon(
              Icons.person,
              color: Color.fromARGB(255, 64, 91, 76),
              size: 64,
            )),
            MyListTile(
              icon: Icons.home,
              text: 'H O M E ',
              onTap: () => goToHome(),
            ),
            MyListTile(
              icon: Icons.person,
              text: 'P R O F I L E ',
              onTap: () => goToProfile(),
            ),
            ListTile(
              leading: const Icon(
                Icons.message,
                color: Color.fromARGB(255, 64, 91, 76),
              ),
              title: const Text(
                'C H A T    W I T H    U S',
                //style: TextStyle(color: Color.fromARGB(255, 64, 91, 76)),
              ),
              onTap: () => chatOnWhatsApp(),
            ),
            MyListTile(
              icon: Icons.logout,
              text: 'L O G O U T ',
              onTap: () => signUserOut(),
            )
          ],
        ));
  }
}
