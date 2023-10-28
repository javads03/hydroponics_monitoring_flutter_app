import "package:flutter/material.dart";

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;
  const MyListTile({super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color.fromARGB(255, 64, 91, 76),
      ),
      onTap: onTap,
      title: Text(text),
    );
  }
}
