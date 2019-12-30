import 'dart:convert';

import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:event_management/validation/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/login_model.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();
  bool _isloading = false, _autoValidate = false;
  LoginModel _loginModel = new LoginModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _validation = new Validation();
  DateTime currentBackPressTime;
  SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime) > Duration(seconds: 2)) {
            currentBackPressTime = now;
            Toast.show(
              "double tap to exit",
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
            );
          } else {
            SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
          }
        },
        child: Stack(
          children: <Widget>[
            Image.asset(
              "image/Spash_screen_back.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              resizeToAvoidBottomPadding: false,
              body: Container(
                child: Form(
                    key: _formKey,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                Image.asset(
                                  "image/Nasscom.png",
                                  fit: BoxFit.cover,
                                  height: 80.0,
                                  width: 80.0,
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  autovalidate: _autoValidate,
                                  validator: _validation.validateEmail,
                                  controller: _controllerEmail,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: new InputDecoration(
                                      errorStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Icon(
                                          FontAwesomeIcons.userAlt,
                                          color: Colors.grey,
                                        ), // icon is 48px widget.
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      hintText: "user name",
                                      fillColor: Colors.white,
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(5.0))),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.done,
                                  obscureText: true,
                                  autovalidate: _autoValidate,
                                  validator: _validation.validatePassword,
                                  controller: _controllerPassword,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: new InputDecoration(
                                      errorStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      hintText: "password",
                                      fillColor: Colors.white,
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Icon(
                                          FontAwesomeIcons.lock,
                                          color: Colors.grey,
                                        ), // icon is 48px widget.
                                      ),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(5.0))),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed("/forgotPassword");
                                        },
                                        child: Text(
                                          "Forget Your password?",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                ButtonTheme(
                                    height: 50.0,
                                    child: RaisedButton(
                                      onPressed: () {
                                        _validateInputs();
                                      },
                                      color: Colors.black,
                                      child: new Text(
                                        'LOGIN',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                    )),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Not a member?",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          InkWell(
                                            onTap: () => Navigator.of(context)
                                                .pushReplacementNamed(
                                                    "/createAccount"),
                                            child: Text(
                                              " Sign up",
                                              style: TextStyle(
                                                  color: Colors.yellow,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
            )
          ],
        ));
  }

  void _validateInputs() async {
    print("hi");

    if (_formKey.currentState.validate()) {
      /*old*/
      setState(() {
        _isloading = true;
      });
      await _login();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _login() async {
    sharedPreferences = await SharedPreferences.getInstance();

    print("hi");

    _isloading = true;
    try {
      var formData = {
        "email": _controllerEmail.text,
        "password": _controllerPassword.text,
        "device_token": sharedPreferences.getString("fireToken")
      };
      final response = await Services(Config.login)
          .noAuthPostMethod(formData, context, _scaffoldKey);
      print(response);
      if (response == null) {
        setState(() {
          _isloading = false;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Color(0xffc00e34),
          content: Text('No data available'),
          duration: Duration(seconds: 3),
        ));
      } else {
        setState(() {
          _loginModel = LoginModel.fromJson(response);
        });
        if (_loginModel.status) {
          print("token=${response['token']}");
          setState(() {});
          sharedPreferences.setString("logged", "logged");
          sharedPreferences.setString("id", _loginModel.user.sId);
          sharedPreferences.setString("token", _loginModel.token);
          sharedPreferences.setString("email", _controllerEmail.text);
          sharedPreferences.setString("password", _controllerPassword.text);
          sharedPreferences.setString(
              "userdetails", json.encode(_loginModel.user.userInformations));
          sharedPreferences.setString("profile_pic", _loginModel.user.image);
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
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.red[800],
            content: Text('Invalid user name or password'),
            duration: Duration(seconds: 3),
          ));
        }
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _isloading = false;
      });
      Toast.show(
        "Invalid user name or password",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
      );
    }
  }
}
