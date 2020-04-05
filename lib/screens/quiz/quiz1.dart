import 'package:ssc_401/shared/mylib.dart';

var finalScore = 0;
var questionNumber = 0;
var quiz = new BinQuiz();

class BinQuiz {
//  var images = [
//    "alligator", "cat", "dog", "owl"
//  ];

  var questions = [
    "Which of the following items can be recycled? ",
    "Which of the following material are non-biodegradable?",
    "Which of the following statement is false?",
    "Which of the following actions will NOT help reduce the amount of waste produced?",
  ];

  var choices = [
    ["Plastic PET Bottle", "Plastic Cling Wraps", "Styrofoam Cups", "None of the above"],
    ["Paper", "Wood", "Glass", "None of the above"],
    ["Electronics cannot be recycled", "Glass can be recycled", "Wood can be recycled", "None of the above"],
    ["Bring your own bag when doing groceries", "Recycle your plastic bottles after use",
      "Use disposable utensils when consuming your meals", "None of the above"]
  ];

  var correctAnswers = ["Plastic PET Bottle", "Glass", "Electronics cannot be recycled", "Bring your own bag when doing groceries"];
}

class Quiz1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new Quiz1State();
  }
}

class Quiz1State extends State<Quiz1> {
  // Declare this variable
  int selectedRadioTile;

  @override
  void initState() {
    super.initState();
    selectedRadioTile = 0;
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: new Container(
            margin: const EdgeInsets.all(10.0),
            alignment: Alignment.topCenter,
            child: new Column(
              children: <Widget>[
                new Padding(padding: EdgeInsets.all(20.0)),
                new Container(
                  alignment: Alignment.centerRight,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        "Question ${questionNumber + 1} of ${quiz.questions.length}",
                        style: new TextStyle(fontSize: 22.0),
                      ),
                      new Text(
                        "Score: $finalScore",
                        style: new TextStyle(fontSize: 22.0),
                      )
                    ],
                  ),
                ),

                //image
                new Padding(padding: EdgeInsets.all(10.0)),

//                new Image.asset(
//                  "images/${quiz.images[questionNumber]}.jpg",
//                ),
                new Image.network(
                    ('www.eng.nus.edu.sg/wp-content/uploads/sites/5/2019/10/Bin-Point.jpg')),

                new Padding(padding: EdgeInsets.all(10.0)),

                new Text(
                  quiz.questions[questionNumber],
                  style: new TextStyle(
                    fontSize: 20.0,
                  ),
                ),

                new Padding(padding: EdgeInsets.all(10.0)),

                RadioListTile(
                  value: 1,
                  groupValue: selectedRadioTile,
                  title: Text(quiz.choices[questionNumber][0]),
                  onChanged: (val) {
                    print("Radio Tile pressed $val");
                    setSelectedRadioTile(val);
                  },
                  activeColor: Colors.blue,
                  selected: false,
                ),
                RadioListTile(
                  value: 2,
                  groupValue: selectedRadioTile,
                  title: Text(quiz.choices[questionNumber][1]),
                  onChanged: (val) {
                    print("Radio Tile pressed $val");
                    setSelectedRadioTile(val);
                  },
                  activeColor: Colors.blue,
                  selected: false,
                ),
                RadioListTile(
                  value: 3,
                  groupValue: selectedRadioTile,
                  title: Text(quiz.choices[questionNumber][2]),
                  onChanged: (val) {
                    print("Radio Tile pressed $val");
                    setSelectedRadioTile(val);
                  },
                  activeColor: Colors.blue,
                  selected: false,
                ),
                RadioListTile(
                  value: 4,
                  groupValue: selectedRadioTile,
                  title: Text(quiz.choices[questionNumber][3]),
                  onChanged: (val) {
                    print("Radio Tile pressed $val");
                    setSelectedRadioTile(val);
                  },
                  activeColor: Colors.blue,
                  selected: false,
                ),

                new Padding(padding: EdgeInsets.all(15.0)),

                new Container(
                    alignment: Alignment.bottomCenter,
                    child: new MaterialButton(
                        minWidth: 240.0,
                        height: 30.0,
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          if (quiz.choices[questionNumber][selectedRadioTile-1] ==
                              quiz.correctAnswers[questionNumber]) {
                            Fluttertoast.showToast(
                              msg: "Correct",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                            debugPrint("Correct");
                            finalScore++;
                          } else {
                            debugPrint("Wrong");
                            Fluttertoast.showToast(
                              msg: "Wrong",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                          }
                          updateQuestion();
                        },
                        child: new Text(
                          "Next",
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.white),
                        ))),
              ],
            ),
          ),
        ));
  }

  void resetQuiz() {
    setState(() {
      Navigator.pop(context);
      finalScore = 0;
      questionNumber = 0;
    });
  }

  void updateQuestion() {
    setState(() {
      if (questionNumber == quiz.questions.length - 1) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new Summary(
                      score: finalScore,
                    )));
      } else {
        questionNumber++;
      }
    });
  }
}

class Summary extends StatelessWidget {
  final int score;

  Summary({Key key, @required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "Final Score: $score",
                  style: new TextStyle(fontSize: 35.0),
                ),
                new Padding(padding: EdgeInsets.all(30.0)),
                new MaterialButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    questionNumber = 0;
                    finalScore = 0;
                    Navigator.pop(context);
                  },
                  child: new Text(
                    "Retry Quiz",
                    style: new TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
