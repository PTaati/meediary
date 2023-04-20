import 'package:intl/intl.dart';

String displayDateTimeFormat(DateTime datetime) =>
    DateFormat('EEEE, MMM d, yyyy, HH:mm:ss', 'th').format(
      datetime,
    );
