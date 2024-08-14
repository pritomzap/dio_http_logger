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
    final responseColor = (entry.code == null) ? Colors.black38 : entry.code == 200 ? Colors.green:(entry.code! >= 400 && entry.code! <=499)?Colors.amber: Colors.red;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Text('URI: ${entry.path}',style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
            Text('Request Type: ${entry.requestType}',style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            const Text('REQUEST',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.blueGrey),),
            Text('Request Time: ${entry.requestTime}'),
            Text('RequestSize: ${entry.requestSize} B'),
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
            Text('Response Size: ${entry.responseSize} B'),
            Text('Response Time: ${entry.requestTime}'),
            Text('Delay(inMilliseconds): ${delayInMs(entry.requestTime??'',entry.responseTime??'')}'),
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
                Text('Headers:',style: TextStyle(fontWeight: FontWeight.bold),),
                InkWell(
                    onTap: ()async{
                      Clipboard.setData(ClipboardData(text: '${entry.requestHeaders??''}'));
                    },
                    child: Icon(Icons.copy,size: 14,)
                )
              ],
            ),
            Text(encoder.convert(entry.requestHeaders)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Request body:',style: TextStyle(fontWeight: FontWeight.bold),),
                InkWell(
                    onTap: ()async{
                      Clipboard.setData(ClipboardData(text: '${entry.requestBody??''}'));
                    },
                    child: Icon(Icons.copy,size: 14,)
                )
              ],
            ),
            Text(encoder.convert(entry.requestBody)??'- -'),
            const Text('Extra:',style: TextStyle(fontWeight: FontWeight.bold),),
            Text(encoder.convert(entry.requestOptions?.extra)??'- -'),
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
                  child: Icon(Icons.copy,size: 14,)
                )
              ],
            ),
            Text(encoder.convert(entry.responseHeaders)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Response body:',style: TextStyle(fontWeight: FontWeight.bold),),
                InkWell(
                    onTap: ()async{
                      Clipboard.setData(ClipboardData(text: '${entry.responseBody??''}'));
                    },
                    child: Icon(Icons.copy,size: 14,)
                )
              ],
            ),
            Text(encoder.convert(entry.responseBody)??'- -'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Extra:',style: TextStyle(fontWeight: FontWeight.bold),),
                InkWell(
                    onTap: ()async{
                      Clipboard.setData(ClipboardData(text: '${entry.response?.extra??''}'));
                    },
                    child: Icon(Icons.copy,size: 14,)
                )
              ],
            ),
            Text(encoder.convert(entry.response?.extra)??'- -'),
          ],
        ),
      ),
    );
  }
}


