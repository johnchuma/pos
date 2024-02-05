import 'package:intl/intl.dart';

String formatDate(DateTime date){
  return  DateFormat("dd MMM yyy").format(date);
}

String formatMonthYear(DateTime date){
  return  DateFormat("MMM yyy").format(date);
}
String formatDateHumans(DateTime date){
  return  DateFormat("EEEE, dd MMM yyy").format(date);
}

String getDateTime(DateTime date){
  return  DateFormat("hh:mm a").format(date);
}