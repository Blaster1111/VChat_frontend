import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wclone/CustomUI/OwnMessageCard.dart';
import 'package:wclone/CustomUI/ReplyCard.dart';
import 'package:wclone/Model/ChatModel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:wclone/Model/MessageModel.dart';

class IndividualPage extends StatefulWidget {
  const IndividualPage({super.key, required this.chatModel, this.sourcechat});
  final ChatModel chatModel;
  final ChatModel? sourcechat;
  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();
  IO.Socket? socket;
  bool sendButton = false;
  List<MessageModel> messages = [];
  ScrollController _scrollController = ScrollController();
  String? sourceId;

  @override
  initState() {
    super.initState();
    getSourceId();
    if (socket == null || !socket!.connected) {
      connectWebSocket();
    }
    getMessages();
    // connect();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

  @override
  void dispose() {
    socket!.disconnect();
    super.dispose();
  }

  void getSourceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sourceId = prefs.getString('senderId');
  }

  void connectWebSocket() async {
    final url = 'https://vchat-bpx8.onrender.com';

    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.on('connect', (_) {
      print('Connected to WebSocket');
      if (sourceId != null) {
        final roomIds = [
          '${sourceId}-${widget.chatModel.id}',
          '${widget.chatModel.id}-${sourceId}'
        ];
        socket!.emit('joinRoom', roomIds.join(','));
      }
    });

    socket!.on('newMessage', (data) {
      if (mounted) {
        // Check if the widget is mounted
        print('New message received: $data');
        setState(() {
          MessageModel newMessage = MessageModel.fromJson(data);
          messages.add(newMessage);
        });
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    socket!.connect();
  }

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

  void sendMessage(String message) {
    if (sourceId != null) {
      socket!.emit('message', {
        'message': message,
        'receiverId': widget.chatModel.id,
        'senderId': sourceId,
      });
      sendMessageServer(widget.chatModel.id!, message);
    } else {
      print('No sourceId found in shared preferences.');
    }
  }

  void getMessages() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      if (authToken != null) {
        final url = Uri.parse(
            'https://vchat-bpx8.onrender.com/messages/${widget.chatModel.id}');
        final response = await http.get(
          url,
          headers: {
            'Authorization': '$authToken',
          },
        );

        if (response.statusCode == 200) {
          List<MessageModel> receivedMessages =
              parseMessagesResponse(json.decode(response.body));
          setState(() {
            messages = receivedMessages;
          });
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          print('Failed to get messages. Status code: ${response.statusCode}');
        }
      } else {
        print('No authToken or sourceId found in shared preferences.');
      }
    } catch (error) {
      print('Error getting messages: $error');
    }
  }

  List<MessageModel> parseMessagesResponse(dynamic jsonResponse) {
    List<MessageModel> messages = [];
    for (var message in jsonResponse) {
      messages.add(MessageModel.fromJson(message));
    }
    return messages;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Color.fromARGB(136, 7, 5, 63),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              titleSpacing: 0.0,
              leadingWidth: 70,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    CircleAvatar(
                      child: SvgPicture.asset(
                        widget.chatModel.isGroup ?? false
                            ? "assets/groups.svg"
                            : "assets/person.svg",
                        color: Colors.white,
                        height: 36,
                        width: 36,
                      ),
                      radius: 20,
                      backgroundColor: Colors.blueGrey,
                    ),
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chatModel.name ?? '',
                        style: TextStyle(
                            fontSize: 18.5, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Last Seen Today 00:22",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.videocam)),
                IconButton(onPressed: () {}, icon: Icon(Icons.call)),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    print(value);
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: Text("View Contact"),
                        value: "View Contact",
                      ),
                      PopupMenuItem(
                        child: Text("Media"),
                        value: "Media",
                      ),
                      PopupMenuItem(
                        child: Text("Whatsapp Web"),
                        value: "Whatsapp Web",
                      ),
                      PopupMenuItem(
                        child: Text("Search"),
                        value: "Search",
                      ),
                      PopupMenuItem(
                        child: Text("Mute Notifications"),
                        value: "Mute Notifications",
                      ),
                      PopupMenuItem(
                        child: Text("Wallpaper"),
                        value: "Wallpaper",
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          body: Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: WillPopScope(
              child: Column(
                children: [
                  Expanded(
                    // height: MediaQuery.sizeOf(context).height - 140,
                    child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: messages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == messages.length) {
                          return Container(
                            height: 70,
                          );
                        }
                        if (widget.chatModel.id == messages[index].receiverId) {
                          return OwnMessageCard(
                            message: messages[index].message,
                            // time: messages[index].time,
                          );
                        } else {
                          return ReplyCard(
                            message: messages[index].message,
                            // time: messages[index].time,
                          );
                        }
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width - 60,
                                child: Card(
                                  margin: EdgeInsets.only(
                                      left: 2, right: 2, bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: TextFormField(
                                    controller: _controller,
                                    focusNode: focusNode,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,
                                    onChanged: (value) {
                                      if (value.length > 0) {
                                        setState(() {
                                          sendButton = true;
                                        });
                                      } else {
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Type a message",
                                      prefixIcon: IconButton(
                                        icon: Icon(
                                          Icons.emoji_emotions,
                                        ),
                                        onPressed: () {
                                          focusNode.unfocus();
                                          focusNode.canRequestFocus = false;
                                          setState(() {
                                            show = !show;
                                          });
                                        },
                                      ),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (builder) =>
                                                      bottomSheet());
                                            },
                                            icon: Icon(Icons.attach_file),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.camera_alt),
                                          ),
                                        ],
                                      ),
                                      contentPadding: EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  right: 5,
                                  left: 2,
                                ),
                                child: CircleAvatar(
                                  radius: 25,
                                  child: IconButton(
                                    icon: Icon(
                                      sendButton ? Icons.send : Icons.mic,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      if (sendButton == true) {
                                        _scrollController.animateTo(
                                            _scrollController
                                                .position.maxScrollExtent,
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeOut);
                                        // sendMessage(
                                        //   _controller.text,
                                        //   widget.chatModel.id,
                                        //   widget.chatModel.id,
                                        // );
                                        sendMessage(_controller.text);
                                        _controller.clear();
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          show ? emojiSelect() : Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              onWillPop: () {
                if (show) {
                  setState(() {
                    show = false;
                  });
                } else {
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.sizeOf(context).width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreating(Icons.insert_drive_file_outlined, Colors.indigo,
                      "Document"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreating(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreating(Icons.insert_photo, Colors.purple, "Gallery"),
                  SizedBox(
                    width: 40,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreating(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreating(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreating(Icons.person, Colors.blue, "Contact"),
                  SizedBox(
                    width: 40,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreating(IconData icon, Color color, String text) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: IconButton(
            icon: Icon(
              icon,
              size: 29,
              color: Colors.white,
            ),
            onPressed:
                null, // Set onPressed to null to avoid passing null semanticsAction
            tooltip: text, // Provide a semantic label for accessibility
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget emojiSelect() {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return EmojiPicker(
          onEmojiSelected: (emoji, category) {
            setState(() {
              _controller.text = _controller.text + category.emoji;
            });
          },
        );
      },
    );
  }
}
