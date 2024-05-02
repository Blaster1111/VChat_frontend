import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wclone/Model/ChatModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:wclone/CustomUI/CustomCard.dart';
import 'package:wclone/Screens/SelectContact.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.chatmodels, this.sourcechat});
  final List<ChatModel>? chatmodels;
  final ChatModel? sourcechat;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

List<ChatModel> parseUsersResponse(dynamic jsonResponse) {
  List<ChatModel> users = [];
  for (var user in jsonResponse) {
    users.add(ChatModel(
      name: user['fullName'],
      icon: user['profilePic'],
      isGroup: false,
      time: '',
      currentMessage: user['username'],
      id: user['_id'],
    ));
  }
  return users;
}

class _ChatPageState extends State<ChatPage> {
  List<ChatModel> users = [];
  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future<void> getUsers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');
      if (authToken != null) {
        final url = Uri.parse('https://vchat-bpx8.onrender.com/users/');
        final response = await http.get(
          url,
          headers: {'Authorization': '$authToken'},
        );

        if (response.statusCode == 200) {
          setState(() {
            users = parseUsersResponse(json.decode(response.body));
          });
        } else {
          // Handle other status codes if needed
          print('Failed to get users. Status code: ${response.statusCode}');
        }
      } else {
        print('No authToken found in shared preferences.');
      }
    } catch (error) {
      print('Error getting users: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => SelectContact()));
        },
        child: Icon(Icons.chat),
      ),
      // ignore: unnecessary_null_comparison
      body: users != null
          ? ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) => CustomCard(
                chatModel: users[index],
                sourcechat: widget.sourcechat,
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.black54,
              ),
            ),
    );
  }
}
