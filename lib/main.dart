import 'package:flutter/material.dart';
import 'package:flutter_safira_week2/screen/about.dart';
import 'package:flutter_safira_week2/screen/addrecipe.dart';
import 'package:flutter_safira_week2/screen/animation.dart';
import 'package:flutter_safira_week2/screen/basket.dart';
import 'package:flutter_safira_week2/screen/history.dart';
import 'package:flutter_safira_week2/screen/home.dart';
import 'package:flutter_safira_week2/screen/leaderboard_quiz.dart';
import 'package:flutter_safira_week2/screen/login.dart';
import 'package:flutter_safira_week2/screen/my_courses.dart';
import 'package:flutter_safira_week2/screen/newpopmovie.dart';
import 'package:flutter_safira_week2/screen/popular_actors.dart';
import 'package:flutter_safira_week2/screen/popular_movie.dart';
import 'package:flutter_safira_week2/screen/quiz.dart';
import 'package:flutter_safira_week2/screen/search.dart';
import 'package:flutter_safira_week2/screen/studentlist.dart';
import 'package:flutter_safira_week2/screen/viewcart.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'about': (context) => About(),
        'basket': (context) => Basket(),
        'student_list': (context) => StudentList(),
        'my_course': (context) => MyCourse(),
        'add_recipe': (context) => AddRecipe(),
        'quiz': (context) => Quiz(),
        'leaderboard': (context) => LdBoard(),
        'animation': (context) => Animasi(),
        'popular_mov': (context) => PopularMovie(),
        'popular_act': (context) => PopularActor(),
        'new_pop_movie': (context) => NewPopMovie(),
        'cart': (context) => ViewCart(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _currentIndex = 0;
  final List<Widget> _screens = [Home(), Search(), History()];
  final List<String> _title = ['Home', 'Screen', 'History'];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    main();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(_title[_currentIndex])),
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      drawer: myDrawer(),
      persistentFooterButtons: <Widget>[
        ElevatedButton(
          onPressed: () {},
          child: Icon(Icons.skip_previous),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Icon(Icons.skip_next),
        ),
      ],
      bottomNavigationBar: myBottomNavBar(),
    );
  }

  Center myBody(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }

  BottomNavigationBar myBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      fixedColor: Colors.teal,
      items: [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "Search",
          icon: Icon(Icons.search),
        ),
        BottomNavigationBarItem(
          label: "History",
          icon: Icon(Icons.history),
        ),
      ],
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Drawer myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text("safiraarinta"),
              accountEmail: Text("s160419158@student.ubaya.ac.id"),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150"))),
          // ListTile(
          //   title: new Text("Inbox"),
          //   leading: new Icon(Icons.inbox),
          // ),
          ListTile(
              title: new Text("My Basket"),
              leading: new Icon(Icons.shopping_basket),
              onTap: () {
                // Navigator.push(
                //   context, MaterialPageRoute(builder: (context) => About()));
                Navigator.pushNamed(context, "basket");
              }),
          ListTile(
              title: Text("Add Recipe"),
              leading: Icon(
                Icons.add,
                size: 25,
              ),
              onTap: () {
                Navigator.pushNamed(context, "add_recipe");
              }),
          ListTile(
              title: Text("About"),
              leading: Icon(Icons.help),
              onTap: () {
                // Navigator.push(
                //   context, MaterialPageRoute(builder: (context) => About()));
                Navigator.pushNamed(context, "about");
              }),
          ListTile(
              title: Text("Student"),
              leading: Icon(
                Icons.boy_rounded,
                size: 35,
              ),
              onTap: () {
                Navigator.pushNamed(context, "student_list");
              }),
          ListTile(
              title: Text("Course"),
              leading: Icon(
                Icons.book,
                size: 25,
              ),
              onTap: () {
                Navigator.pushNamed(context, "my_course");
              }),
          // ListTile(
          //     title: Text("Quiz"),
          //     leading: Icon(
          //       Icons.quiz,
          //       size: 25,
          //     ),
          //     onTap: () {
          //       Navigator.pushNamed(context, "quiz");
          //     }),
          // ListTile(
          //     title: Text("Leaderboard"),
          //     leading: Icon(
          //       Icons.leaderboard,
          //       size: 25,
          //     ),
          //     onTap: () {
          //       Navigator.pushNamed(context, "leaderboard");
          //     }),
          // ListTile(
          //     title: Text("Animation"),
          //     leading: Icon(
          //       Icons.animation,
          //       size: 25,
          //     ),
          //     onTap: () {
          //       Navigator.pushNamed(context, "animation");
          //     }),
          ListTile(
              title: Text("Popular Actor"),
              leading: Icon(
                Icons.person,
                size: 25,
              ),
              onTap: () {
                Navigator.pushNamed(context, "popular_act");
              }),
          ListTile(
              title: Text("Add Popular Movie"),
              leading: Icon(
                Icons.movie,
                size: 25,
              ),
              onTap: () {
                Navigator.pushNamed(context, "new_pop_movie");
              }),
          ListTile(
              title: Text("Popular Movie"),
              leading: Icon(
                Icons.movie,
                size: 25,
              ),
              onTap: () {
                Navigator.pushNamed(context, "popular_mov");
              }),
          ListTile(
              title: Text("Cart"),
              leading: Icon(
                Icons.shopping_cart,
                size: 25,
              ),
              onTap: () {
                Navigator.pushNamed(context, "cart");
              }),
          ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout),
              onTap: () {
                doLogout();
              }),
        ],
      ),
    );
  }
}
