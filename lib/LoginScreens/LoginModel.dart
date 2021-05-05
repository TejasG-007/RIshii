import 'package:flutter/foundation.dart';

class Handler extends ChangeNotifier{

  ///Used to Hide and Show the Password
  bool obsecuretext = true;

  get visibility => obsecuretext;

   Hidepassword(){
    obsecuretext = !obsecuretext;
    notifyListeners();
  }



  ///Password Matcher
  bool matcher = true;
  PasswordMatcher(bool value){
     matcher=value;
     notifyListeners();
  }
  get matching => matcher;






}