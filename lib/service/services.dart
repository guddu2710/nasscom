import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class Services {
  static String baseUrl ="http://nasscomapp.openwebsolutions.in/api/";
//  static String baseUrl = "http://192.168.0.199:8006/api/";
  SharedPreferences sharedPreferences;
  var token;
  var userdata;
  String url;
  String method;
  Services(this.url);

  //  Authentication Based Service After Login *********/

  Future getMethod(context,_scaffoldKey) async{

    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.none){
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor:Colors.red[800] ,
            content: Text('Please check internet connection'),
            duration: Duration(seconds: 3),
          ));
      // Toast.show("Please check internet connection",context,duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
    }else {
      print(url);
      sharedPreferences = await SharedPreferences.getInstance();
      var token = await this.sharedPreferences.get('token');
      print(token);
      var dio = new Dio();
      dio.interceptors.add(InterceptorsWrapper(
          onRequest: (Options options) {
            options.method = 'GET';
            options.responseType = ResponseType.plain;
            options.headers['authorization'] = "Bearer $token";
            return options;
          }
      )
      );

      String requestUrl = baseUrl + url;
      print(requestUrl);
      try {
        var getData = await dio.get(requestUrl);
        var data = jsonDecode(getData.data);
        if (data['message'] == "Please enter validate token" &&
            data['status'] == 1010) {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Your Session has expired', textAlign: TextAlign.center,),
                content: const Text(
                  'Click ok to log in again', textAlign: TextAlign.center,),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login', (Route<dynamic> route) => false);
                    },
                  ),
                ],
              );
            },
          );
        } else {
          return data;
        }
      } catch (e) {
        print(e);
        Toast.show("Server error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
      }
    }
  }
  Future postMethod(formData,context,[_scaffoldKey]) async{
    print("dshhsd");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.none){
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor:Colors.red[800] ,
            content: Text('Please check internet connection'),
            duration: Duration(seconds: 3),
          ));

      // Toast.show("Please check internet connection",context,duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
    }else {
      sharedPreferences = await SharedPreferences.getInstance();
      var token = await this.sharedPreferences.get('token');
      var dio = new Dio();
      dio.interceptors.add(InterceptorsWrapper(
          onRequest: (Options options) {
            options.method = 'POST';
            options.responseType = ResponseType.plain;
            options.headers['authorization'] = "Bearer $token";
            return options;
          }
      )
      );

      String requestUrl = baseUrl + url;
      try {
        var getData = await dio.post(requestUrl, data: formData);
        var data = jsonDecode(getData.data);
        print(data);

        if (data['message'] == "Please enter validate token" &&
            data['status'] == 500) {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Your Session has expired', textAlign: TextAlign.center,),
                content: const Text(
                  'Click ok to log in again', textAlign: TextAlign.center,),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login', (Route<dynamic> route) => false);
                    },
                  ),
                ],
              );
            },
          );
        } else {
          return data;
          print(data);
        }
      } catch (e) {
        Toast.show("Server error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
      }
    }

  }

  //  /******  Authentication Based Service After Login end*********/

  // /******  Noauth Based Service Start *********/


  noAuthPostMethod(formData,context,[scaffoldKey]) async{

    String requestUrl = baseUrl + url;
    print(url);

    print(requestUrl);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.none){
      scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor:Colors.red[800] ,
            content: Text('Please check internet connection'),
            duration: Duration(seconds: 3),
          ));
      //   Toast.show("Please check internet connection",context,duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
    }else {
      try {
        print(requestUrl.toString());
        var response = await http.post(requestUrl, body: formData);
        print("response $response");
        final responseJson = json.decode(response.body);
        print("responseJson $responseJson");
        return responseJson;
      }catch(e){
        print("catch $e");
        Toast.show("Server Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
      }
    }

  }

}
