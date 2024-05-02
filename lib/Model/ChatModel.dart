class ChatModel {
  String? name;
  String? icon;
  bool? isGroup;
  String? time;
  String? currentMessage;
  String? status;
  bool? select = false;
  String? id;
  ChatModel({
    this.name,
    this.icon,
    this.isGroup,
    this.time,
    this.currentMessage,
    this.status,
    this.select = false,
    this.id,
  });
}
  //select variable is for creating new group that gree tick mark
  // status is for when the contacts are dislayed thier name and the status that is bio is also dipslayed together so thats why its like this....