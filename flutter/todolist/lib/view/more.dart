import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/main.dart';

class MorePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MorePageState();
  }
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: ListView(
        children: [
          ListTile(
            title: Text("다크모드", style: mediumStyle,),

            trailing: CupertinoSwitch(
              value: darkMode,
              onChanged: (t){
                setState(() {
                  darkMode = t;
                  setDarkMode();
                });
              },

            ),

          )
        ],
      )
    );
  }
}