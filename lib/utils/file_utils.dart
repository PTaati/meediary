// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<String> saveFileInApp(XFile xFile) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final filePath = p.join(docsDir.path, xFile.name);
  final originalFile = File(xFile.path);
  await originalFile.copy(filePath);
  
  return filePath;
}