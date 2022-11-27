import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_safira_week2/class/pop_movie.dart';
import 'package:flutter_safira_week2/screen/editpopmovie.dart';
import 'package:flutter_safira_week2/screen/popular_movie.dart';
import 'package:http/http.dart' as http;

class DetailPop extends StatefulWidget {
  int movieID;
  DetailPop({super.key, required this.movieID});
  @override
  State<StatefulWidget> createState() {
    return _DetailPopState();
  }
}

class _DetailPopState extends State<DetailPop> {
  PopMovie? _pm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail of Popular Movie'),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[tampilData()]),
        ));
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Future<String> fetchData() async {
    final response = await http.post(
        // Uri.parse("https://ubaya.fun/flutter/daniel/movie.php"),
        Uri.parse("https://ubaya.fun/flutter/160419158/movies/movie.php"),
        body: {'id': widget.movieID.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      _pm = PopMovie.fromJson(json['data']);
      // print(_pm);
      print(value);
      setState(() {});
    });
  }

  void delete(int id, String title) async {
    final response = await http.get(
      Uri.parse("https://ubaya.fun/flutter/160419158/movies/deletemovie.php"),
    );
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        print(id);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sukses Menghapus Data ' + title)));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  Widget tampilData() {
    if (_pm == null) {
      return const CircularProgressIndicator();
    }
    return Card(
        elevation: 10,
        margin: const EdgeInsets.all(10),
        child: Column(children: <Widget>[
          Text(_pm!.title, style: const TextStyle(fontSize: 25)),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Text(_pm!.overview, style: const TextStyle(fontSize: 15))),
          Padding(padding: EdgeInsets.all(10), child: Text("Genre:")),
          Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _pm?.genres?.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Text(_pm?.genres?[index]['genre_name']);
                  })),
          Padding(padding: EdgeInsets.all(10), child: Text("Cast:")),
          Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _pm?.cast?.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new Text(_pm?.cast?[index]['person_name']);
                  })),
          Padding(padding: EdgeInsets.all(10), child: Text("Character name:")),
          Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _pm?.cast?.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new Text(_pm?.cast?[index]['character_name']);
                  })),
          Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                child: Text('Edit'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditPopMovie(movieID: widget.movieID),
                    ),
                  );
                },
              )),
          ElevatedButton(
              onPressed: () {
                print(_pm?.id.runtimeType);
                delete(_pm!.id, _pm!.title);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PopularMovie()));
              },
              child: new Icon(Icons.delete))
        ]));
  }
}
