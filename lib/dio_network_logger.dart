import 'package:dio/dio.dart' as dio; // Import Dio HTTP client
// Import other necessary components from the package
import 'package:dio_http_logger/models/network_model.dart';
import 'package:dio_http_logger/screen/network_requests_list.dart';
import 'package:dio_http_logger/utils/dio_network_interceptor.dart';
import 'package:dio_http_logger/utils/utils.dart';
import 'package:dio_http_logger/widgets/overlay_button.dart';
import 'package:flutter/material.dart';

/*
*
* Explanation

The DioNetworkLogger class acts as a singleton, providing a single point of access for logging and managing network requests.
It uses a DioNetworkInterceptor to intercept Dio requests and responses, allowing it to capture and store details about each network operation.
The _networkModels list holds NetworkModel objects, representing individual network requests and their associated data (request/response headers, body, status code, etc.).
The listenerEventChange callback enables other parts of the application to be notified when the list of network requests changes.
The startNetworkLoggerScreen method navigates to a screen where the logged network requests can be viewed.
The deleteAllRequests method clears all logged requests.

Key Points

This code demonstrates how to integrate network logging into a Flutter application using Dio.
The singleton pattern ensures that there's only one instance of the logger, making it easy to access from anywhere in the app.
The use of a DioNetworkInterceptor allows for seamless interception and logging of network requests and responses.
The NetworkModel class provides a structured way to store and manage details about each network operation.
The listenerEventChange callback enables real-time updates to UI components that display the logged network requests.
Remember to add appropriate comments within the _onNetworkResponse and _onNetworkError methods to explain their specific logic for updating the network models.
*
* */

class DioNetworkLogger {
  // Private constructor to enforce singleton pattern
  DioNetworkInterceptor? _dioNetworkInterceptor;

  DioNetworkLogger._privateConstructor(){
    // Initialize the DioNetworkInterceptor with callbacks for handling network events
    _dioNetworkInterceptor = DioNetworkInterceptor((networks)=>_addNetworkRequests(networks),(response)=>_onNetworkResponse(response),(error)=>_onNetworkError(error));
  }
  // Singleton instance of the logger
  static final DioNetworkLogger _instance = DioNetworkLogger._privateConstructor();
  static DioNetworkLogger get instance => _instance;

  // List to store network request models
  static List<NetworkModel> _networkModels = [];

  // Callback function to notify listeners about changes in network requests
  Function? listenerEventChange;

  BuildContext? _context;
  BuildContext? get context => _context;
  set context(BuildContext? value) {
    _context = value;
  }

  // Navigate to the network logger screen
  void startNetworkLoggerScreen(){
    Navigator.of(context!).push(MaterialPageRoute(builder: (_) => const NetworkRequestsList()));
  }

  // Getter for networkModels
  List<NetworkModel> get networkModels => _networkModels;

  // Find a network model based on timestamp and path
  static int? _findNetworkModelWithTimeStamp(String timeStamp, String path){
    return _networkModels.indexWhere((model){
      return model.requestTime == timeStamp && model.path == path?true:false;
    });
  }

  // Add a new network request to the list
  void _addNetworkRequests(NetworkModel model){
    _networkModels.insert(0, model);
    listenerEventChange?.call();
  }

  // Handle successful network responses
  void _onNetworkResponse(dio.Response response){
    final requestTimestamp = response.requestOptions.extra['requestTimestamp'];
    var networkRequestIndex = _findNetworkModelWithTimeStamp(requestTimestamp,"${response.requestOptions.baseUrl}${response.requestOptions.path}");
    if(networkRequestIndex != null){
      var networkRequest = _networkModels.removeAt(networkRequestIndex);
      networkRequest.code = response.statusCode;
      networkRequest.responseHeaders = response.headers.map;
      networkRequest.responseBody = response.data.toString();
      networkRequest.responseSize = measureNetworkData(response.data.toString());
      networkRequest.responseTime = DateTime.now().millisecondsSinceEpoch.toString();
      networkRequest.response = response;
      _networkModels.insert(0, networkRequest);
      listenerEventChange?.call();
    }
  }

  // Handle network errors
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


  // Getter for dioNetworkInterceptor
  DioNetworkInterceptor? get dioNetworkInterceptor => _dioNetworkInterceptor;

  // Overlay button widget
  final Widget _overLayButtonWidget = const OverlayButton();
  Widget get overLayButtonWidget => _overLayButtonWidget;

  // Delete all logged requests
  void deleteAllRequests(){
    _networkModels.clear();
    listenerEventChange?.call();
  }
}
