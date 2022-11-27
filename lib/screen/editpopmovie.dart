import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_safira_week2/class/genre.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_safira_week2/class/pop_movie.dart';
import 'package:http/http.dart' as http;

class EditPopMovie extends StatefulWidget {
  int movieID;
  EditPopMovie({Key? key, required this.movieID}) : super(key: key);
  @override
  EditPopMovieState createState() {
    return EditPopMovieState();
  }
}

class EditPopMovieState extends State<EditPopMovie> {
  final _formKey = GlobalKey<FormState>();
  PopMovie? pm;
  int _runtime = 100;
  TextEditingController _titleCont = TextEditingController();
  TextEditingController _homepageCont = TextEditingController();
  TextEditingController _overviewCont = TextEditingController();
  TextEditingController _releaseDate = TextEditingController();

  var _value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Popular Movie"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(widget.movieID.toString()),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    onChanged: (value) {
                      pm?.title = value;
                    },
                    controller: _titleCont,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'judul harus diisi';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Homepage',
                    ),
                    onChanged: (value) {
                      pm?.homepage = value;
                    },
                    controller: _homepageCont,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'homepage harus diisi';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Overview',
                    ),
                    onChanged: (value) {
                      pm?.overview = value;
                    },
                    controller: _overviewCont,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 6,
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Release Date',
                        ),
                        controller: _releaseDate,
                      )),
                      ElevatedButton(
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2200))
                                .then((value) {
                              setState(() {
                                _releaseDate.text =
                                    value.toString().substring(0, 10);
                              });
                            });
                          },
                          child: Icon(
                            Icons.calendar_today_sharp,
                            color: Colors.white,
                            size: 24.0,
                          ))
                    ],
                  )),
              NumberPicker(
                value: _runtime,
                axis: Axis.horizontal,
                minValue: 50,
                maxValue: 300,
                itemHeight: 30,
                itemWidth: 60,
                step: 1,
                onChanged: (value) {
                  pm?.runtime = value;
                  setState(() => _runtime = value);
                },
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                ),
              ),
              Padding(padding: EdgeInsets.all(10), child: Text('Genre:')),
              Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: pm?.genres?.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new Row(
                        children: [
                          Text(pm?.genres?[index]['genre_name']),
                          ElevatedButton(
                              onPressed: () {
                                deleteGenre(pm!.genres![index]['genre_id']);
                              },
                              child: new Icon(Icons.delete))
                        ],
                      );
                    }),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: comboGenre),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    var state = _formKey.currentState;
                    if (state == null || !state.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Harap Isian diperbaiki')));
                    } else {
                      submit();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ));
  }

  void deleteGenre(genreId) async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419158/movies/deletemoviegenre.php"),
        body: {
          'genre_id': genreId.toString(),
          'movie_id': widget.movieID.toString()
        });
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menghapus Genre')));
        setState(() {
          bacaData();
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  void addGenre(genre_id) async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419158/movies/addmoviegenre.php"),
        body: {
          'genre_id': genre_id.toString(),
          'movie_id': widget.movieID.toString()
        });
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses menambah genre')));
        setState(() {
          bacaData();
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  Widget comboGenre = Text('tambah genre');

  void generateComboGenre() {
    //widget function for city list
    List<Genre> genres;
    var data = daftarGenre();
    data.then((value) {
      genres = List<Genre>.from(value.map((i) {
        return Genre.fromJSON(i);
      }));

      comboGenre = DropdownButton(
          dropdownColor: Colors.grey[100],
          hint: Text("tambah genre"),
          isDense: false,
          items: genres.map((gen) {
            return DropdownMenuItem(
              child: Column(children: <Widget>[
                Text(gen.genre_name, overflow: TextOverflow.visible),
              ]),
              value: gen.genre_id,
            );
          }).toList(),
          onChanged: (value) {
            addGenre(value);
          });
    });
  }

  Future<List> daftarGenre() async {
    Map json;
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419158/movies/genrelist.php"),
        body: {'movie_id': widget.movieID.toString()});

    if (response.statusCode == 200) {
      print(response.body);
      json = jsonDecode(response.body);
      return json['data'];
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<String> fetchData() async {
    final response = await http.post(
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
      pm = PopMovie.fromJson(json['data']);
      print(value);
      setState(() {
        _titleCont.text = pm!.title;
        _homepageCont.text = pm!.homepage;
        _overviewCont.text = pm!.overview;
        _releaseDate.text = pm!.release_date;
        _runtime = pm!.runtime!;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bacaData();
    setState(() {
      generateComboGenre();
    });
  }

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419158/movies/updatemovie.php"),
        body: {
          'title': pm!.title,
          'overview': pm!.overview,
          'homepage': pm!.homepage,
          'release_date': pm!.release_date,
          'runtime': pm!.runtime.toString(),
          'movie_id': widget.movieID.toString()
        });
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses mengubah Data')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }
}
