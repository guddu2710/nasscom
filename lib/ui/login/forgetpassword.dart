import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:event_management/validation/validation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';

import 'model/otp_model.dart';
import 'otp.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _controllerEmail = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _autoValidate = false;
  final _validation = new Validation();
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
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            Center(
                              child: Text(
                                "RESET PASSWORD",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Center(
                              child: Text(
                                "We will send a reset code to your recovery eamil to reset your password",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
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
                                      FontAwesomeIcons.mailBulk,
                                      color: Colors.grey,
                                    ), // icon is 48px widget.
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  hintText: "enter your mail ID",
                                  fillColor: Colors.white,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0.0),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
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
                                    'Reset Password',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Remenber Password?",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      InkWell(
                                        onTap: () => Navigator.of(context)
                                            .pushReplacementNamed("/login"),
                                        child: Text(
                                          "Login",
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
    );
  }

  void _validateInputs() async {
    print("hi");

    if (_formKey.currentState.validate()) {
      /*old*/
      setState(() {});
      sendOtp(_controllerEmail.text);
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  sendOtp(phone) async {
    try {
      var formData = {
        "email": phone,
      };
      final response = await Services(Config.forget_password)
          .noAuthPostMethod(formData, context, _scaffoldKey);
      print(response);
      if (response == null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Color(0xffc00e34),
          content: Text('No data available'),
          duration: Duration(seconds: 3),
        ));
      } else {
        var _otpModel = OtpModel.fromJson(response);
        if (_otpModel.status) {
          var route = MaterialPageRoute(
            builder: (BuildContext context) => ProfileOTP(
                  email: _controllerEmail.text,
                ),
          );
          Navigator.of(context).pushReplacement(route);
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Color(0xffc00e34),
            content: Text(_otpModel.message),
            duration: Duration(seconds: 3),
          ));
        }
      }
    } catch (e) {
      setState(() {
        Toast.show(
          "Something went wrong please try again later",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      });
      print(e);
    }
  }
}
