import 'package:flutter/cupertino.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class User with ChangeNotifier{
  @Id()
  int id = 0;

  String? name;
  String? avatarPath;
  DateTime? dateOfBirth;
  String? note;
}
