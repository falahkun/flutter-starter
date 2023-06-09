// coverage:ignore-file
import 'package:dio/dio.dart';
import 'package:flutter_starter/core/core.dart';

extension DioErrorExtension on DioException {
  ServerException toServerException() {
    final msg = message ?? 'UNHANDLED_ERROR';
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.cancel:


        return TimeOutServerException(
          message: msg,
          code: response?.statusCode,
        );
      case DioExceptionType.badResponse:
        switch (response?.statusCode) {
          case 401:
            return UnAuthenticationServerException(
              message: msg,
              code: response?.statusCode,
            );
          case 403:
            return UnAuthorizeServerException(
              message: msg,
              code: response?.statusCode,
            );
          case 404:
            return NotFoundServerException(
              message: msg,
              code: response?.statusCode,
            );
          case 500:
          case 502:
            return InternalServerException(
              message: msg,
              code: response?.statusCode,
            );
          default:
            return GeneralServerException(
              message: msg,
              code: response?.statusCode,
            );
        }
      case DioExceptionType.unknown:
        return GeneralServerException(
          message: msg,
          code: response?.statusCode,
        );
    }
  }
}
