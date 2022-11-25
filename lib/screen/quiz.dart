import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_safira_week2/class/question.dart';
import 'package:flutter_safira_week2/main.dart';
import 'dart:async';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _username = '';

Future<int> currTopScore() async {
  final prefs = await SharedPreferences.getInstance();
  int top_score = prefs.getInt("top_score") ?? 0;
  return top_score;
}

Future<String> currUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

class Quiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  int _hitung = 0;
  late Timer _timer;
  int _WAKTU_MAX = 100;
  bool _isrunning = false;
  var random = new Random();
  List<QuestionObj> questions = [];
  int _question_no = 0;
  int _score = 0;
  int _check_question = 0;

  void setTopUser(String topUser) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("top_user", topUser);
    main();
  }

  void setTopScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("top_score", score);
    main();
  }

  String formatTime(int hitung) {
    var hours = (hitung ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((hitung % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (hitung % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  void checkAnswer(String check) {
    setState(() {
      if (check == questions[_question_no].answer) {
        _score += 100;
      }
      _check_question++;
      _question_no = random.nextInt(5);
      if (_check_question == 5) finishQuiz();
      _hitung = _WAKTU_MAX;
    });
  }

  void finishQuiz() {
    _timer.cancel();
    _question_no = 0;
    currTopScore().then((int result) {
      if (result == 0) {
        setTopScore(_score);
      } else if (_score > result) {
        setTopScore(_score);
      }
    });
    checkUser().then((resultUser) {
      currTopScore().then((int resultTopScore) {
        String text = "Current top score: $resultTopScore by: $resultUser";
        setTopUser(text);
      });
    });

    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('GAME OVER'),
              content:
                  Text('Total point for 5 questions = ' + _score.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  startTimer() {
    _timer = new Timer.periodic(new Duration(milliseconds: 100), (timer) {
      setState(() {
        _hitung--;
        if (_isrunning) {
          _hitung--;
          if (_hitung < 0) {
            _check_question++;
            _hitung = _WAKTU_MAX;
            if (_check_question == 5) finishQuiz();
            _question_no = random.nextInt(5);
            // _timer.cancel();
            // _isrunning = false;
            // showDialog(context: context, builder: (BuildContext builder) => AlertDialog(
            //   title: Text("Time is up!"),
            //   content: Text("Game Over"),
            //   actions: [
            //     TextButton(onPressed: ()=> Navigator.pop(context, "OK"), child: const Text("OK")),
            //   ],
            // ));
          }
        }
        _isrunning = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkUser().then((String result) {
      if (result == '') {
        _username = "Empty";
      } else {
        _username = result;
      }
    });

    _hitung = _WAKTU_MAX;
    startTimer();
    questions.add(QuestionObj(
        "Above picture is a scene of what movie?",
        'https://media.newyorker.com/photos/59096d122179605b11ad7181/master/w_960,c_limit/Brody-The-Avengers.jpg',
        'Avengers: Age of Ultron',
        'The Incredible Hulk',
        'Captain America: The First Avenger',
        'Guardians of the Galaxy',
        'Avengers: Age of Ultron'));
    questions.add(QuestionObj(
        "Who is the name of the character?",
        'https://lrmonline.com/wp-content/uploads/2017/09/Vision_Forest.jpg?mrf-size=m',
        'Ultron',
        'Vision',
        'Pietro Maximoff',
        'Iron Man',
        'Vision'));
    questions.add(QuestionObj(
        "What is the name of movie above?",
        'https://mmc.tirto.id/image/otf/700x0/2017/07/06/Spiderman-Homecoming--MARVEL_ratio-16x9.jpg',
        'Avengers: Age of Ultron',
        'The Incredible Hulk',
        'Spider-Man: Homecoming',
        'Guardians of the Galaxy',
        'Spider-Man: Homecoming'));
    questions.add(QuestionObj(
        "Above picture is a scene of what movie?",
        'https://cdn1-production-images-kly.akamaized.net/ikECN2wlttjNJh61uTbP78o080E=/640x360/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/1337740/original/059744100_1473083853-Guardians-of-the-Galaxy-Infinity-War.jpg',
        'Guardians of the Galaxy',
        'The Incredible Hulk',
        'Captain America: The First Avenger',
        'Black Panther',
        'Guardians of the Galaxy'));
    questions.add(QuestionObj(
        "What is the name of movie above?",
        'https://www.syfy.com/sites/syfy/files/styles/blog-post-embedded--tablet-1_5x/public/2020/01/avengers-endgame-final-battle.jpg',
        'Spider-Man: Far From Home',
        'The Incredible Hulk',
        'Avengers: Endgame',
        'Guardians of the Galaxy',
        'Avengers: Endgame'));
    questions.add(QuestionObj(
        "What is the name of movie's scene above?",
        'https://blue.kumparan.com/image/upload/fl_progressive,fl_lossy,c_fill,q_auto:best,w_640/v1555855507/intro-1555424642_fdf2da.jpg',
        'Spider-Man: Far From Home',
        'The Incredible Hulk',
        'Avengers: Endgame',
        'Guardians of the Galaxy',
        'The Incredible Hulk'));
    questions.add(QuestionObj(
        "What is the name of movie's scene above?",
        'https://www.rappler.com/tachyon/2018/02/wakanda-2.jpg',
        'Spider-Man: Far From Home',
        'The Incredible Hulk',
        'Avengers: Endgame',
        'Black Panther',
        'Black Panther'));
    questions.add(QuestionObj(
        "Who is the name of the character?",
        'https://asset.kompas.com/crops/t_hg6oUhBM0Fd0kW9P5qAJzPXrs=/0x0:1000x667/750x500/data/photo/2017/11/05/108501000.jpeg',
        'Captain America',
        'Vision',
        'Pietro Maximoff',
        'Iron Man',
        'Captain America'));
    _question_no = random.nextInt(5);
  }

  @override
  void dispose() {
    _timer.cancel();
    _hitung = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        body: Center(
          child: Column(children: [
            Divider(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: LinearPercentIndicator(
                center: Text(formatTime(_hitung)),
                width: MediaQuery.of(context).size.width - 20,
                lineHeight: 20.0,
                percent: 1 - (_hitung / _WAKTU_MAX),
                backgroundColor: Colors.grey,
                progressColor: Colors.red,
              ),
            ),
            // CircularPercentIndicator(
            //   radius: 120.0,
            //   lineWidth: 20.0,
            //   percent: 1 - (_hitung / _WAKTU_MAX),
            //   center: new Text(formatTime(_hitung)),
            //   progressColor: Colors.red,
            // ),
            // Divider(
            //   height: 30,
            // ),
            // ElevatedButton(
            //     onPressed: () {
            //       setState(() {
            //         _isrunning = !_isrunning;
            //       });
            //     },
            //     child: Text(_isrunning ? "Stop" : "Start")),
            Padding(
                padding: EdgeInsets.all(10),
                child: Image.network(questions[_question_no].picture)),
            Text(questions[_question_no].narration),
            TextButton(
                onPressed: () {
                  checkAnswer(questions[_question_no].option_a);
                },
                child: Text("A. " + questions[_question_no].option_a)),
            TextButton(
                onPressed: () {
                  checkAnswer(questions[_question_no].option_b);
                },
                child: Text("B. " + questions[_question_no].option_b)),
            TextButton(
                onPressed: () {
                  checkAnswer(questions[_question_no].option_c);
                },
                child: Text("C. " + questions[_question_no].option_c)),
            TextButton(
                onPressed: () {
                  checkAnswer(questions[_question_no].option_d);
                },
                child: Text("D. " + questions[_question_no].option_d)),
          ]),
        ));
  }
}
