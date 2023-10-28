// class EditProfilePage extends StatefulWidget {
//   final String name;
//   final String phone;
//   final String address;

//   const EditProfilePage({
//     required this.name,
//     required this.phone,
//     required this.address,
//   });

//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }

//   class _EditProfilePageState extends State<EditProfilePage> {
//   late TextEditingController nameController;
//   late TextEditingController phoneController;
//   late TextEditingController addressController;

//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController(text: widget.name);
//     phoneController = TextEditingController(text: widget.phone);
//     addressController = TextEditingController(text: widget.address);
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 209, 226, 218),
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 64, 91, 76),
//         title: Text('Edit Profile'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 30,),
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             const SizedBox(height: 30,),
//             TextField(
//               controller: phoneController,
//               decoration: InputDecoration(labelText: 'Phone'),
//             ),
//             const SizedBox(height: 30,),
//             TextField(
//               controller: addressController,
//               decoration: InputDecoration(labelText: 'Address'),
//             ),
//             const SizedBox(height: 30,),
//             MyButton(
//                     onTap: () {
//                   final editedProfile = {
//                     'name': nameController.text,
//                     'phone': phoneController.text,
//                     'address': addressController.text,
//                   };
//                   Navigator.pop(context, editedProfile);
//                 },
//                     title: 'Save'),

        
//           ],
//       ),
//       ),
//     );
//   }
//   }