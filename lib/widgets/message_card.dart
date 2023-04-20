import 'package:flutter/material.dart';
import 'package:meediary/data_models/chat_message.dart';
import 'package:meediary/utils/date_time_utils.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    required this.message,
    Key? key,
  }) : super(key: key);

  final ChatMessage message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    final createdTimeFormat = displayDateTimeFormat(
      widget.message.timeToSend,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              widget.message.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            createdTimeFormat,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 10.0,
            ),
          ),
        )
      ],
    );
  }
}
