import 'package:flutter/material.dart';
import 'package:meediary/data_models/chat_message.dart';
import 'package:meediary/services/chat_service.dart';
import 'package:meediary/utils/date_time_utils.dart';
import 'package:provider/provider.dart';

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
      crossAxisAlignment: widget.message.isSchedule
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        if (widget.message.isSchedule)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '($createdTimeFormat) คุณในอดีตบอกว่า',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
        GestureDetector(
          onLongPress: () async {
            await showDialog<void>(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: const Text('ต้องการลบข้อความใช่หรือไม่'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        'ลบ',
                        style: TextStyle(color: Colors.white54),
                      ),
                      onPressed: () {
                        final chatService = Provider.of<ChatService>(
                          context,
                          listen: false,
                        );
                        chatService.deleteMessage(widget.message);
                        Navigator.of(dialogContext)
                            .pop(); // Dismiss alert dialog
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'ไม่ลบ',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext)
                            .pop(); // Dismiss alert dialog
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Card(
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
        ),
        if (!widget.message.isSchedule)
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
