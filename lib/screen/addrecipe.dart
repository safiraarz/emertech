import 'package:flutter/material.dart';
import 'package:flutter_safira_week2/class/recipe.dart';

class AddRecipe extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddRecipeState();
  }
}

class _AddRecipeState extends State<AddRecipe> {
  final TextEditingController _recipe_name_cont = TextEditingController();
  final TextEditingController _recipe_desc_cont = TextEditingController();
  final TextEditingController _recipe_photo_cont = TextEditingController();
  int _charleft = 200;
  String? _recipe_category;

  void iniState() {
    super.initState();
    _recipe_name_cont.text = "Your Food Name";
    _recipe_desc_cont.text = "Recipe of...";
    int _charleft = 200 - _recipe_desc_cont.text.length;
  }

  Color getButtonColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Add Recipe")),
        body: Column(
          children: [
            TextField(
              controller: _recipe_name_cont,
              onChanged: (v) {
                print(_recipe_name_cont.text);
                print(v);
              },
            ),
            TextField(
              controller: _recipe_desc_cont,
              onChanged: (v) {
                setState(() {
                  _charleft = 200 - v.length;
                });
              },
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: null,
            ),
            Text("char left : $_charleft"),
            TextField(
              controller: _recipe_photo_cont,
              onSubmitted: (v) {
                setState(() {});
              },
            ),
            Image.network(_recipe_photo_cont.text),
            DropdownButton(
                hint: Text("Select Your Category"),
                value: _recipe_category,
                items: [
                  DropdownMenuItem(
                    child: Text("Traditional"),
                    value: "Traditional",
                  ),
                  DropdownMenuItem(
                    child: Text("Japannese"),
                    value: "Japannese",
                  ),
                  DropdownMenuItem(
                    child: Text("Korean"),
                    value: "Korean",
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    _recipe_category = value!;
                  });
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text('Choose'),
                            content: Text('You Choose $_recipe_category'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ));
                }),
            ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(5),
                  backgroundColor:
                      MaterialStateProperty.resolveWith(getButtonColor),
                ),
                onPressed: () {
                  var b = recipes[2];
                  recipes.remove(b);
                  recipes.add(Recipe(
                      id: recipes.length,
                      name: _recipe_name_cont.text,
                      photo: _recipe_photo_cont.text,
                      desc: _recipe_desc_cont.text,
                      category: _recipe_category.toString()));
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text('Add Recipe'),
                            content: Text('Recipe successfully added'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ));
                },
                child: Text('SUBMIT'))
          ],
        ));
  }
}
