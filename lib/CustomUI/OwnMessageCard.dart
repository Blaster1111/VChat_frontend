import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({super.key, this.message, this.time});
  final String? message;
  final String? time;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          color: Color.fromARGB(255, 35, 196, 89),
          child: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 30, top: 5, bottom: 20),
                  child: Text(
                    message!,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
              Positioned(
                bottom: 4,
                right: 60,
                child: Row(
                  children: [
                    Text(
                      "9:00 AM",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.done_all,
                      size: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
