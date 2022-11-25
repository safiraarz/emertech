import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_safira_week2/class/pop_movie.dart';
import 'package:flutter_safira_week2/screen/detailpop.dart';
import 'package:http/http.dart' as http;

class PopularMovie extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PopularMovieState();
  }
}

class _PopularMovieState extends State<PopularMovie> {
  String _temp = 'waiting API respond...';
  List<PopMovie> movies = [];

  String _txtcari = "";

  Future<String> fetchData() async {
    // final response = await http.get(
    //     Uri.https("ubaya.fun", '/flutter/160419158/movies/get_movies.php'));
    final response = await http.post(
        // Uri.parse("https://ubaya.fun/hybrid/160419158/movies/movielist.php"),
        Uri.parse("https://ubaya.fun/hybrid/daniel/movielist.php"),
        body: {'cari': _txtcari});

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
    movies.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var mov in json['data']) {
        PopMovie pm = PopMovie.fromJson(mov);
        movies.add(pm);
      }
      // setState(() {
      //   _temp = movies[0].title;
      // });
    });
  }

  Widget DaftarPopMovie(PopMovs) {
    if (PopMovs != null) {
      return ListView.builder(
          itemCount: PopMovs.length,
          itemBuilder: (BuildContext ctxt, int index) {
            // return Text(PopMovs[index].title.toString());
            return Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.movie, size: 30),
                  title: Text(PopMovs[index].title),
                  subtitle: Text(PopMovs[index].overview),
                ),
              ],
            ));
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  Widget DaftarPopMovie2(String data) {
    List<PopMovie> PMs2 = [];
    Map json = jsonDecode(data);
    for (var mov in json['data']) {
      PopMovie pm = PopMovie.fromJson(mov);
      PMs2.add(pm);
    }
    return ListView.builder(
        itemCount: PMs2.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new Card(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPop(movieID: PMs2[index].id),
                    ),
                  );
                },
                leading: const Icon(Icons.movie, size: 30),
                // title: Text(PMs2[index].title),
                title: GestureDetector(
                  child: Text(PMs2[index].title),
                ),
                subtitle: Text(PMs2[index].overview),
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
          title: const Text('Popular Movie'),
        ),
        body: ListView(children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.search),
              labelText: 'Judul mengandung kata:',
            ),
            onFieldSubmitted: (value) {
              // _txtcari = value;
              // bacaData();
              setState(() {
                _txtcari = value;
              });
            },
          ),
          // Container(
          //   height: MediaQuery.of(context).size.height,
          //   child: DaftarPopMovie(movies),
          // ),
          Container(
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    // if (snapshot.hasData) {
                    //   // return Text(snapshot.data.toString());
                    //   return DaftarPopMovie2(snapshot.data.toString());
                    // } else {
                    //   return const Center(child: CircularProgressIndicator());
                    // }
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text("Error! ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        return DaftarPopMovie2(snapshot.data.toString());
                      } else {
                        return const Text("No data");
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }))
        ]));
  }
}
