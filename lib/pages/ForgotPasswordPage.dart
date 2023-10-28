import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gvz/components/my_button.dart';
import 'package:gvz/components/my_textfield.dart';

class FgotPage extends StatefulWidget {
  const FgotPage({super.key});

  @override
  State<FgotPage> createState() => _FgotPageState();
}

class _FgotPageState extends State<FgotPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Color.fromARGB(255, 64, 91, 76),
            title: Center(
              child: Text(
                'Password reset link sent! Check your Email',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 64, 91, 76),
            title: Center(
              child: Text(
                e.code.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 209, 226, 218),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 64, 91, 76),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 215),
            const Text(
              'Enter your email to recieve the reset password link',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 25),

            // email textfield
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 25),
            MyButton(onTap: passwordReset, title: 'Reset Password'),
          ]),
        ));
  }
}
