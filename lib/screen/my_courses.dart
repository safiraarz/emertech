import 'package:flutter/material.dart';
import 'package:flutter_safira_week2/model/course.dart';
import 'package:flutter_safira_week2/screen/course_detail.dart';

class MyCourse extends StatelessWidget {
  MyCourse({super.key});

  var course = courseList;

  Widget MyCourses() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: courseList.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailCourse(
                            id: index + 1,
                          )));
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),
              child:Center(child: Text("${courseList[index + 1]!['pShortName']!}" " (${courseList[index + 1]!['pKP']!})"))
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("My Course")),
        body: SafeArea(
            child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  Divider(
                    height: 20,
                  ),
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Container(
                      width: 120,
                      height: 120,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        'https://my.ubaya.ac.id/img/mhs/160419158_m.jpg',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Text(
                      'Safira Arinta Azzahra',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text("160419158"),
                  Text("Informatika"),
                  Text("Gasal 2022-2023"),
                  Divider(
                    height: 20,
                  ),
                  Center(child: MyCourses())
                ]))));
  }
}
