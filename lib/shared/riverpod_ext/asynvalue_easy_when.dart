import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This one is extension `when` extension on AsyncValue
/// with some default loading,error widget and
///  also which also supports custom loading and error widget
extension AsyncDisplay<T> on AsyncValue<T> {
  Widget easyWhen({
    required Widget Function(T data) data,
    Widget Function(Object error, StackTrace stackTrace)? errorWidget,
    Widget Function()? loadingWidget,
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = true,
    bool skipError = false,
    bool isLinear = false,
    VoidCallback? onRetry,
    bool includedefaultDioErrorMessage = false,
  }) =>
      when(
        data: data,
        error: (error, stackTrace) {
          return errorWidget != null
              ? errorWidget(
                  error,
                  stackTrace,
                )
              : DefaultErrorWidget(
                  isLinear: isLinear,
                  error: error,
                  stackTrace: stackTrace,
                  onRetry: onRetry,
                  includedefaultDioErrorMessage: includedefaultDioErrorMessage,
                );
        },
        loading: () {
          return loadingWidget != null
              ? loadingWidget()
              : DefaultLoadingWidget(
                  isLinear: isLinear,
                );
        },
        skipError: skipError,
        skipLoadingOnRefresh: skipLoadingOnRefresh,
        skipLoadingOnReload: skipLoadingOnReload,
      );
}

/// This class give defaut loading widget
class DefaultLoadingWidget extends StatelessWidget {
  const DefaultLoadingWidget({
    required this.isLinear,
    super.key,
  });
  final bool isLinear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLinear
          ? const LinearProgressIndicator()
          : const CircularProgressIndicator.adaptive(),
    );
  }
}

/// This widget supports error messages automatically
class DefaultErrorWidget extends StatelessWidget {
  const DefaultErrorWidget({
    required this.error,
    required this.stackTrace,
    required this.onRetry,
    required this.isLinear,
    required this.includedefaultDioErrorMessage,
    super.key,
  });
  final Object error;
  final StackTrace stackTrace;
  final VoidCallback? onRetry;
  final bool isLinear;
  final bool includedefaultDioErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLinear
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ErrorTextWidget(
                  error: error,
                  includedefaultDioErrorMessage: includedefaultDioErrorMessage,
                ),
                if (onRetry != null)
                  Flexible(
                    child: ElevatedButton(
                      onPressed: onRetry,
                      child: const Text('Try again '),
                    ),
                  )
                else
                  const Flexible(
                    child: Text(
                      'Try Again later.',
                      style: TextStyle(
                        fontSize: 8,
                      ),
                    ),
                  ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Flexible(
                  child: CircleAvatar(
                    radius: 32,
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    'Something went wrong!',
                    style: TextStyle(
                      color: Colors.red.shade500,
                      fontWeight: FontWeight.w500,
                      fontSize: 8,
                    ),
                  ),
                ),
                ErrorTextWidget(
                  error: error,
                  includedefaultDioErrorMessage: includedefaultDioErrorMessage,
                ),
                if (onRetry != null)
                  Flexible(
                    child: ElevatedButton(
                      onPressed: onRetry,
                      child: const Text('Try again '),
                    ),
                  )
                else
                  Flexible(
                    child: Text(
                      'Try Again later.',
                      style: TextStyle(
                        color: Colors.red.shade500,
                        fontWeight: FontWeight.w500,
                        fontSize: 8,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

///This widgets classes default error messages
class ErrorTextWidget extends StatelessWidget {
  const ErrorTextWidget({
    required this.error,
    required this.includedefaultDioErrorMessage,
    super.key,
  });
  final Object error;
  final bool includedefaultDioErrorMessage;

  @override
  Widget build(BuildContext context) {
    if (includedefaultDioErrorMessage && error is DioException) {
      return DefaultDioErrorWidget(
        dioError: error as DioException,
      );
    }
    return Flexible(
      child: Text(
        error.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

///This class used to show error message according to DioException type
class DefaultDioErrorWidget extends StatelessWidget {
  const DefaultDioErrorWidget({
    required this.dioError,
    super.key,
  });
  final DioException dioError;

  @override
  Widget build(BuildContext context) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return const Flexible(
          child: Text(
            'Connection Timeout Error',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );

      case DioExceptionType.sendTimeout:
        return const Flexible(
          child: Text(
            'Unable to connect to the server.Please try again later.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );

      case DioExceptionType.receiveTimeout:
        return const Flexible(
          child: Text(
            'Check you internet connection reliability.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case DioExceptionType.badCertificate:
        return const Flexible(
          child: Text(
            'Please update your OS or add certificate.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );

      case DioExceptionType.badResponse:
        return const Flexible(
          child: Text(
            'Something went wrong.Please try again later.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case DioExceptionType.cancel:
        return const Flexible(
          child: Text(
            'Request Cancelled',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case DioExceptionType.connectionError:
        return const Flexible(
          child: Text(
            'Unable to connect to server.Please try again later.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case DioExceptionType.unknown:
        return const Flexible(
          child: Text(
            'Please check your internet connection.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }
}
