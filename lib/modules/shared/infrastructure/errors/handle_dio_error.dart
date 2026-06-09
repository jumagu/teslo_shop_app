import 'package:dio/dio.dart';

/// Maps a caught request error into a domain-specific exception of type [T]
/// built by [errorBuilder] and throws it. Always throws — it never returns.
///
/// If [error] is already a [T] (e.g. a [T] thrown deeper in the call stack),
/// it is rethrown untouched so its original message is preserved.
///
/// [statusMessages] lets each caller provide messages for the HTTP status
/// codes it cares about (e.g. `{404: 'Not found.'}`); anything not listed
/// falls back to the generic message.
Never handleDioError<T extends Exception>(
  Object error,
  T Function(String message) errorBuilder, {
  Map<int, String> statusMessages = const {},
}) {
  if (error is T) throw error;

  if (error is DioException) {
    if (error.type == DioExceptionType.connectionTimeout) {
      throw errorBuilder('Network error.');
    }

    final message = statusMessages[error.response?.statusCode];
    if (message != null) throw errorBuilder(message);

    throw errorBuilder('Something went wrong. Please, try again.');
  }

  throw errorBuilder('Unknown error.');
}
