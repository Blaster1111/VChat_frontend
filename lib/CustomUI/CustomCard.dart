import 'package:flutter/material.dart';

import 'package:wclone/Model/ChatModel.dart';
import 'package:wclone/Screens/IndividualPage.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.chatModel, this.sourcechat})
      : super(key: key);
  final ChatModel chatModel;
  final ChatModel? sourcechat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndividualPage(
              chatModel: chatModel,
              sourcechat: sourcechat,
            ),
          ),
        );
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              // Display user profile picture
              backgroundImage: NetworkImage(chatModel.icon ?? ''),
              radius: 30,
            ),
            title: Text(
              chatModel.name ?? '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(Icons.done_all),
                Text(
                  chatModel.currentMessage ?? '',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                )
              ],
            ),
            trailing: Text(chatModel.time ?? ''),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
          ),
          Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }
}
