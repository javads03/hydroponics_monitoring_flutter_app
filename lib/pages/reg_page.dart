import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gvz/components/my_button.dart';
import 'package:gvz/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegPage extends StatefulWidget {
  final Function()? onTap;
  RegPage({super.key, required this.onTap});

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  // text editing controllers
  final nameController = TextEditingController();

  final addressController = TextEditingController();

  final phoneController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmpasswordController = TextEditingController();

  // sign user in method
  void signUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    if (passwordController.text == confirmpasswordController.text) {
      // try sign in
      try {
        
        //create user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } on FirebaseAuthException catch (e) {
        // pop the loading circle
        Navigator.pop(context);
        showErrorMessage(e.code);
      }
      //add user details
        addUserDetails(
            nameController.text.trim(),
            addressController.text.trim(),
            int.parse(phoneController.text.trim()),
            emailController.text.trim());
    } else {
      showErrorMessage("Passwords don't match");
    }
  }

// wrong email message popup
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 114, 114, 114),
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void addUserDetails(
      String name, String address, int phone, String email) async {
        
    await FirebaseFirestore.instance.collection('user').add({
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
    });

    await FirebaseFirestore.instance.collection('people').add({
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'TDS':{0}
    });
    
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 209, 226, 218),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // welcome back, you've been missed!
                const Text(
                  'Lets create an account',
                  style: TextStyle(
                      color: Color.fromARGB(255, 64, 91, 76),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 25),

                // name textfield
                MyTextField(
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                ),
                const SizedBox(height: 25),
                // username textfield
                MyTextField(
                  controller: addressController,
                  hintText: 'Address',
                  obscureText: false,
                ),

                const SizedBox(height: 25),
                // username textfield
                MyTextField(
                  controller: phoneController,
                  hintText: 'Phone Number',
                  obscureText: false,
                ),

                const SizedBox(height: 25),
                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 25),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // password textfield
                MyTextField(
                  controller: confirmpasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 30),

                // sign in button
                MyButton(
                  onTap: signUp,
                  title: 'Sign Up',
                ),

                // const SizedBox(height: 50),

                // // or continue with
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey[400],
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //         child: Text(
                //           'Or continue with',
                //           style: TextStyle(color: Colors.grey[700]),
                //         ),
                //       ),
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey[400],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // const SizedBox(height: 50),

                // // google + apple sign in buttons
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: const [
                //     // google button
                //     SquareTile(imagePath: 'lib/images/google.png'),

                //     SizedBox(width: 25),

                //     // apple button
                //     SquareTile(imagePath: 'lib/images/apple.png')
                //   ],
                // ),

                // const SizedBox(height: 50),

                // not a member? register now
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
