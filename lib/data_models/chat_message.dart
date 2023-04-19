import 'package:objectbox/objectbox.dart';

@Entity()
class ChatMessage{
  ChatMessage(this.message, this.created, this.timeToSend);

  @Id()
  int id = 0;

  String message;
  DateTime created;
  DateTime timeToSend;
}
