class MessageModel {
  final String? id;
  final String? message;
  final String? receiverId; // Add receiverId field
  final String? time;

  MessageModel({
    this.id,
    required this.message,
    this.receiverId, // Update constructor to include receiverId
    this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      message: json['message'],
      receiverId: json['receiverId'], // Parse receiverId from JSON
    );
  }
}
