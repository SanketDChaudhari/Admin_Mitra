import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:flutter_svg/svg.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool obscureText = true;
  bool _isSigningIn = false;

  signIn() async {
    setState(() {
      _isSigningIn = true;
    });
    try {
      if (email.text == "admin@gmail.com" && password.text == "admin@123") {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect email or password')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          title: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold),),
          gradient: const LinearGradient(
            colors: [
              Color(0xff329d9c),
              Color(0xff56C596),
            ],
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 130),
                  child: SvgPicture.asset(
                    'assets/images/wave.svg',
                    width: MediaQuery.of(context).size.width,
                  ),
                ),

                Expanded(
                  child: Image.asset(
                    'assets/images/green_back.png',
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height-130,
                  ),
                ),

              ],
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/logo.png',
                width: 160,
                height: 160,
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child:Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                height: MediaQuery.of(context).size.height-330,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Column(
                    children: [

                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text("Sign In", style: TextStyle(
                          fontSize: 28,
                          color: Color(0xff329D9C),
                          fontWeight: FontWeight.bold,
                        ),),
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        height: 50,
                        child: TextField(
                          controller: email,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.email, color: Color(0xff329D9C),),
                            label: Text("Email", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // color: Color(0xff56C596),
                              color: Color(0xff329D9C),
                            ),),
                            hintText: 'Enter email',
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff56C596), width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff329D9C), width : 2.0),
                            ),
                            border: OutlineInputBorder(),
                            fillColor: Color(0xffCFF4D2),
                            filled: true,
                          ),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        height: 50,
                        child:  TextField(
                          obscureText: obscureText,
                          controller: password,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureText ? Icons.visibility : Icons.visibility_off,
                                color: const Color(0xff329D9C),
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                            ),
                            label: const Text(
                              "Password",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff329D9C),
                              ),
                            ),
                            hintText: 'Enter password',
                            hintStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff329D9C), width: 1.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff329D9C), width: 2.0),
                            ),
                            border: const OutlineInputBorder(),
                            fillColor: const Color(0xffCFF4D2),
                            filled: true,
                          ),
                        ),
                      ),

                      // InkWell(
                      //   onTap: () {
                      //     Get.to(const Forgot());
                      //   },
                      //   child: const Align(
                      //     alignment: Alignment.centerRight,
                      //     child: Text("Forgot Password?", style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 18,
                      //       color: Color(0xff329D9C),
                      //     ),),
                      //   ),
                      // ),

                      Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 15),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xff329d9c),
                                Color(0xff7BE495),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.transparent)
                              ),
                              onPressed: _isSigningIn ? null : signIn,
                              child: _isSigningIn ? const CircularProgressIndicator() : const Text("SIGN IN", style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18),)
                          )
                      ),

                      // InkWell(
                      //   onTap: ()=>Get.to(const Signup()),
                      //   child: const Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: Text("Don't have account? SignUp", style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 16,
                      //       color: Color(0xff329D9C),
                      //       decoration: TextDecoration.underline,
                      //     ),),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}
