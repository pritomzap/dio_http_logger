
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
                client.get('https://jsonplaceholder.typicode.com/todos/1');
                client.post(
                  'https://jsonplaceholder.typicode.com/posts',
                  data: {
                    'title': 'New Post',
                    'body': 'This is the body of the new post.',
                    'userId': 1,
                  },
                );
                client.put(
                  'https://jsonplaceholder.typicode.com/posts/1',
                  data: {
                    'id': 1,
                    'title': 'Updated Post',
                    'body': 'This is the updated body of the post.',
                    'userId': 1,
                  },
                );
                client.post(
                  'https://jsonplaceholder.typicode.com/posts',
                  data: {
                    'title': 'New Post',
                    'body': 'This is the body of the new post.',
                    'userId': 1,
                  },
                );

                //DioNetworkLogger.instance.startNetworkLoggerScreen();
              }catch(e){
                //DioNetworkLogger.instance.startNetworkLoggerScreen();
              }
            },
            child: const Text('Tap to initiate screen')
        ),
      ),
    );
  }
}
