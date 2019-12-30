import 'dart:async';
import 'dart:convert';
import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:event_management/ui/dashboard/dashboard.dart';
import 'package:event_management/ui/login/model/login_model.dart';
import 'package:event_management/ui/notification/notification.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  String tokens;
  SharedPreferences sharedPreferences;
  LoginModel _loginModel = new LoginModel();
  String _navigate;
  @override
  void initState() {
    super.initState();
    s();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message hghh $message');

        if (message['type'] == "notification") {
          sharedPreferences.setInt(
              "nCount", sharedPreferences.getInt("nCount") + 1);
        } else {
          sharedPreferences.setInt(
              "mCount", sharedPreferences.getInt("mCount") + 1);
        }
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
        if (message['data']["type"] == "notification") {
         // Navigator.of(context).pushNamed("/notificationpage");

          var route = MaterialPageRoute(
            builder: (BuildContext context) => Dashboard(route: "/notificationpage",
            ),
          );
          Navigator.of(context).push(route);
        } else {
//          sharedPreferences.setInt(
//              "mCount", sharedPreferences.getInt("mCount") + 1);
          Navigator.of(context).pushNamed("/chatScreen");
        }
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      tokens = token;
      sharedPreferences.setString("fireToken", tokens);
      print(token);
    });
    //getToken();
    _getLogged();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "image/Spash_screen_back.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            resizeToAvoidBottomPadding: false,
            body: Center(
              child: Image.asset(
                "image/Nasscom.png",
                fit: BoxFit.fill,
              ),
            ))
      ],
    );
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(_navigate);
  }

  void _getLogged() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      final logged = sharedPreferences.get("logged");
      if (logged != null) {
        _getProfiledata();
        print(logged);
      } else {
        _navigate = "/login";
      }
    });
  }

  void _getProfiledata() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();

      final email = sharedPreferences.get('email');
      final password = sharedPreferences.get('password');
      _login(email, password);
    } catch (e) {
      setState(() {
        _navigate = "/login";
      });
      Toast.show(
        "Something went wrong please try again later",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
    }
  }

  _login(email, password) async {
    sharedPreferences = await SharedPreferences.getInstance();
    print("hi");
    try {
      var formData = {
        "email": email,
        "password": password,
        "device_token": sharedPreferences.getString("fireToken")
      };
      final response =
          await Services(Config.login).noAuthPostMethod(formData, context);
      print(response);
      if (response == null) {
        setState(() {
          _navigate = "/login";
        });

        Toast.show(
          "No data available",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        setState(() {
          _loginModel = LoginModel.fromJson(response);
        });
        if (_loginModel.status) {
          print("token=${response['token']}");
          sharedPreferences.setString("logged", "logged");
          sharedPreferences.setString("token", response['token']);
          sharedPreferences.setString("id", _loginModel.user.sId);
          sharedPreferences.setString("email", email);
          sharedPreferences.setString("password", password);
          sharedPreferences.setString("profile_pic", _loginModel.user.image);
          sharedPreferences.setString(
              "userdetails", json.encode(_loginModel.user.userInformations));
          if (_loginModel.user.userInformations.company==null||
              _loginModel.user.userInformations.industry==null||
              _loginModel.user.userInformations.designation == null ||
              _loginModel.user.userInformations.about == null ||
              _loginModel.user.userInformations.linkedin == null ||
              _loginModel.user.userInformations.facebook == null) {
            Toast.show(
              "your profile is incomplete",
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.TOP,
            );
          }
          Navigator.of(context).pushReplacementNamed("/dashboard");
          setState(() {
            _navigate = "/dashboard";
          });
        } else {
          setState(() {
            _navigate = "/login";
          });
          Toast.show(
            "Invalid user name password",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,
          );
        }
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _navigate = "/login";
      });
      Toast.show(
        "Something went wrong please try again later",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
      );
    }
  }

  void getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("fireToken", tokens);
  }

  void s() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (!sharedPreferences.containsKey("mCount")) {
      sharedPreferences.setInt("mCount", 0);
    }
    if (!sharedPreferences.containsKey("nCount")) {
      sharedPreferences.setInt("nCount", 0);
    }
  }
}
