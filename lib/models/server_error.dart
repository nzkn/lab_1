class ServerError {

  final int code;
  final String message;

  ServerError(this.code, this.message);

  ServerError.fromJson(Map<String, dynamic> m):
        code = m['code'],
        message = m['message'];
}