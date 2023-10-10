abstract class ExceptionResponse implements Exception {
  final String? message;

  ExceptionResponse(this.message);
}

class FetchFailure extends ExceptionResponse {
  FetchFailure(super.message);
}

class BadRequestFailure extends ExceptionResponse {
  BadRequestFailure(super.message);
}

class UnauthorizedFailure extends ExceptionResponse {
  UnauthorizedFailure(super.message);
}

class ForbidenFailure extends ExceptionResponse {
  ForbidenFailure(super.message);
}

class InvalidInputFailur extends ExceptionResponse {
  InvalidInputFailur(super.message);
}

class NotFoundFailure extends ExceptionResponse {
  NotFoundFailure(super.message);
}

class ServerFailure extends ExceptionResponse {
  ServerFailure(super.message);
}
