import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../SharedPrefernce/shared_pref.dart';
import 'app_exception.dart';

class NetworkRequest {
  static const int timeOutDuration = 20;
  //original
  Future postMethodRequest(Map body, String api) async {
    var token = await SharedData.getToken("token");
    print(token);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token}',
    };
    try {
      http.Request request = http.Request('POST', Uri.parse(api));
      request.body = json.encode(body);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request
          .send()
          .timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      return throw InternetException('No Internet connection', api.toString());
    } on TimeoutException {
      return throw RequestTimeOutException(
          'API not responded in time', api.toString());
    }
  }

  Future putMethodRequest(Map body, String api) async {
    var token = await SharedData.getToken("token");
    bool hasExpired = JwtDecoder.isExpired(token);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      http.Request request = http.Request('PUT', Uri.parse(api));
      request.body = json.encode(body);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request
          .send()
          .timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      return throw FetchDataException('No Internet connection', api.toString());
    } on TimeoutException {
      return throw RequestTimeOutException(
          'API not responded in time', api.toString());
    }
  }

  Future getMethodRequest(String api) async {
    var token = await SharedData.getToken("token");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      http.Request request = http.Request('GET', Uri.parse(api));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request
          .send()
          .timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      return throw FetchDataException('No Internet connection', api.toString());
    } on TimeoutException {
      return throw RequestTimeOutException(
          'API not responded in time', api.toString());
    }
  }

  Future deleteMethodRequest(String api) async {
    var token = await SharedData.getToken("token");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token}'
    };
    try {
      http.Request request = http.Request('DELETE', Uri.parse(api));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request
          .send()
          .timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', api.toString());
    } on TimeoutException {
      throw RequestTimeOutException(
          'API not responded in time', api.toString());
    }
  }

  Future postDioRequest(String api, dynamic data) async {
    var token = await SharedData.getToken("token");
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token'
    };
    try {
      Response apiResponse = await Dio().postUri(Uri.parse(api),
          data: data, options: Options(headers: headers));
      if (apiResponse.statusCode == 201 || apiResponse.statusCode == 200) {
        return apiResponse.data;
      } else {
        print('errr');
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  dynamic _processResponse(http.StreamedResponse response) async {
    print(response.statusCode);
    switch (response.statusCode) {
      case 100:
        var responseJson = jsonDecode(await response.stream.bytesToString());
        return responseJson;
      case 200:
        var responseJson = jsonDecode(await response.stream.bytesToString());
        return responseJson;
      case 201:
        var responseJson = jsonDecode(await response.stream.bytesToString());
        return responseJson;
      case 400:
        return Future.error(BadRequestException(
            jsonDecode(await response.stream.bytesToString()),
            response.request!.url.toString()));
      case 401:
        return Future.error(UnAuthorizedException(
            jsonDecode(await response.stream.bytesToString()).toString(),
            response.request!.url.toString()));
      case 403:
        return Future.error(UnAuthorizedException());
      case 422:
        return Future.error(BadRequestException(
            jsonDecode(await response.stream.bytesToString()),
            response.request!.url.toString()));
      case 500:
        return Future.error(ServerException(
          "Internal Server",
        ));
      default:
        return Future.error(FetchDataException(
            'Error occurred with code : ${response.statusCode}',
            response.request!.url.toString()));
    }
  }
}
