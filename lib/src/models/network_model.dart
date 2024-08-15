import 'package:dio/dio.dart' as dio;

class NetworkModel{
  String? _requestType;
  String? _path;
  int? _code;
  String? _requestTime;
  String? _responseTime;
  String? _duration;
  Map<String,dynamic>? _requestHeaders;
  Map<String,dynamic>? _requestBody;
  Map<String,dynamic>? _queryParams;
  Map<String,dynamic>? _responseHeaders;
  String? _responseBody;
  String? _requestSize;
  String? _responseSize;
  dio.RequestOptions? _requestOptions;
  dio.Response? _response;
  dio.DioException? _exception;


  String? get path => _path;

  set path(String? value) {
    _path = value;
  }

  int? get code => _code;

  set code(int? value) {
    _code = value;
  }

  Map<String, dynamic>? get requestBody => _requestBody;

  set requestBody(Map<String, dynamic>? value) {
    _requestBody = value;
  }

  Map<String, dynamic>? get requestHeaders => _requestHeaders;

  set requestHeaders(Map<String, dynamic>? value) {
    _requestHeaders = value;
  }

  String? get duration => _duration;

  set duration(String? value) {
    _duration = value;
  }

  String? get responseTime => _responseTime;

  set responseTime(String? value) {
    _responseTime = value;
  }

  String? get requestTime => _requestTime;

  set requestTime(String? value) {
    _requestTime = value;
  }

  Map<String, dynamic>? get queryParams => _queryParams;

  set queryParams(Map<String, dynamic>? value) {
    _queryParams = value;
  }

  String? get requestType => _requestType;

  set requestType(String? value) {
    _requestType = value;
  }

  String? get responseBody => _responseBody;

  set responseBody(String? value) {
    _responseBody = value;
  }

  Map<String, dynamic>? get responseHeaders => _responseHeaders;

  set responseHeaders(Map<String, dynamic>? value) {
    _responseHeaders = value;
  }

  String? get responseSize => _responseSize;

  set responseSize(String? value) {
    _responseSize = value;
  }

  String? get requestSize => _requestSize;

  set requestSize(String? value) {
    _requestSize = value;
  }

  dio.DioException? get exception => _exception;

  set exception(dio.DioException? value) {
    _exception = value;
  }

  dio.Response? get response => _response;

  set response(dio.Response? value) {
    _response = value;
  }

  dio.RequestOptions? get requestOptions => _requestOptions;

  set requestOptions(dio.RequestOptions? value) {
    _requestOptions = value;
  }
}