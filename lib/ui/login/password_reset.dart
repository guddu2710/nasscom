import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:event_management/validation/validation.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Createpassword extends StatefulWidget {
  String otp;
  Createpassword({Key key, this.otp}) : super(key: key);
  @override
  _CreatepasswordState createState() => _CreatepasswordState();
}

class _CreatepasswordState extends State<Createpassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllerPassword = new TextEditingController();
  TextEditingController _controllercPassword = new TextEditingController();
  final _validation = new Validation();
  bool _autoValidate = false;
  String Otp;

  @override
  void initState() {
    // TODO: implement initState
    Otp = widget.otp;
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
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          body: Container(
            child: Form(
                key: _formKey,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            TextFormField(
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                autovalidate: _autoValidate,
                                validator: _validation.validatePassword,
                                controller: _controllerPassword,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                    errorStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    contentPadding: EdgeInsets.all(10),
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.black),
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
                                            BorderRadius.circular(5.0)))),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                                autovalidate: _autoValidate,
                                validator: (confirmpass) {
                                  var password = _controllerPassword.text;
                                  if (confirmpass != password) {
                                    return "Confirm Password should match password";
                                  }
                                },
                                controller: _controllercPassword,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                    errorStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    contentPadding: EdgeInsets.all(10),
                                    hintText: "Comfrim password",
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
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
                                            BorderRadius.circular(5.0)))),
                            SizedBox(
                              height: 20.0,
                            ),
                            ButtonTheme(
                                height: 50.0,
                                child: RaisedButton(
                                  onPressed: () => _validateInputs(),
                                  color: Colors.black,
                                  child: new Text(
                                    'Create Password',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                )),
                            SizedBox(
                              height: 20.0,
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
      await _postPassword();
      //await  _signUp();

    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _postPassword() async {
    try {
      var url = Config.reset_password + Otp;
      print(url);

      var formData = {
        "password": _controllerPassword.text,
      };
      final response =
          await Services(url).noAuthPostMethod(formData, context, _scaffoldKey);
      print(response);
      if (response == null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Color(0xffc00e34),
          content: Text('No data available'),
          duration: Duration(seconds: 3),
        ));
      } else {
        ResetPassword _reset = new ResetPassword();
        _reset = ResetPassword.fromJson(response);
        if (_reset.status) {
          Toast.show(
            _reset.message,
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
          Navigator.of(context).pushReplacementNamed("/login");
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              backgroundColor: Color(0xffc00e34),
              content: Text(_reset.message),
              duration: Duration(seconds: 3)));
        }
      }
    } catch (e) {
      print(e.toString());
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Color(0xffc00e34),
        content: Text('Something went worng'),
        duration: Duration(seconds: 3),
      ));
    }
  }
}

class ResetPassword {
  String message;
  bool status;

  ResetPassword({this.message, this.status});

  ResetPassword.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
