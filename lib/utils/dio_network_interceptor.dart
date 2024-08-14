import 'package:dio/dio.dart' as dio;
import 'package:dio_http_logger/models/network_model.dart';
import 'package:dio_http_logger/utils/utils.dart';

class DioNetworkInterceptor extends dio.Interceptor {
  Function(NetworkModel) callBackOnRequest;
  Function(dio.Response) callBackOnResponse;
  Function(dio.DioException) callBackOnError;
  DioNetworkInterceptor(this.callBackOnRequest,this.callBackOnResponse,this.callBackOnError);

  @override
  Future<void> onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) async{
    super.onRequest(options, handler);
    var requestTime = getCurrentDateTime();
    NetworkModel networkModel = NetworkModel();
    networkModel.requestType = options.method.toUpperCase();
    networkModel.path = "${options.baseUrl}${options.path}";
    networkModel.requestTime = requestTime;
    networkModel.requestHeaders = options.headers;
    networkModel.queryParams = options.queryParameters;
    networkModel.requestBody = options.data;
    networkModel.requestSize = measureNetworkData(options.data);
    networkModel.requestOptions = options;
    callBackOnRequest.call(networkModel);
    options.extra['requestTimestamp'] = requestTime;
  }

  @override
  Future<void> onResponse(dio.Response response, dio.ResponseInterceptorHandler handler) async{
    super.onResponse(response, handler);
    callBackOnResponse.call(response);
  }

  @override
  Future<void> onError(dio.DioException err, dio.ErrorInterceptorHandler handler) async{
    super.onError(err, handler);
    callBackOnError.call(err);
  }

  String? getCurrentDateTime(){
    DateTime now = DateTime.now();

    // 2. Extract individual components
    int year = now.year;
    int month = now.month;
    int day = now.day;
    int hour = now.hour;
    int minute = now.minute;
    int second = now.second;

    // 3. Format manually (basic example)
    String formattedDateTime =
        '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} '
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2,
        '0')}';
    return formattedDateTime;
  }

}
