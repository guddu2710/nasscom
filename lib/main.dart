import 'package:event_management/ui/chat/chat.dart';
import 'package:event_management/ui/chat/chatScreen.dart';
import 'package:event_management/ui/dashboard/dashboard.dart';
import 'package:event_management/ui/events/about/attendess.dart';
import 'package:event_management/ui/events/about/exhibitor.dart';
import 'package:event_management/ui/events/about/speaker.dart';
import 'package:event_management/ui/events/about/sponser.dart';
import 'package:event_management/ui/events/attendeesList.dart';
import 'package:event_management/ui/events/eventDetails.dart';
import 'package:event_management/ui/events/eventList.dart';
import 'package:event_management/ui/events/eventpage.dart';
import 'package:event_management/ui/events/exhibitorList.dart';
import 'package:event_management/ui/events/interestedEvent.dart';
import 'package:event_management/ui/events/pasteventdetails.dart';
import 'package:event_management/ui/events/scanScreen.dart';
import 'package:event_management/ui/events/speakersList.dart';
import 'package:event_management/ui/events/sponserList.dart';
import 'package:event_management/ui/login/createAccount.dart';
import 'package:event_management/ui/login/forgetpassword.dart';
import 'package:event_management/ui/login/login.dart';
import 'package:event_management/ui/login/nasscommember.dart';
import 'package:event_management/ui/notification/notification.dart';
import 'package:event_management/ui/profileSettings/profile.dart';
import 'package:event_management/ui/profileSettings/profileSettings.dart';
import 'package:event_management/ui/login/signup.dart';
import 'package:event_management/ui/session/ask_question.dart';
import 'package:event_management/ui/session/sessionDetails.dart';
import 'package:event_management/ui/session/sessionDetailspast.dart';
import 'package:event_management/ui/splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xffc00e34),
        primaryIconTheme:IconThemeData(color: Colors.white),
        accentColor: Colors.redAccent,
        disabledColor: Colors.grey,
          unselectedWidgetColor:Colors.white,

          accentIconTheme: IconThemeData(color: Color(0xffc00e34))
      ),
      debugShowCheckedModeBanner:false,
      home:SplashScreen(),
      routes: <String,WidgetBuilder>{
        '/dashboard':(BuildContext context)=> new Dashboard(),
        '/login':(BuildContext context)=>new Login(),
        '/signUp':(BuildContext context)=>new SignUp(),
        '/eventList':(BuildContext context)=>EventList(),
        '/notificationpage':(BuildContext context)=>Notificationpage(),
        '/forgotPassword':(BuildContext context)=>ForgotPassword(),
        '/profileSettings':(BuildContext context)=>ProfileSettings(),
        '/scanScreen':(BuildContext context)=>ScanScreen(),
        '/chatScreen':(BuildContext context)=>Chat(),
        '/attendeesList':(BuildContext context)=>AttendeesList(),
        '/interestedEvents':(BuildContext context)=>InterestedEvents(),
        '/profile':(BuildContext context)=>Profile(),
        '/eventDetails':(BuildContext context)=>EventDetails(),
//        '/eventDetails':(BuildContext context)=>EventPage(),
        '/createAccount':(BuildContext context)=>CreateAccount(),
        '/sponserList':(BuildContext context)=>SponserList(),
        '/speakersList':(BuildContext context)=>SpeakersList(),
        '/exhibitorList':(BuildContext context)=>ExhibitorList(),
        '/sessionDetails':(BuildContext context)=>SessionDetails(),
        '/exhibitor':(BuildContext context)=>Exhibitors(),
        '/sponser':(BuildContext context)=>Sponser(),
        '/attendess':(BuildContext context)=>AttendessD(),
        '/speaker':(BuildContext context)=>Speakers(),
        '/pastEventDetails':(BuildContext context)=>PastEventDetails(),
        '/pastSessionDetails':(BuildContext context)=>PastSessionDetails(),
        '/askquestion':(BuildContext context)=>Askquestion()
      },
    );
  }
}


