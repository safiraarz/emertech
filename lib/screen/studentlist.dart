import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_safira_week2/screen/studentdetail.dart';

class StudentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Random randomNum = new Random();
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
      ),
      body: Center(
          child: Column(children: [
        Text("This is the student list"),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentDetail(randomNum.nextInt(70))));
            },
            child: Text("Student " + randomNum.nextInt(70).toString())),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentDetail(randomNum.nextInt(70))));
            },
            child: Text("Student " + randomNum.nextInt(70).toString())),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentDetail(randomNum.nextInt(70))));
            },
            child: Text("Student " + randomNum.nextInt(70).toString()))
      ])),
    );
  }
}
