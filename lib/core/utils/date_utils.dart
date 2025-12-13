//
// import 'package:intl/intl.dart';
//  String dateFormatted (DateTime date){
//      final DateFormat formatter = DateFormat.yMd();
//      return formatter.format(date);
//    }

extension FormatDate on DateTime {
  String get toFormattedDate=> '$day - $month - $year';
  String get getDay{
    List<String> weekDays = ['SAT', 'SUN' , 'MON', 'TUE', 'WED', 'THU', 'FRI' ];
    DateTime date = DateTime.now();
    return weekDays[weekday - 1];
  }


}