import 'dart:convert';

import 'package:dio/dio.dart';

String measureNetworkData(dynamic data) {
  int requestSizeInBytes = 0;
  if (data != null) {
    if (data is String) {
      requestSizeInBytes = (data).length;
    } else if (data is Map) {
      final encodedData = json.encode(data);
      requestSizeInBytes = utf8.encode(encodedData).length;
    } else if (data is FormData) {
      requestSizeInBytes = (data).length;
    }
  }
  return requestSizeInBytes.toString();
}

String delayInMs( String? dateTimeString1, String? dateTimeString2){

  if(dateTimeString1 == null || dateTimeString1.isEmpty) {
    return '--';
  }
  if(dateTimeString2 == null || dateTimeString2.isEmpty) {
    return '--';
  }

  List<String> parts1 = dateTimeString1.split(' ');
  List<String> dateParts1 = parts1[0].split('-');
  List<String> timeParts1 = parts1[1].split(':');

  List<String> parts2 = dateTimeString2.split(' ');
  List<String> dateParts2 = parts2[0].split('-');
  List<String> timeParts2 = parts2[1].split(':');

  DateTime dateTime1 = DateTime(
    int.parse(dateParts1[0]),
    int.parse(dateParts1[1]),
    int.parse(dateParts1[2]),
    int.parse(timeParts1[0]),
    int.parse(timeParts1[1]),
    int.parse(timeParts1[2]),
  );

  DateTime dateTime2 = DateTime(
    int.parse(dateParts2[0]),
    int.parse(dateParts2[1]),
    int.parse(dateParts2[2]),
    int.parse(timeParts2[0]),
    int.parse(timeParts2[1]),
    int.parse(timeParts2[2]),
  );

  int delayInMilliseconds = dateTime2.difference(dateTime1).inMilliseconds;

  return delayInMilliseconds.toString();

}