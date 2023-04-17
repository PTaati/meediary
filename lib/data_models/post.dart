import 'package:objectbox/objectbox.dart';

@Entity()
class Post {
  Post({
    required this.title,
    required this.description,
    required this.created,
  });

  @Id()
  int id = 0;

  String title;
  String description;
  DateTime created;
}
