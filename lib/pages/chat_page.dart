import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:meediary/constants/globals.dart';
import 'package:meediary/data_models/chat_message.dart';
import 'package:meediary/services/chat_service.dart';
import 'package:meediary/utils/date_time_utils.dart';
import 'package:meediary/widgets/message_card.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textEditingController = TextEditingController();
  late StreamSubscription _keyboardSubscription;
  DateTime? selectSendTime;
  String? displaySendTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      },
    );

    final keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      });
    });
  }

  @override
  void dispose() {
    _keyboardSubscription.cancel();
    super.dispose();
  }

  Widget _buildChatHistory(List<ChatMessage> messages) {
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(
        color: Colors.black26,
        child: ListView(
          controller: chatScrollController,
          children: messages
              .where(
                (message) => message.timeToSend.isBefore(now),
              )
              .map((message) => MessageCard(
                    message: message,
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSendSection() {
    return Row(
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
              fillColor: Colors.white24,
              filled: true,
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
            final timeToSend = selectSendTime ?? DateTime.now();
            final messageObject = ChatMessage(
              _textEditingController.text,
              DateTime.now(),
              timeToSend,
            );

            chatService.send(messageObject);

            setState(() {
              _textEditingController.text = '';
              selectSendTime = null;
            });

            FocusManager.instance.primaryFocus?.unfocus();

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
          ),
        )
      ],
    );
  }

  Widget _buildTimeSelectedWidget() {
    if (selectSendTime != null) {
      displaySendTime = displayDateTimeFormat(selectSendTime!);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 40,
        ),
        TextButton(
          onPressed: () {
            DatePicker.showDateTimePicker(
              context,
              showTitleActions: true,
              minTime: DateTime.now(),
              maxTime: DateTime(2222, 12, 31),
              onChanged: (date) {},
              onConfirm: (date) {
                setState(() {
                  selectSendTime = date;
                });
              },
              currentTime: DateTime.now(),
            );
          },
          child: selectSendTime != null
              ? Text(
                  '$displaySendTime',
                  style: const TextStyle(color: Colors.grey),
                )
              : const Text(
                  'เลือกเวลาเพื่อส่งหาคุณในอนาคต',
                  style: TextStyle(color: Colors.grey),
                ),
        ),
        selectSendTime != null
            ? IconButton(
                onPressed: () {
                  setState(() {
                    selectSendTime = null;
                  });
                },
                icon: const Icon(
                  Icons.cancel_schedule_send,
                  color: Colors.white54,
                ),
              )
            : const SizedBox(
                width: 40,
              ),
      ],
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
            const Divider(color: Colors.white24),
            _buildTimeSelectedWidget(),
            _buildSendSection(),
          ],
        ),
      ),
    );
  }
}
