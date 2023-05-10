extension MyDateExtension on DateTime {
  String getDateOnlyAsString(){
    return "$day/$month/$year";
  }
}

String getCurrentDate() {
  DateTime now = DateTime.now();
  return now.getDateOnlyAsString();
}
