import 'dart:convert';

class LoginRequestModel {
  String? username;
  String? password;

  LoginRequestModel({this.username, this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {'username': username, 'password': password, 'grant_type': 'password'};

    return map;
  }
}

class LoginResponseModel {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? username;
  String? avartar;
  String? fullName;
  String? emailAddress;
  String? phoneNumber;
  String? issued;
  String? expires;

  String? errorDescription;
  String? error;

  LoginResponseModel({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.username,
    this.avartar,
    this.fullName,
    this.emailAddress,
    this.phoneNumber,
    this.issued,
    this.expires,
    this.errorDescription,
    this.error,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json["access_token"] != null ? json["access_token"] : "",
      tokenType: json["token_type"] != null ? json["token_type"] : "",
      expiresIn: json["expires_in"] != null ? json["expires_in"] : 0,
      username: json["username"] != null ? json["username"] : "",
      avartar:"https://www.w3schools.com/howto/img_avatar.png",
      fullName: json["fullName"] != null ? json["fullName"] : "",
      emailAddress: json["emailAddress"] != null ? json["emailAddress"] : "",
      phoneNumber: json["phoneNumber"] != null ? json["phoneNumber"] : "",
      issued: json[".issued"] != null ? json[".issued"] : "",
      expires: json[".expires"] != null ? json[".expires"] : "",
      errorDescription: json["error_description"] != null ? json["error_description"] : "",
      error: json["error"] != null ? json["error"] : "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'username': username,
      'fullName': fullName,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
      '.issued': issued,
      '.expires': expires,
      'error_description': errorDescription,
      'error': error,
    };
  }

  String toJson() => json.encode(toMap());
}
