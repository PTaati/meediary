import 'package:flutter/cupertino.dart';
import 'package:meediary/data_models/chat_message.dart';
import 'package:objectbox/objectbox.dart';

class ChatService with ChangeNotifier {
  ChatService(this.chatMessageBox, this.messages);

  Box<ChatMessage> chatMessageBox;
  List<ChatMessage> messages = [];

  void send(ChatMessage message) {
    chatMessageBox.put(message);
    messages.add(message);

    messages.sort((a, b) {
      return a.timeToSend.compareTo(b.timeToSend);
    });
    notifyListeners();
  }

  void deleteMessage(ChatMessage message) {
    chatMessageBox.remove(message.id);

    final chatMessageList = chatMessageBox.getAll();

    chatMessageList.sort((a,b) {
      return a.timeToSend.compareTo(b.timeToSend);
    });

    messages = chatMessageList;
    notifyListeners();
  }
}
