import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:image_network/image_network.dart';
import 'package:gvz/components/my_button.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String loggedInUserEmail;
  late String profilePictureUrl;
  final storageRef = FirebaseStorage.instance
      .ref()
      .child('profile_pictures'); // Storage reference
  //final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchLoggedInUser();
  }

  Future<void> fetchLoggedInUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loggedInUserEmail = user.email ?? '';
        profilePictureUrl = user.photoURL ?? '';
      });
    }
  }

  Future<void> changeProfilePicture(Uint8List selectedImageInBytes) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Generate a unique file name for the user's profile picture
        final fileName =
            '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final reference = storageRef.child(fileName);
        final metadata = SettableMetadata(contentType: 'image/jpeg');
        final uploadTask = reference.putData(selectedImageInBytes, metadata);

        await uploadTask.whenComplete(() async {
          final imageUrl = await reference.getDownloadURL();
          await user.updatePhotoURL(imageUrl);

          setState(() {
            profilePictureUrl = imageUrl;
          });
        });
      }
    } catch (e) {
      // Handle any errors, such as Firebase or storage errors.
      print('Error uploading profile picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 226, 218),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 91, 76),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('email', isEqualTo: loggedInUserEmail)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final userData =
              snapshot.data!.docs.first.data() as Map<String, dynamic>?;

          if (userData == null) {
            return const Center(
              child: Text('User data not found'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    if (kIsWeb) {
                      final selectedImageBytes =
                          await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if (selectedImageBytes != null) {
                        changeProfilePicture(
                            selectedImageBytes.files.first.bytes!);
                      }
                    }
                  },
                  child: Stack(alignment: Alignment.center, children: [
                    CircleAvatar(
                      radius: 80,
                      child: Center(
                        child: ImageNetwork(
                          image: profilePictureUrl.isNotEmpty
                              ? profilePictureUrl
                              : 'https://firebasestorage.googleapis.com/v0/b/groverzmart-31334.appspot.com/o/profile_pictures%2FComponent%201.png?alt=media&token=d4cc130f-372b-49b4-a068-32a75baca507&_gl=1*37efbd*_ga*MzU0NjQwMzEuMTY4NTE3OTgxNg..*_ga_CW55HF8NVT*MTY5ODEzMjQ2My42Mi4xLjE2OTgxMzQ0OTMuNjAuMC4w',
                          width: 160,
                          height: 160,
                          borderRadius: BorderRadius.circular(80),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 7,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 64, 91, 76)),
                        child: const Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 209, 226, 218),
                          size: 30,
                        ),
                      ),
                    )
                  ]),
                ),
                const SizedBox(height: 20),
                Text(
                  userData['name'],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  userData['email'],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                _buildProfileItem(
                  Icons.contact_phone,
                  userData['phone'].toString(),
                ),
                const SizedBox(height: 10),
                _buildProfileItem(
                  Icons.home,
                  userData['address'].toString(),
                ),
                const SizedBox(height: 30),
                MyButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          name: userData['name'],
                          phone: userData['phone'],
                          address: userData['address'],
                        ),
                      ),
                    ).then((editedProfile) {
                      if (editedProfile != null) {
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(snapshot.data!.docs.first.id)
                            .update(editedProfile)
                            .then((_) {
                          setState(() {
                            userData['name'] = editedProfile['name'];
                            userData['phone'] = editedProfile['phone'];
                            userData['address'] = editedProfile['address'];
                          });
                        }).catchError((error) {
                          print('Failed to update profile: $error');
                        });
                      }
                    });
                  },
                  title: 'Edit Profile',
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.green[900],
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String name;
  final int phone;
  final String address;

  const EditProfilePage({
    required this.name,
    required this.phone,
    required this.address,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone.toString());
    addressController = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 226, 218),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 91, 76),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            MyButton(
              onTap: () {
                final editedProfile = {
                  'name': nameController.text,
                  'phone': int.parse(phoneController.text),
                  'address': addressController.text,
                };
                Navigator.pop(context, editedProfile);
              },
              title: 'Save',
            ),
          ],
        ),
      ),
    );
  }
}
