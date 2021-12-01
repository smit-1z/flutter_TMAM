import 'package:authentification/Controllers/authentication_controller.dart';
import 'package:authentification/Controllers/providers/user_provider.dart';
import 'package:authentification/Controllers/user_controller.dart';
import 'package:authentification/models/user_model.dart';
import 'package:authentification/utils/constants.dart';
import 'package:authentification/utils/my_print.dart';
import 'package:authentification/utils/shared_pref_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:authentification/Login.dart';
import 'package:provider/provider.dart';
import 'SignUp.dart';
import 'package:google_sign_in/google_sign_in.dart';



class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> googleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final UserCredential user =
            await _auth.signInWithCredential(credential);

        await Navigator.pushReplacementNamed(context, "/");
         return user;
      } else {
        throw StateError('Missing Google Auth Token');
      }
    } else
      throw StateError('Sign in Aborted');
  }

  navigateToLogin() async {
    Navigator.pushReplacementNamed(context, "Login");
  }

  navigateToRegister() async {
    Navigator.pushReplacementNamed(context, "SignUp");
  }
  bool isSignIningInWithGoogle =  false;

  void signInWithGoogle() async {
    if (isSignIningInWithGoogle) return;

    String type = "GOOGLE";

    setState(() {
      isSignIningInWithGoogle = true;
    });

    User? user = await AuthenticationController().signInWithGoogle(context);

    if (user != null) {
      onSuccess(user, LOGIN_TYPE_GOOGLE);
    } else {
      setState(() {
        isSignIningInWithGoogle = false;
      });
    }
  }

  Future<void> onSuccess(User user, String loginType) async {
    MyPrint.printOnConsole("Login Screen OnSuccess called");

    String type = "";
    if (loginType == LOGIN_TYPE_EMAIL)
      type = "EMAIL";
    else if (loginType == LOGIN_TYPE_GOOGLE)
      type = "GOOGLE";

    UserProvider userProvider =
    Provider.of<UserProvider>(context, listen: false);
    userProvider.userid = user.uid;
    userProvider.firebaseUser = user;
    SharedPrefManager prefManager = SharedPrefManager();
    await prefManager.setString(USERID, user.uid);


    MyPrint.printOnConsole("Email:${user.email}");
    MyPrint.printOnConsole("Mobile:${user.phoneNumber}");

    bool isExist =
    await UserController().isUserExist(context, userProvider.userid!);

    if (isExist) {
      print("User Exist");

       {

        Navigator.pushReplacementNamed(context, "/");

      }
    } else {
      print("User Not Exist");

      await UserController().createNewUser(context, loginType: loginType);

      MyPrint.logOnConsole("Created:${userProvider.userModel}");
      Navigator.pushNamedAndRemoveUntil(
          context, "/", (route) => false);
    }

    setState(() {
      isSignIningInWithGoogle = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 35.0),
            Container(
              height: 400,
              child: Image(
                image: AssetImage("images/start.jpg"),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            RichText(
                text: TextSpan(
                    text: 'Welcome to ',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                  TextSpan(
                      text: 'TMAM',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange))
                ])),
            SizedBox(height: 10.0),
            Text(
              'The Task Management And Motivation App',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    onPressed: navigateToLogin,
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.orange),
                SizedBox(width: 20.0),
                RaisedButton(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    onPressed: navigateToRegister,
                    child: Text(
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.orange),
              ],
            ),
            SizedBox(height: 20.0),
            SignInButton(Buttons.Google,
                text: "Sign up with Google", onPressed: ()  {
                   signInWithGoogle();
                })
          ],
        ),
      ),
    );
  }
}
