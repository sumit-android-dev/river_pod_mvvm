enum HttpError {
  unauthorized(401),
  forbidden(403),
  notFound(404),
  internalServerError(500),
  unknown(-1);

  final int statusCode;
  const HttpError(this.statusCode);

  static HttpError fromStatusCode(int? statusCode) {
    return HttpError.values.firstWhere(
      (e) => e.statusCode == statusCode,
      orElse: () => HttpError.unknown,
    );
  }
}
