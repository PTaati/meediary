import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  @Id()
  int id = 0;

  String? name;
}
