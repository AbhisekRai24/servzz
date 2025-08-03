// import 'package:dio/dio.dart';

// class DioErrorInterceptor extends Interceptor {
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     String errorMessage;

//     if (err.response != null) {
//       final statusCode = err.response?.statusCode ?? 0;
//       if (statusCode >= 300) {
//         errorMessage =
//             err.response?.data['message']?.toString() ??
//             err.response?.statusMessage ??
//             'Unknown error';
//       } else {
//         errorMessage = 'Something went wrong';
//       }
//     } else {
//       errorMessage = 'Connection error';
//     }

//     final customError = DioException(
//       requestOptions: err.requestOptions,
//       response: err.response,
//       error: errorMessage,
//       type: err.type,
//     );

//     // super.onError(customError, handler);
//     handler.next(customError);
//   }
// }

import 'package:dio/dio.dart';

class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage;

    if (err.response != null) {
      final statusCode = err.response?.statusCode ?? 0;
      final responseData = err.response?.data;

      if (statusCode >= 300) {
        errorMessage =
            responseData is Map && responseData.containsKey('message')
                ? responseData['message'].toString()
                : err.response?.statusMessage ?? 'Unknown error';
      } else {
        errorMessage = 'Something went wrong';
      }

      // Print detailed error info to console for debugging
      print("🔴 Dio Error:");
      print("URL: ${err.requestOptions.uri}");
      print("Method: ${err.requestOptions.method}");
      print("Status Code: $statusCode");
      print("Response Data: $responseData");
    } else {
      errorMessage = 'Connection error';

      print("🔴 Dio Error: No response");
      print("Error Message: ${err.message}");
    }

    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      error: errorMessage,
      type: err.type,
    );

    handler.next(customError);
  }
}
