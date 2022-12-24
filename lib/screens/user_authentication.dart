import 'package:flutter/material.dart';
import 'package:truckcopy/screens/login.dart';
import 'package:truckcopy/services/user_authentication.dart';

class UserAuthentication extends StatefulWidget {
  const UserAuthentication({super.key});

  @override
  State<UserAuthentication> createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {
  bool authenticated = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      authenticated = UserAuthenticationService().userLoggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return authenticated ? Container() : Login();
  }
}
