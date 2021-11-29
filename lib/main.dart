import 'package:authentification/Login.dart';
import 'package:authentification/SignUp.dart';
import 'package:authentification/Start.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'widget/button_widget.dart';
import 'widget/date_picker_widget.dart';
import 'widget/date_range_picker_widget.dart';
import 'widget/datetime_picker_widget.dart';
import 'widget/time_picker_widget.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   runApp(MyApp());
   }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        primaryColor: Colors.orange
      ),
      debugShowCheckedModeBanner: false,
      home: 
    
      HomePage(),

      routes: <String,WidgetBuilder>{

        "Login" : (BuildContext context)=>Login(),
        "SignUp":(BuildContext context)=>SignUp(),
        "start":(BuildContext context)=>Start(),
      },
      
    );
  }

}



