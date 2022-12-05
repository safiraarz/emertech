import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_safira_week2/class/cart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class ViewCart extends StatefulWidget {
  const ViewCart({Key? key}) : super(key: key);
  @override
  _ViewCartState createState() => _ViewCartState();
}

final dbHelper = DatabaseHelper.instance;
List? _rsCart;

String activeUser = "";

class _ViewCartState extends State<ViewCart> {
  _bacaData() async {
    _rsCart = (await dbHelper.viewCart())!;
    setState(() {});
  }

  Widget _itemCart(index) {
    return Column(children: <Widget>[
      Text(_rsCart![index]['title']),
      Row(
        children: [
          Text('jumlah=' + _rsCart![index]['jumlah']),
          ElevatedButton(
              onPressed: () {
                dbHelper
                    .tambahJumlah(_rsCart?[index]['movie_id'])
                    .then((value) => _bacaData());
              },
              child: Text("+")),
          ElevatedButton(
              onPressed: () {
                dbHelper
                    .kurangJumlah(_rsCart?[index]['movie_id'])
                    .then((value) => _bacaData());
              },
              child: Text("-"))
        ],
      ),
      Divider(),
    ]);
  }

  void _submit() async {
    _rsCart = await dbHelper.viewCart();
    String items = "";
    _rsCart?.forEach((item) {
      items = items +
          item['movie_id'].toString() +
          ',' +
          item['jumlah'].toString() +
          "|";
    });

    final response = await http.post(
        Uri.parse("http://ubaya.fun/flutter/160419158/movies/checkout.php"),
        body: {'user_id': activeUser, 'items': items});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Checkout')));
      }
    }
  }

  @override
  void initState() {
    _bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: _rsCart != null
                  ? ListView.builder(
                      itemCount: _rsCart?.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return _itemCart(index);
                      })
                  : Text('belum ada data')),
        ));
  }
}
