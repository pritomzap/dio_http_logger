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

  try {
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
  }  catch (e) {
    return "- -";
  }

}

String milisToDateTime(int millisecondsSinceEpoch){
  if(millisecondsSinceEpoch == 0) {
    return '--';
  }
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  // Basic formatting using DateTime properties
  String year = dateTime.year.toString();
  String month = dateTime.month.toString().padLeft(2, '0'); // Ensure two digits
  String day = dateTime.day.toString().padLeft(2, '0');
  String hour = dateTime.hour.toString().padLeft(2, '0');
  String minute = dateTime.minute.toString().padLeft(2, '0');
  String second = dateTime.second.toString().padLeft(2, '0');

  String formattedDateTime = '$year-$month-$day $hour:$minute:$second';
  return formattedDateTime;
}

String covertToQuotedJson(String jsonDump){
  String invalidJson = "{title: New Post, body: This is the body of the new post., userId: 1, id: 101}";

  // Pattern to match keys and string values without quotes
  RegExp pattern = RegExp(r"(\w+)\s*:\s*([^,{}]+)");

  // Replace matches with quoted keys and values
  String correctedJson = invalidJson.replaceAllMapped(pattern, (match) {
    return '"${match.group(1)}": "${match.group(2)}"';
  });
  return correctedJson;
}