import 'package:dio/dio.dart' as dio;
import 'package:dio_http_logger/models/network_model.dart';
import 'package:dio_http_logger/screen/network_requests_list.dart';
import 'package:dio_http_logger/utils/dio_network_interceptor.dart';
import 'package:dio_http_logger/utils/utils.dart';
import 'package:dio_http_logger/widgets/overlay_button.dart';
import 'package:flutter/material.dart';

class DioNetworkLogger {

  DioNetworkInterceptor? _dioNetworkInterceptor;

  DioNetworkLogger._privateConstructor(){
    _dioNetworkInterceptor = DioNetworkInterceptor((networks)=>_addNetworkRequests(networks),(response)=>_onNetworkResponse(response),(error)=>_onNetworkError(error));
  }
  static final DioNetworkLogger _instance = DioNetworkLogger._privateConstructor();
  static DioNetworkLogger get instance => _instance;
  static List<NetworkModel> _networkModels = [];
  Function? listenerEventChange;

  BuildContext? _context;
  BuildContext? get context => _context;
  set context(BuildContext? value) {
    _context = value;
  }

  void startNetworkLoggerScreen(){
    Navigator.of(context!).push(MaterialPageRoute(builder: (_) => const NetworkRequestsList()));
  }

  List<NetworkModel> get networkModels => _networkModels;

  static int? _findNetworkModelWithTimeStamp(String timeStamp, String path){
    return _networkModels.indexWhere((model){
      return model.requestTime == timeStamp && model.path == path?true:false;
    });
  }

  void _addNetworkRequests(NetworkModel model){
    _networkModels.insert(0, model);
    listenerEventChange?.call();
  }

  void _onNetworkResponse(dio.Response response){
    final requestTimestamp = response.requestOptions.extra['requestTimestamp'];
    var networkRequestIndex = _findNetworkModelWithTimeStamp(requestTimestamp,"${response.requestOptions.baseUrl}${response.requestOptions.path}");
    if(networkRequestIndex != null){
      var networkRequest = _networkModels.removeAt(networkRequestIndex);
      networkRequest.code = response.statusCode;
      networkRequest.responseHeaders = response.headers.map;
      networkRequest.responseBody = response.data.toString();
      networkRequest.responseSize = measureNetworkData(response.data.toString());
      networkRequest.response = response;
      _networkModels.insert(0, networkRequest);
      listenerEventChange?.call();
    }
  }
  void _onNetworkError(dio.DioException error){
    final requestTimestamp = error.requestOptions.extra['requestTimestamp'];
    var networkRequestIndex = _findNetworkModelWithTimeStamp(requestTimestamp,"${error.requestOptions.baseUrl}${error.requestOptions.path}");
    if(networkRequestIndex != null){
      var networkRequest = _networkModels.removeAt(networkRequestIndex);
      networkRequest.code = -87;
      networkRequest.exception = error;
      _networkModels.insert(0, networkRequest);
      listenerEventChange?.call();
    }
  }


  DioNetworkInterceptor? get dioNetworkInterceptor => _dioNetworkInterceptor;

  final Widget _overLayButtonWidget = const OverlayButton();
  Widget get overLayButtonWidget => _overLayButtonWidget;

  void deleteAllRequests(){
    _networkModels.clear();
    listenerEventChange?.call();
  }
}
