

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

```yaml dependencies:    
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

## :zap:Push notification (Optional)
This is an optional feature. If you want to get local push notification when the network request is triggered or any response comes from the server.
| ![Screenshot 1](https://github.com/pritomzap/dio_http_logger/blob/main/images/Screenshot_2024-08-18-23-54-45-75_145357e94e80f64316ba470e85655fde.jpg?raw=true)  | ![Screenshot 1](https://github.com/pritomzap/dio_http_logger/blob/main/images/Screenshot_2024-08-18-23-54-59-40_145357e94e80f64316ba470e85655fde.jpg?raw=true) |
|---|---|

1. Initialize the notification.
```dart
void main() async{  
   ....
  WidgetsFlutterBinding.ensureInitialized();;  
  await DioNetworkLogger.instance.initLocalNotifications();  
  runApp(  
      ..... 
  );  
}
```
2. For ios configure your __AppDelegate__
```swift
//other imports
import flutter_local_notifications
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
    GeneratedPluginRegistrant.register(with: registry)}
    GeneratedPluginRegistrant.register(with: self)
	if #available(iOS 10.0, *) {
       UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    return super.application(application,didFinishLaunchingWithOptions:launchOptions)
  }
}
```
**_NOTE:_**  Used the __flutter_local_notifications: ^17.2.2__ plugin. If you find any issues, try to follow the documentation of flutter_local_notifications and dont forget to throw an issue in github.