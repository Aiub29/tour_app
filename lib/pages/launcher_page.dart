import 'package:flutter/material.dart';
import 'package:tour_app/auth/firebase_authentication.dart';
import 'package:tour_app/pages/home_page.dart';
import 'package:tour_app/pages/login_page.dart';
class LauncherPage extends StatefulWidget {
  static final routName= '/launcher';
  @override
  _LauncherPageState createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  FirebaseAuthenticationService authenticationService;
  @override
  void initState() {
   authenticationService=FirebaseAuthenticationService();
  Future.delayed(Duration.zero,(){
    authenticationService.currentUser == null ?
    Navigator.pushReplacementNamed(context, LoginPage.routName) :
    Navigator.pushReplacementNamed(context, HomePage.routName);
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
