class Validation {

  //  VALIDATION  START
  String validateEmail(String value)
  {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if(value.length==0){
      return "Enter Email id";}
    else if (!regex.hasMatch(value)){
      return 'Enter Valid Email';}
    else {
      return null;
    }
  }

  String loginEmail(String value)
  {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please Enter Validate Email Address';
    else
      return null;
  }
  String validatePassword(String value)
  {
    if(value.length==0){
      return "Please Enter  Password";

    }
    else if(value.length < 4)
    {
      return "Password length should be more than 4 character";
    }
    else
    {
      return null;
    }
  }

  String validatePhone(String value)
  {
    if(value.length==0){
      return "Please Enter Phone no.";

    }
    else if(value.length < 10)
    {
      return "Minimun 10 digits";
    }
    else
    {
      return null;
    }
  }
//  VALIDATION  END
}
