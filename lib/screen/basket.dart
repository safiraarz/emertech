import 'package:flutter/material.dart';
import 'package:flutter_safira_week2/class/recipe.dart';
import 'package:flutter_safira_week2/screen/itembasket.dart';

class Basket extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Basket();
  }
}

class _Basket extends State<Basket> {
    @override
  List<Widget> WidRecipes() {
    List<Widget> temp = [];
    int i = 0;
    while (i < recipes.length) {
      int index = i;
      Widget w = Card(
          margin: EdgeInsets.all(20),
          elevation: 20,
          child: Column(
            children: [
              Text(
                recipes[i].name,
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              Image.network(recipes[i].photo),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    recipes[i].category,
                  )),
              Padding(
                  padding: EdgeInsets.all(10), child: Text(recipes[i].desc)),
              ElevatedButton.icon(
                onPressed: () {
                  this.setState(() {
                    recipes.removeAt(index);
                  });
                },
                icon: Icon(Icons.delete),
                label: Text("Remove"),
              )
            ],
          ));
      temp.add(w);
      i++;
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basket'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Text('Your Basket'),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: WidRecipes(),
          ),
          Divider(
            height: 10,
          )
        ]),
      ),
    );
  }
}
