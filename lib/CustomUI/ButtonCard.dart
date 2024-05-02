import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wclone/Model/ChatModel.dart';

class ButtonCard extends StatelessWidget {
  const ButtonCard({Key? key, this.name, this.icon, this.contact})
      : super(key: key);
  final ChatModel? contact;
  final String? name;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        child: Icon(
          icon,
          size: 26,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 40, 199, 45),
      ),
      title: Text(
        name ?? '',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
