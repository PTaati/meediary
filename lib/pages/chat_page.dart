import 'package:flutter/material.dart';
import 'package:meediary/constants/globals.dart';
import 'package:meediary/data_models/chat_message.dart';
import 'package:meediary/services/chat_service.dart';
import 'package:meediary/widgets/message_card.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textEditingController = TextEditingController();

  Widget _buildChatHistory(List<ChatMessage> messages) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(
        color: Colors.black26,
        child: ListView(
          controller: chatScrollController,
          children: messages
              .map((message) => MessageCard(
                    message: message,
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSendSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _textEditingController,
              cursorColor: Colors.white54,
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: 'พิมพ์ช้อความ...',
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          IconButton(
              onPressed: () {
                if (_textEditingController.text.isEmpty) {
                  chatScrollController.animateTo(
                    chatScrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
                  return;
                }

                final chatService = Provider.of<ChatService>(
                  context,
                  listen: false,
                );
                final timeToSend = DateTime.now();
                final messageObject = ChatMessage(
                  _textEditingController.text,
                  DateTime.now(),
                  timeToSend,
                );

                chatService.send(messageObject);

                setState(() {
                  _textEditingController.text = '';
                });

                chatScrollController.animateTo(
                  chatScrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                );
              },
              icon: Icon(
                _textEditingController.text.isNotEmpty
                    ? Icons.send
                    : Icons.keyboard_double_arrow_down,
                color: Colors.white,
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(child: _buildChatHistory(chatService.messages)),
            const Divider(color: Colors.white),
            _buildSendSection(),
          ],
        ),
      ),
    );
  }
}
