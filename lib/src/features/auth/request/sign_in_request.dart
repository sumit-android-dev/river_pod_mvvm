class SignInRequest {
  String username;
  String password;
  int expiresInMins;

  SignInRequest({
    this.username = 'emilys',
    this.password = 'emilyspass',
    this.expiresInMins = 2,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'expiresInMins': expiresInMins,
    };
  }
}