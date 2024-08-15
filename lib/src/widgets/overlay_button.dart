import 'package:dio_http_logger/src/dio_network_logger.dart';
import 'package:flutter/material.dart';

class OverlayButton extends StatelessWidget {
  const OverlayButton({super.key});

  @override
  Widget build(BuildContext context) {

    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        
        onPressed: () {
          DioNetworkLogger.instance.startNetworkLoggerScreen();
        },
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.network_wifi_1_bar_rounded),
            Text('Dio log',style: TextStyle(fontSize: 10),)
          ],
        ),
      ),
    );
  }
}