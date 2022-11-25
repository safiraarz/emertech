import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_safira_week2/class/pop_actors.dart';
import 'package:http/http.dart' as http;

class PopularActor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PopularActorState();
  }
}

class _PopularActorState extends State<PopularActor> {
  String _temp = 'waiting API respond...';
  List<PopActors> actors = [];

  Future<String> fetchData() async {
    final response = await http.get(
        Uri.https("ubaya.fun", '/flutter/160419158/movies/get_actors.php'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  // bacaData() {
  //   Future<String> data = fetchData();
  //   data.then((value) {
  //     setState(() {
  //       _temp = value;
  //     });
  //   });
  // }

  bacaData() {
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var act in json['data']) {
        PopActors pa = PopActors.fromJson(act);
        actors.add(pa);
      }
      setState(() {
        _temp = actors[0].name;
      });
    });
  }

  Widget DaftarPopActors(PopAct) {
    if (PopAct != null) {
      return ListView.builder(
          itemCount: PopAct.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.person, size: 30),
                  title: Text(PopAct[index].name),
                ),
              ],
            ));
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  Widget DaftarPopActors2(String data) {
    List<PopActors> PAs2 = [];
    Map json = jsonDecode(data);
    for (var act in json['data']) {
      PopActors pa = PopActors.fromJson(act);
      PAs2.add(pa);
    }
    return ListView.builder(
        itemCount: PAs2.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new Card(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person, size: 30),
                title: Text(PAs2[index].name),
              ),
            ],
          ));
        });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Popular Actor'),
        ),
        body: ListView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: DaftarPopActors(actors),
          ),
          Container(
              height: MediaQuery.of(context).size.height / 2,
              child: FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DaftarPopActors2(snapshot.data.toString());
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }))
        ]));
  }
}
