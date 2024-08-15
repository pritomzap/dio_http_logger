
# dio_http_logger

[![Pub Version](https://img.shields.io/pub/v/dio_http_logger.svg)](https://pub.dev/packages/dio_network_logger)


A powerful network interceptor for Dio, providing comprehensive logging of requests, responses and errors.

## :zap: Screenshots
| ![Screenshot 1](https://github.com/pritomzap/dio_http_logger/blob/main/images/1000000132.png?raw=true)  | ![Screenshot 1](https://github.com/pritomzap/dio_http_logger/blob/main/images/1000000133.png?raw=true)  | ![Screenshot 1](https://github.com/pritomzap/dio_http_logger/blob/main/images/1000000134.png?raw=true)  | ![Screenshot 1](https://github.com/pritomzap/dio_http_logger/blob/main/images/1000000135.png?raw=true) |![Screenshot 1](https://github.com/pritomzap/dio_http_logger/blob/main/images/1000000136.png?raw=true)
|---|---|---|---|---|

## :zap:Features

* **Detailed Logging**: Log request method, URL, headers, query parameters, request body, response status code, headers, request time, response time, request data size, response data size and response body.
* **Error stack-trace**: Stack trace data directly from Dio in error requests.
* **Easy Integration**: Add the interceptor to your Dio instance with just a few lines of code.

## :zap:Installation

Add `dio_http_logger` to your `pubspec.yaml` file:

```yaml  
dependencies:  
 dio: ">=4.0.0 <6.0.0" //use the latest version, 5.6.0 was my latest, old version user DioError instead of DioException.
 .....
 dio_http_logger: ^latest_version
```
## :zap:Getting Started
1. Add `DioNetworkLogger.instance.dioNetworkInterceptor` to your dio object/instances.
```dart
final client = Dio();  
client.interceptors.add(DioNetworkLogger.instance.dioNetworkInterceptor!);
```
3. Set the context for internal navigation on application start or naigation start.
```dart
DioNetworkLogger.instance.context = context;
```
4. Use `DioNetworkLogger.instance.overLayButtonWidget` widget to direct navigate to the library (Use it at the root view of your application, this will make the button appear in every screen).
```dart
runApp(  
    MaterialApp(  
      home: Stack(  
        children: [  
          const MyApp(),  
          DioNetworkLogger.instance.overLayButtonWidget
       ],  
      ),  
    )  
);
```
5. Or you can use `DioNetworkLogger.instance.startNetworkLoggerScreen()` to direct navigate to the library
```dart
//Use it on any callback
onPressed: () {
  DioNetworkLogger.instance.context = context;
  DioNetworkLogger.instance.startNetworkLoggerScreen();  
},
```