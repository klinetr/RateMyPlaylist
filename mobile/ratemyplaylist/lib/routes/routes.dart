import 'package:flutter/material.dart';
//import 'package:flutter_application_1/screens/AddFriendPopup.dart';
import 'package:ratemyplaylist/screens/LoginScreen.dart';
//import 'package:flutter_application_1/screens/SpotifyLoginScreen.dart';
import 'package:ratemyplaylist/screens/RegisterScreen.dart';
import 'package:ratemyplaylist/screens/MainScreen.dart';


class Routes {
  static const String LOGINSCREEN = '/login';
  static const String REGISTERSCREEN = '/register';
  static const String MAINSCREEN = '/';
  static const String ADDFRIENDPOPUP = '/addfriend';
  static const String SPOTIFYLOGIN = '/spotifylogin';


  static Map<String, Widget Function(BuildContext)> get getroutes => {
    MAINSCREEN:(context) => MainScreen(),
    LOGINSCREEN:(context) => LoginScreen(),
    REGISTERSCREEN:(context) => RegisterScreen(),
   // ADDFRIENDPOPUP:(context) => AddFriendPopupScreen(),
   // SPOTIFYLOGIN:(context) => SpotifyLoginScreen(),
  };
}
