import 'package:flutter/material.dart';
import 'package:flutter_safira_week2/model/course.dart';

class DetailCourse extends StatelessWidget {
  DetailCourse({super.key, required this.id});
  final int id;
  var course = courseList;

  Widget DetailCourses() {
    return SafeArea(
        child: Column(mainAxisSize: MainAxisSize.max, children: [
      Align(
        alignment: AlignmentDirectional(0, 0),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 200, 0, 20),
          child:
              Text(courseList[id]!['pLongName']!, textAlign: TextAlign.center),
        ),
      ),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),
              child: Text(courseList[id]!['pKP']!, textAlign: TextAlign.center),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),
              child: Text(courseList[id]!['pCourseTimetable']!,
                  textAlign: TextAlign.center),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),
              child: Text(courseList[id]!['pLocation']!,
                  textAlign: TextAlign.center),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),
              child: Text(courseList[id]!['pCredits']!,
                  textAlign: TextAlign.center),
            ),
          ])
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Detail Course")),
        body: Center(
          child: DetailCourses(),
        ));
  }
}
