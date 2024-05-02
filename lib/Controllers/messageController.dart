import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MessageController {
  Future<void> sendMessageServer(String receiverId, String message) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      if (authToken != null) {
        final url = Uri.parse(
            'https://vchat-bpx8.onrender.com/messages/send/$receiverId');
        final response = await http.post(
          url,
          headers: {
            'Authorization': '$authToken',
            'Content-Type': 'application/json'
          },
          body: json.encode({'message': message}), // Convert to JSON string
        );

        if (response.statusCode == 201) {
          print('Message sent successfully.');
        } else {
          print('Failed to send message. Status code: ${response.statusCode}');
        }
      } else {
        print('No authToken found in shared preferences.');
      }
    } catch (error) {
      print('Error sending message: $error');
    }
  }
}
