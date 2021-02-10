import 'package:dio/dio.dart';

class MoviesException implements Exception {
  MoviesException.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.CANCEL:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        message = "Connection timeout";
        break;
      case DioErrorType.DEFAULT:
        message = "Connection to API server due to internet connection";
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        message = "Receive timeout";
        break;
      case DioErrorType.RESPONSE:
        message = _handleError(dioError.response.statusCode);
        break;
      case DioErrorType.SEND_TIMEOUT:
        message = "Send timeout in connection";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }
  String message;

  String _handleError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 404:
        return 'Request resource was not found';
      case 500:
        return 'Oops something went wrong';
    }
  }
}
