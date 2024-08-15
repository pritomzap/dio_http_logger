import 'package:dio_http_logger/models/network_model.dart';
import 'package:dio_http_logger/screen/network_request_details.dart';
import 'package:flutter/material.dart';

import '../dio_network_logger.dart';
import '../utils/utils.dart';

class NetworkRequestsList extends StatefulWidget {
  const NetworkRequestsList({super.key});

  @override
  State<NetworkRequestsList> createState() => _NetworkRequestsListState();
}

class _NetworkRequestsListState extends State<NetworkRequestsList> {

  final DioNetworkLogger _dioNetworkLogger = DioNetworkLogger.instance;
  List<NetworkModel> models = [];

  @override
  void initState() {
    models = _dioNetworkLogger.networkModels;
    _dioNetworkLogger.listenerEventChange = (){
      setState(() {
        models = _dioNetworkLogger.networkModels;
      });
    };
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dioNetworkLogger.listenerEventChange = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio logger'),
      ),
      body: Stack(
        children: [
          models.isNotEmpty?Container(
            color: Colors.white,
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 100),
              itemCount: models.length,
              itemBuilder: (context, index) {
                return NetworkLogEntryWidget(entry: models[index]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider( // Or any other separator widget you prefer
                  height: 1,
                  color: Colors.black12,
                );
              },
            ),
          ):const Center(child: Text('No requests found'),),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.indigo,
              onPressed: () {
                DioNetworkLogger.instance.deleteAllRequests();
              },
              child: const Icon(Icons.delete,color: Colors.white,),
            ),
          ),
          /*Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                //DioNetworkLogger.instance.startNetworkLoggerScreen();
              },
              child: Icon(Icons.filter_list_alt,color: Colors.white,),
            ),
          ),*/
        ],
      ),
    );
  }

}

class NetworkLogEntryWidget extends StatelessWidget {
  final NetworkModel entry;

  const NetworkLogEntryWidget({super.key, required this.entry});

@override
  Widget build(BuildContext context) {
  var typeColor = entry.code == null?Colors.black26:entry.requestType == 'GET'?Colors.green:entry.requestType == 'POST'?Colors.teal:entry.requestType == 'PUT'?Colors.indigo:Colors.red;
  final responseColor = (entry.code == null) ? Colors.black38 : (entry.code! >= 200 && entry.code! <= 300) ? Colors.green:(entry.code! >= 400 && entry.code! <=499)?Colors.amber: Colors.red;
  final uri = Uri.parse(entry.path??'');

  return ListTile(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("${entry.requestType}",style: TextStyle(color: typeColor,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold),),
            const SizedBox(width: 5,),
            Expanded(
              child: Text(
                  uri.path,
                  style: TextStyle(color: entry.code == null?Colors.black26:Colors.black,),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  textAlign: TextAlign.start, // Align text to the start (left)
                  maxLines: 1,
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            uri.scheme == 'https'?const Icon(Icons.lock,size: 12,):Container(),
            Text(' ${uri.scheme}://${uri.host}',style: TextStyle(color: entry.code == null?Colors.black26:Colors.black,fontSize: 12,fontWeight: FontWeight.bold),),
          ],
        )
      ],
    ),
    subtitle: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Time: ${milisToDateTime(int.parse(entry.requestTime??'0'))}",style: TextStyle(color: entry.code == null?Colors.black26:Colors.black,fontSize: 10)),
        Text("Size: ${entry.responseSize ?? '0'}B",style: TextStyle(color: entry.code == null?Colors.black26:Colors.black,fontSize: 10)),
      ],
    ),
    trailing: Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: responseColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        entry.code == -87?'Error':entry.code == null?'Pending':entry.code.toString(),
        style: const TextStyle(color: Colors.white),
      ),
    ),
    onTap: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (_) =>  NetworkRequestDetails(entry)));
    },
  );
  }
}
