import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _top_user = "";

Future<String> checkTopUser() async {
  final prefs = await SharedPreferences.getInstance();
  String top_user = prefs.getString("top_user") ?? '';
  return top_user;
}

class LdBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LdBoard();
  }
}

class _LdBoard extends State<LdBoard> {
  @override
  void initState() {
    super.initState();
    checkTopUser().then((result) {
      if (result == '') {
        _top_user = 'No current leaderboard';
      } else {
        _top_user = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: Center(
        child: Text(
          '$_top_user',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
