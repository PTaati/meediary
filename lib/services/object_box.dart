// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:meediary/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, "local-database-object-box"),
    );
    return ObjectBox._create(store);
  }

  static Future<void> delete() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final database = File(p.join(docsDir.path, "local-database-object-box"));

    if (database.existsSync()) {
      await database.delete(recursive: true);
    }
  }
}
