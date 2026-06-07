import 'package:dio/dio.dart';

/// Maps a caught request error into a domain-specific exception built by
/// [errorBuilder] and throws it. Always throws — it never returns.
///
/// [statusMessages] lets each caller provide messages for the HTTP status
/// codes it cares about (e.g. `{404: 'Not found.'}`); anything not listed
/// falls back to the generic message.
Never handleDioError(
  Object error,
  Exception Function(String message) errorBuilder, {
  Map<int, String> statusMessages = const {},
}) {
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
