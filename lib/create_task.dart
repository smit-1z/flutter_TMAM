import 'package:authentification/main.dart';
import 'package:authentification/todo.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widget/button_widget.dart';
import 'widget/date_picker_widget.dart';
import 'widget/date_range_picker_widget.dart';
import 'widget/datetime_picker_widget.dart';
import 'widget/time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Date (Range) & Time';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(
      primaryColor: Colors.black,
    ),
    home: MainPage(),
  );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  DatePickerWidget date= DatePickerWidget();
  TimePickerWidget time= TimePickerWidget();
  Characters task= Characters("");
  var myController = TextEditingController();






  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: buildBottomBar(),
    body: buildPages(),
  );

  Widget buildBottomBar() {
    final style = TextStyle(color: Colors.white);

    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
          icon: Text('DatePicker', style: style),
          title: Text('Basic'),
        ),
        BottomNavigationBarItem(
          icon: Text('DatePicker', style: style),
          title: Text('Advanced'),
        ),
      ],
      onTap: (int index) => setState(() => this.index = index),
    );
  }

  Widget buildPages() {
    switch (index) {
      case 0:
        return Scaffold(
          backgroundColor: Colors.orange,
          body: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                date=DatePickerWidget(),
                const SizedBox(height: 24),
                time=TimePickerWidget(),
                const SizedBox(height: 24),
                Container(
                  child: TextFormField(
                    validator: (input) {
                      if (input.isEmpty) return 'Enter task';
                    },
                    controller: myController,


                    decoration: InputDecoration(
                      labelText: 'Enter Task',

                    ),
                  ),

                ),

                SizedBox(height: 30.0),
                Text(
                  'Select Priority of the Task',
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 30.0),
                CustomRadioButton(
                  elevation: 0,
                  absoluteZeroSpacing: true,
                  unSelectedColor: Theme.of(context).canvasColor,
                  buttonLables: [
                    'high',
                    'mid',
                    'low',
                  ],
                  buttonValues: [
                    "HIGH",
                    "MID",
                    "LOW",
                  ],
                  buttonTextStyle: ButtonTextStyle(
                      selectedColor: Colors.white,
                      unSelectedColor: Colors.black,
                      textStyle: TextStyle(fontSize: 16)),
                  radioButtonValue: (value) {
                    print(value);
                  },
                  selectedColor: Theme.of(context).accentColor,
                ),


                SizedBox(height: 70.0),
                  RaisedButton(
                    padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                    onPressed:() {
                      var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new MyApp1(value: myController.text),
                      );
                      Navigator.of(context).push(route);

                    },
                    child: Text('Add Task',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                
      ],
            ),
          ),
        ); break;



      case 1:
        return Scaffold(
          backgroundColor: Colors.orange,
          body: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DatetimePickerWidget(),
              ],
            ),
          ),
        );
      default:
        return Container();
    }
  }

}