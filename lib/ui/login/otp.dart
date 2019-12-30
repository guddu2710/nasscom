import 'dart:convert';

import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:event_management/ui/login/password_reset.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quiver/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:toast/toast.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'model/otp_model.dart';
class ProfileOTP extends StatefulWidget {
  String phone;
  String email;
  String route;
  ProfileOTP({Key key, this.phone,this.email,this.route}) : super(key: key);
  @override
  _ProfileOTPState createState() => _ProfileOTPState();
}

class _ProfileOTPState extends State<ProfileOTP> {
  SharedPreferences sharedPreferences;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  OtpModel _otpModel=new OtpModel();
  TextEditingController otpController = TextEditingController();
  bool hasError = false;
  String phone;
  String email;
  String getOtp;
  int _start = 13;
  String display = '13';
  String otpval;
  String route;

  @override
  void initState() {
    super.initState();
      this.email =  widget.email;
      sendOtp(this.email);

  }

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {


      if((_start - duration.elapsed.inSeconds) <10)
      {
        setState(() {
          display = (_start - duration.elapsed.inSeconds).toString().padLeft(2, '0');
        });
      }else{
        setState(() {
          display = (_start - duration.elapsed.inSeconds).toString();
        });
      }

    });


    sub.onDone(() {
      display = '13';
      print("Done");
      sub.cancel();
    });
  }

  sendOtp(phone) async{
    try{
      var formData = {
        "email": phone,
      };
      final response = await Services(Config.forget_password).noAuthPostMethod(formData, context,_scaffoldKey);
      print(response);
      if(response==null) {
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor:Color(0xffc00e34) ,
              content: Text('No data available'),
              duration: Duration(seconds: 3),
            ));
      }else{
        _otpModel=OtpModel.fromJson(response);
        if(_otpModel.status){
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                backgroundColor:Color(0xffc00e34) ,
                content: Text(_otpModel.message),
                duration: Duration(seconds: 3),
              ));
          setState(() {
            getOtp=_otpModel.otp.toString();
          });
        }
        else{
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                backgroundColor:Color(0xffc00e34) ,
                content: Text(_otpModel.message),
                duration: Duration(seconds: 3),
              ));
        }

      }
    }catch(e){
      setState(() {
        Toast.show("Something went wrong please try again later", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM,);
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).requestFocus(new FocusNode()),
      child: Stack(
        children: <Widget>[
          Image.asset(
            "image/Spash_screen_back.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,),
          Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset : false,
            resizeToAvoidBottomPadding:false,

            body: Container(
              padding: EdgeInsets.only(right: 30.0,left: 30.0,top: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 150.0,),
                    Center(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Text("Welcome",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                  color: Colors.white,
                              ),),
                            ),
                            SizedBox(height: 5.0,),

                            Center(
                              child: Text("Submit OTP to reset password",style: TextStyle(
                                  fontSize: 15.0,
                                color: Colors.white
                              ),),
                            ),
                            SizedBox(height: 3.0),
                            Center(
                              child: Text(email,style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0,),
                    PinCodeTextField(
                      maxLength: 4,
                      controller: otpController,
                      pinBoxHeight: 50.0,
                      pinBoxWidth: 50.0,
                      hasError: hasError,
                      autofocus: false,
                      highlightColor: Colors.white,
                      hasTextBorderColor: Colors.white,
                      defaultBorderColor: Colors.white,
                      pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
                      pinBoxDecoration:ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                      pinTextStyle: TextStyle(
                          fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600
                      ),
                      onTextChanged: (text) {
                        setState(() {
                          hasError = false;
                        });
                      },
                    ),
                    SizedBox(height: 20.0,),
                    Container(
                      padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                      child: ButtonTheme(
                        height: 45.0,
                        child: RaisedButton(
                          onPressed: (){
                             _verifyEmailOtp();
                          },
                          textColor: Colors.white,
                          color: Colors.black,
                          child: new Text('VERIFY',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0
                            ),
                          ),

                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                      child: display == '13' ? ButtonTheme(
                        height: 45.0,
                        child: RaisedButton(
                          onPressed: (){
                            startTimer();
                            this.sendOtp(this.email);
                          },
                          textColor: Colors.black,
                          color: Colors.white,
                          child: new Text('Resend otp',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0
                            ),
                          ),
                        ),
                      ) : ButtonTheme(
                        height: 45.0,
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text('Resend otp',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0
                                ),
                              ),
                              SizedBox(width: 10.0,),
                              new Text("0:$display",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ) ,

                    SizedBox(height: 10.0,),



                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  _verifyEmailOtp(){
    print(otpController.text);
    print(getOtp);
    if(otpController.text == getOtp)
    {
      setState(() {
      });
        var route = MaterialPageRoute(builder: (BuildContext context) =>
            Createpassword(otp: getOtp),
        );
        Navigator.of(context).pushReplacement(route);

    }else{
      Toast.show('Please enter valid otp', context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,);
    }
  }


}
