import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:http/http.dart' as http;

class NewPopMovie extends StatefulWidget {
  @override
  State<NewPopMovie> createState() => _NewPopMovieState();
}

class _NewPopMovieState extends State<NewPopMovie> {
  final _formkey = GlobalKey<FormState>();
  final _controllerDate = TextEditingController();

  String _title = "";
  String _homepage="";
  String _overview="";
  int _runtime = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Popular Movie"),
        ),
      body: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  ),
                onChanged: (value) {
                  _title = value; 
                  },
                validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul harus diisi';
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
                      _homepage = value;
                    },
                    validator: (value) {
                      if (value == null || !Uri.parse(value).isAbsolute) {
                        return 'alamat homepage salah';
                        }
                        return null;
                        }
                  )
                ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Overview',
                ),
                onChanged: (value) {
                  _overview = value;
                },
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 6,
                validator: (value) {
                  if(value == null || value.length <10){
                    return "Overview Minimal 10 Karakter";
                  }
                  return null;
                },
                )
              ),
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
                        controller: _controllerDate,
                        )
                ),
                ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2200))
                      .then((value) {
                        if(value != null){
                          setState(() {
                            _controllerDate.text =
                              value.toString().substring(0, 10);
                                });
                              }
                            });
                          },
                          child: Icon(
                            Icons.calendar_today_sharp,
                            color: Colors.white,
                            size: 24.0,
                            ))
                        ],
                      )
              ),
              NumberPicker(
                value: _runtime,
                axis: Axis.horizontal,
                minValue: 50,
                maxValue: 300,
                itemHeight: 30,
                itemWidth: 60,
                step: 1,
                onChanged: (value) => 
                 setState(() => _runtime = value),
                 decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  ),
              ),

            Padding( 
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState != null && !_formkey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Harap Isian diperbaiki')));
                    }
                    else{
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

  //FUNCTION SUBMIT   
  void submit() async {
    final response = await http.post(
      Uri.parse("https://ubaya.fun/flutter/160419158/movies/newmovie.php"),
      body: {
        'title': _title,
        'overview': _overview,
        'homepage': _homepage,
        'release_date': _controllerDate.text,
        'runtime':_runtime.toString(),
        });
      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sukses Menambah Data')));
          }
      } else {
        throw Exception('Failed to read API');
      }
    }
}