
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dio_http_logger/dio_logger.dart';

void main() async{
  runApp(
      MaterialApp(
        home: Stack(
          children: [
            MyApp(),
            DioNetworkLogger.instance.overLayButtonWidget
          ],
        ),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DioNetworkLogger.instance.context = context;
    final client = Dio();
    client.interceptors.add(DioNetworkLogger.instance.dioNetworkInterceptor!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio app example'),
      ),
      body: Center(
        child: InkWell(
            onTap: ()async{
              try{
                await client.get('https://flutter.dev/');
                await client.get('https://github.com/flutter/flutter/issues/111656');
                await client.get('https://facebook.com/');
                await client.get('https://google.com/');
                client.get('https://newroz.com/');
                client.get('https://asooasd.com/');
                client.post(
                  'https://run.mocky.io/v3/c80877c3-8d4a-477b-9c45-a1441c34a6b6',
                  data: <String, dynamic>{
                    'products': 5,
                    'foo': 'bar',
                    'hello': [
                      'world',
                      'dunya',
                    ]
                  },
                );
                //DioNetworkLogger.instance.startNetworkLoggerScreen();
              }catch(e){
                //DioNetworkLogger.instance.startNetworkLoggerScreen();
              }
            },
            child: Text('Tap to initiate screen')
        ),
      ),
    );
  }
}
