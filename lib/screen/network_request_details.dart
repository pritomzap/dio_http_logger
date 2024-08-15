import 'dart:convert';

import 'package:dio_http_logger/models/network_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/utils.dart';

class NetworkRequestDetails extends StatefulWidget {
  final NetworkModel? entry;
  const NetworkRequestDetails(this.entry, {super.key});

  @override
  State<NetworkRequestDetails> createState() => _NetworkRequestDetailsState();
}

class _NetworkRequestDetailsState extends State<NetworkRequestDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Overview',),
              Tab(text: 'Request',),
              Tab(text: 'Response',),
            ],
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.entry?.requestType??'',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              Text(Uri.parse(widget.entry?.path??'').path,style: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OverviewWidget(widget.entry!),
            RequestWidget(widget.entry!),
            ResponseWidget(widget.entry!),
          ],
        ),
      ),
    );
  }
}

class OverviewWidget extends StatelessWidget {
  final NetworkModel entry;
  const OverviewWidget(this.entry,{super.key});


  @override
  Widget build(BuildContext context) {
    final responseColor = (entry.code == null) ? Colors.black38 : (entry.code! >= 200 && entry.code! <= 300)? Colors.green:(entry.code! >= 400 && entry.code! <=499)?Colors.amber: Colors.red;
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Text('URI: ${entry.path}',style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
            Text('Request Type: ${entry.requestType}',style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            const Text('REQUEST',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.blueGrey),),
            Text('Request Time: ${milisToDateTime(int.parse(entry.requestTime??'0'))}'),
            Text('RequestSize: ${entry.requestSize??'0'} B'),
            Text('Content type: ${entry.requestOptions?.contentType??''}'),
            Text('Response type: ${entry.requestOptions?.responseType.name??'--'}'),
            Text('Send timeout: ${entry.requestOptions?.sendTimeout??'--'}'),
            Text('Receive timeout: ${entry.requestOptions?.receiveTimeout??'--'}'),
            Text('Connect timeout: ${entry.requestOptions?.connectTimeout??'--'}'),
            Text('Extra: ${entry.requestOptions?.extra??'--'}'),
            Text('Receive timeout(inMilliseconds): ${entry.requestOptions?.receiveTimeout?.inMilliseconds??0}'),
            const SizedBox(height: 10,),
            const Text('RESPONSE',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.blueGrey),),
            Text('Status code: ${entry.code == -87?'Error':entry.code}',style: TextStyle(color: responseColor,fontWeight: FontWeight.bold)),
            Text('Response Size: ${entry.responseSize??'0'} B'),
            Text('Response Time: ${milisToDateTime(int.parse(entry.responseTime??'0'))}'),
            Text('Delay(inMilliseconds): ${delayInMs(entry.responseTime??'',entry.requestTime??'')}'),
            Text('Status message: ${entry.response?.statusMessage??''}'),
            Text('Real uri: ${entry.response?.realUri.toString()??''}'),
          ],
        ),
    );
  }
}

class RequestWidget extends StatelessWidget {
  final NetworkModel entry;
  const RequestWidget(this.entry,{super.key});

  @override
  Widget build(BuildContext context) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Headers:',style: TextStyle(fontWeight: FontWeight.bold),),
                InkWell(
                    onTap: ()async{
                      Clipboard.setData(ClipboardData(text: '${entry.requestHeaders??''}'));
                    },
                    child: const Icon(Icons.copy,size: 14,)
                )
              ],
            ),
            Text(encoder.convert(entry.requestHeaders)),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Request body:',style: TextStyle(fontWeight: FontWeight.bold),),
                InkWell(
                    onTap: ()async{
                      Clipboard.setData(ClipboardData(text: '${entry.requestBody??''}'));
                    },
                    child: const Icon(Icons.copy,size: 14,)
                )
              ],
            ),
            Text(encoder.convert(entry.requestBody)??'- -'),
            const SizedBox(height: 10,),
            const Text('Extra:',style: TextStyle(fontWeight: FontWeight.bold),),
            Text(encoder.convert(entry.requestOptions?.extra)??'- -'),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}

class ResponseWidget extends StatelessWidget {
  final NetworkModel entry;
  const ResponseWidget(this.entry,{super.key});

  @override
  Widget build(BuildContext context) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Headers:',style: TextStyle(fontWeight: FontWeight.bold),),
                InkWell(
                  onTap: ()async{
                    Clipboard.setData(ClipboardData(text: '${entry.responseHeaders??''}'));
                  },
                  child: const Icon(Icons.copy,size: 14,)
                )
              ],
            ),
            Text(encoder.convert(entry.responseHeaders)),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Response body:',style: TextStyle(fontWeight: FontWeight.bold),),
                InkWell(
                    onTap: ()async{
                      Clipboard.setData(ClipboardData(text: entry.responseBody??''));
                    },
                    child: const Icon(Icons.copy,size: 14,)
                )
              ],
            ),
            Text(encoder.convert(entry.responseBody)??'- -'),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Extra:',style: TextStyle(fontWeight: FontWeight.bold),),
                InkWell(
                    onTap: ()async{
                      Clipboard.setData(ClipboardData(text: '${entry.response?.extra??''}'));
                    },
                    child: const Icon(Icons.copy,size: 14,)
                )
              ],
            ),
            Text(encoder.convert(entry.response?.extra)??'- -'),
            const SizedBox(height: 10,),
            entry.exception != null?Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Dio exception type:',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepOrange),),
                    InkWell(
                        onTap: ()async{
                          Clipboard.setData(ClipboardData(text: entry.exception?.type.name??''));
                        },
                        child: const Icon(Icons.copy,size: 14,)
                    )
                  ],
                ),
                Text(entry.exception?.type.name??'',style: const TextStyle(color: Colors.deepOrange)),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Error-message:',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepOrange),),
                    InkWell(
                        onTap: ()async{
                          Clipboard.setData(ClipboardData(text: entry.exception?.message??''));
                        },
                        child: const Icon(Icons.copy,size: 14,)
                    )
                  ],
                ),
                Text(entry.exception?.message??'',style: const TextStyle(color: Colors.deepOrange)),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Stack-trace:',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepOrange),),
                    InkWell(
                        onTap: ()async{
                          Clipboard.setData(ClipboardData(text: '${entry.exception?.stackTrace??''}'));
                        },
                        child: const Icon(Icons.copy,size: 14,)
                    )
                  ],
                ),
                Text(entry.exception?.stackTrace.toString()??'',style: const TextStyle(color: Colors.deepOrange)),
                const SizedBox(height: 10,),
              ],
            ):Container(),
          ],
        ),
      ),
    );
  }
}


