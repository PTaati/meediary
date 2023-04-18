import 'package:objectbox/objectbox.dart';

@Entity()
class Post {
  Post({
    required this.title,
    required this.description,
    required this.created,
    this.comments = const [],
    this.isLike = false,
    this.imagePath,
  });

  @Id()
  int id = 0;

  String title;
  String description;
  List<String> comments;
  bool isLike;
  String? imagePath;
  DateTime created;
}
