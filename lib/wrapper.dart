import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:admin_mitra/login.dart';
import 'package:admin_mitra/home.dart';

class Wrapper extends StatefulWidget {
  const Wrapper ({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const Home(); // Navigate to Home widget if user is logged in
          } else {
            return const Login(); // Navigate to Login widget if user is not logged in
          }
        },
      ),
    );
  }
}
