import 'dart:convert';

import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:event_management/validation/validation.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class CreateAccount extends StatefulWidget {
  @override
  _createAccountState createState() => _createAccountState();
}

class _createAccountState extends State<CreateAccount> {
//  Country _selected=Country(asset: "assets/flags/in_flag.png",
//    dialingCode: "91",
//    isoCode: "IN",
//    name: "India",);
  bool isSwitched = false;

  bool _isloading = false,
      _autoValidate = false,
      ismember = false,
      _ischoose = true;
  String _selected = "";
  String _picked = "No";
  TextEditingController _controllerFirstname = new TextEditingController();
  TextEditingController _controllerLastname = new TextEditingController();
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();
  TextEditingController _controllercPassword = new TextEditingController();
  TextEditingController _controllerPhone = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SharedPreferences sharedPreferences;
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  //static List<String> users = new List<String>();
  static List<String> users = [
    "abc",
    'acg',
    'adff',
    'fdf',
    'ffgggf',
    'fgjgh',
    'fgg',
    'hfggf',
    'hfg'
  ];

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
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                new Flexible(
                                  child: new Container(
                                    height: 3.0,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(fontSize: 30.0),
                                  ),
                                ),
                                new Flexible(
                                  child: new Container(
                                    height: 3.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    validator: (firstname) {
                                      if (firstname.length == 0) {
                                        return "Enter First name";
                                      }
                                    },
                                    textInputAction: TextInputAction.next,
                                    autovalidate: _autoValidate,
                                    controller: _controllerFirstname,
                                    style: TextStyle(color: Colors.black),
                                    decoration: new InputDecoration(
                                        errorStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.all(10),
                                        hintText: "First name*",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
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
//                                      decoration: InputDecoration(
//                                          contentPadding: EdgeInsets.all(10)
//                                      )
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                new Flexible(
                                  child: new TextFormField(
                                    validator: (lastname) {
                                      if (lastname.length == 0) {
                                        return "Enter Last name";
                                      }
                                    },
                                    autovalidate: _autoValidate,
                                    textInputAction: TextInputAction.next,
                                    controller: _controllerLastname,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: new InputDecoration(
                                        errorStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.all(10),
                                        hintText: "Last name*",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
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
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                                autovalidate: _autoValidate,
                                validator: _validation.validateEmail,
                                controller: _controllerEmail,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                    errorStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    contentPadding: EdgeInsets.all(10),
                                    hintText: "Email Address*",
                                    hintStyle: TextStyle(color: Colors.grey),
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
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Expanded(
                                  flex: 3,
                                  child: Container(
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15.0),
                                        child: Container(
                                          child: Text(
                                            "(+91)",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0),
                                          ),
                                        )

//                                      CountryPicker(
//                                        showFlag: false,
//                                        showName: false,
//                                        showDialingCode: true,
//
//                                        onChanged: (Country country) {
//                                          setState(() {
//                                            _selected = country;
//                                          });
//                                        },
//                                        selectedCountry: _selected,
//                                      ),
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                new Expanded(
                                  flex: 7,
                                  child: new TextFormField(
                                    textInputAction: TextInputAction.next,
                                    autovalidate: _autoValidate,
                                    maxLength: 10,
                                    validator: _validation.validatePhone,
                                    controller: _controllerPhone,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(color: Colors.black),
                                    decoration: new InputDecoration(
                                        errorStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.all(10),
                                        hintText: "Phone no",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
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
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
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
                                    hintStyle: TextStyle(color: Colors.grey),
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
                                    hintText: "Confirm password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
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
                            Row(
                              children: <Widget>[
                                Text(
                                  " NASSCOM member?",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                SizedBox(width: 20.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      " No",
                                      style: TextStyle(
                                          color: Colors.yellowAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                    Switch(
                                      value: isSwitched,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitched = value;
                                          if(!value){
                                            _ischoose=true;
                                          }
                                        });
                                      },
                                      activeTrackColor: Colors.white,
                                      activeColor: Colors.white,
                                    ),
                                    Text(
                                      "Yes",
                                      style: TextStyle(
                                          color: Colors.yellowAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
//                            SizedBox(
//                              height: 10.0,
//                            ),
//                            RadioButtonGroup(
//                                picked: _picked,
//                                labelStyle: TextStyle(
//                                    color: Colors.white,
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 18.0),
//                                activeColor: Colors.white,
//                                orientation:
//                                    GroupedButtonsOrientation.HORIZONTAL,
//                                labels: <String>[
//                                  "No           ",
//                                  "Yes",
//                                ],
//                                onSelected: (String selected) {
//                                  print(selected);
//                                  _picked = selected;
//                                  if (selected.toLowerCase() == "yes") {
//                                    setState(() {
//                                      ismember = true;
//                                      _ischoose = true;
//                                    });
//                                  } else {
//                                    setState(() {
//                                      ismember = false;
//                                      //_ischoose=false;
//                                    });
//                                  }
//                                }),
                            isSwitched
                                ? SizedBox(height: 20.0)
                                : SizedBox(height: 0.0),
                            isSwitched
                                ? AutoCompleteTextField<String>(
                                    key: key,
                                    clearOnSubmit: false,
                                    suggestions: users,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16.0),
                                    decoration: new InputDecoration(
                                        errorStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.all(10),
                                        hintText:
                                            "Type your Company name,registerd with NASSCOM*",
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 12.0),
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
                                    itemFilter: (item, query) {
                                      return item
                                          .toLowerCase()
                                          .startsWith(query.toLowerCase());
                                    },
                                    itemSorter: (a, b) {
                                      return a.compareTo(b);
                                    },
                                    itemSubmitted: (item) {
                                      setState(() {
                                        searchTextField
                                            .textField.controller.text = item;
                                        _ischoose = true;
                                        _selected = item;
                                      });
                                    },
                                    itemBuilder: (context, item) {
                                      // ui for the autocompelete row
                                      return row(item);
                                    },
                                  )
                                : Container(),
                            _ischoose
                                ? Container()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "Choose your company name",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                            SizedBox(
                              height: 20.0,
                            ),
                            _isloading
                                ? ButtonTheme(
                                    height: 50.0,
                                    child: RaisedButton(
                                      onPressed: () {},
                                      color: Colors.black,
                                      child: new Text(
                                        'Create Account',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                    ))
                                : ButtonTheme(
                                    height: 50.0,
                                    child: RaisedButton(
                                      onPressed: () => _validateInputs(),
                                      color: Colors.black,
                                      child: new Text(
                                        'Create Account',
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Already a member? ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed("/login");
                                        },
                                        child: Text(
                                          "Sign In",
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

  Widget row(String user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            user,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }

  void _validateInputs() async {
    print("hi");
    if (isSwitched) {

      if (_selected.length <= 0) {
        _ischoose = false;
      } else {
        _autoValidate = true;
        _ischoose = true;
      }
    }
    else{
      _autoValidate = true;
      _ischoose=true;
    }
    if (_formKey.currentState.validate()) {
      /*old*/
      setState(() {
        _isloading = true;
      });
      await _signUp();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _signUp() async {
    _isloading = true;
    sharedPreferences = await SharedPreferences.getInstance();

    print(sharedPreferences.get("fireToken"));

    _isloading = true;
    //  var phone=_selected.dialingCode.toString()+_controllerPhone.text;
    try {
      var formData = {
        "email": _controllerEmail.text,
        "phone_no": _controllerPhone.text,
        "password": _controllerPassword.text,
        "first_name": _controllerFirstname.text,
        "last_name": _controllerLastname.text,
        "device_token": sharedPreferences.get("fireToken")
      };
      final response = await Services(Config.register)
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
        _isloading = false;

        if (response.toString().contains("user")) {
          print("token=${response['token']}");
          sharedPreferences.setString("logged", "logged");
          sharedPreferences.setString("token", response['token']);
          sharedPreferences.setString("email", _controllerEmail.text);
          sharedPreferences.setString("password", _controllerPassword.text);
          sharedPreferences.setString("id", response['user']['_id']);
          sharedPreferences.setString("userdetails",
              json.encode(response['user']['user_informations']));
          sharedPreferences.setString("profile_pic", response['image']);
          Navigator.of(context).pushReplacementNamed("/dashboard");
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Color(0xffc00e34),
            content: Text('Invalid field'),
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
        "Somthing went wrong.",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
      );
    }
  }
}
