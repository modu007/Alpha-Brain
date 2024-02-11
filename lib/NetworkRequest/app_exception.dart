class AppException implements Exception {
  final String? message;
  final String? prefix;
  final String? url;

  AppException([this.message, this.prefix, this.url]);
}

class BadRequestException extends AppException {
  BadRequestException([String? message, String? url])
      : super(message, 'Bad Request', url);
}

class InternetException extends AppException {
  InternetException([String? message, String? url])
      : super(message, "No Internet");
}

class RequestTimeOutException extends AppException {
  RequestTimeOutException([String? message, String? url])
      : super(message, 'Api not responded in time', url);
}

class ServerException extends AppException {
  ServerException([String? message]) : super(message, "Internal server error");
}

class FetchDataException extends AppException {
  FetchDataException([String? message, String? url])
      : super(message, 'Unable to process', url);
}

class InvalidUrlException extends AppException {
  InvalidUrlException([String? message])
      : super(message, "Invalid request url");
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([String? message, String? url])
      : super(message, 'UnAuthorized request', url);
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "invalid input");
}
