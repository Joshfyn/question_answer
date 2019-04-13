import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginRegister.dart';
import 'Home.dart';
import 'Authentication.dart';


class Mapping extends StatefulWidget {

  final AuthImplementation auth;

  Mapping(
  {
    this.auth,
}
      );

  State<StatefulWidget> createState(){

  return _MappingState();

  }
}


enum AuthStatus{

  notSignedIn,
  signedIn,

}

class _MappingState extends State<Mapping>{

  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {

    super.initState();
    widget.auth.getCurrentUser().then((firebaseUserId){

      setState(() {
        authStatus = firebaseUserId == null ? AuthStatus.notSignedIn:AuthStatus.signedIn;
      });


    });

  }


  void _signedIn(){

    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signOut(){

    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }


  @override
  Widget build(BuildContext context) {

    switch(authStatus){

      case AuthStatus.notSignedIn:
        return new LoginRegisterPage(
          auth:widget.auth,
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return new Home(
          auth:widget.auth,
          onSignedOut: _signOut,
        );



    }



    return null;
  }

}