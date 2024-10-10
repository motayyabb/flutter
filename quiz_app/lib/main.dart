import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.deepPurple[50],
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
      ),
      home: CategorySelectionPage(),
    );
  }
}

class CategorySelectionPage extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'name': 'Mind Questions', 'image': 'assets/mind.png'},
    {'name': 'Programming Questions', 'image': 'assets/programming.png'},
    {'name': 'General Knowledge', 'image': 'assets/general_knowledge.png'},
    {'name': 'Pakistan History', 'image': 'assets/history.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(20.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryCard(
                    name: categories[index]['name']!,
                    imagePath: categories[index]['image']!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizPage(
                            category: categories[index]['name']!,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomizeQuestionsPage()),
                );
              },
              child: Text(
                'Add Customize Questions',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              ),
            ),
            SizedBox(height: 20), // Add some space below the button
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final VoidCallback onTap;

  CategoryCard({
    required this.name,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[900],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomizeQuestionsPage extends StatefulWidget {
  @override
  _CustomizeQuestionsPageState createState() => _CustomizeQuestionsPageState();
}

class _CustomizeQuestionsPageState extends State<CustomizeQuestionsPage> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  List<Map<String, dynamic>> customQuestions = [];

  void addQuestion() {
    if (questionController.text.isNotEmpty && answerController.text.isNotEmpty) {
      bool answer = answerController.text.toLowerCase() == 'true';
      setState(() {
        customQuestions.add({
          'question': questionController.text,
          'answer': answer,
        });
        questionController.clear();
        answerController.clear();
      });
    }
  }

  void startQuiz() {
    if (customQuestions.length >= 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(
            category: 'Custom Questions',
            customQuestions: customQuestions,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least 5 questions to start the quiz.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize Questions'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: questionController,
              decoration: InputDecoration(labelText: 'Enter your question'),
            ),
            TextField(
              controller: answerController,
              decoration: InputDecoration(labelText: 'Enter answer (true/false)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addQuestion,
              child: Text('Add Question', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startQuiz,
              child: Text('Start Quiz', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: customQuestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(customQuestions[index]['question']),
                    subtitle: Text('Answer: ${customQuestions[index]['answer']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>>? customQuestions;

  QuizPage({required this.category, this.customQuestions});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  int questionIndex = 0;
  int correctAnswers = 0;
  Timer? timer;
  int remainingTime = 5;

  // Questions for each category
  Map<String, List<String>> questions = {
    'Mind Questions': [
      'Is the sky blue?',
      'Is 2+2 equal to 4?',
      'Can humans breathe in space without equipment?',
      'Do fish live in water?',
      'Is the brain a muscle?',
      'Is a year 365 days?',
      'Does a car need fuel to run?',
      'Can plants make their own food?',
      'Is fire cold?',
      'Can computers think on their own?'
    ],
    'Programming Questions': [
      'Is Flutter a programming language?',
      'Is HTML a programming language?',
      'Is Python a snake?',
      'Is Java a coffee?',
      'Does Dart compile to JavaScript?',
      'Is CSS used for styling websites?',
      'Is Java and JavaScript the same?',
      'Can you run Python on a web browser?',
      'Is Git a version control system?',
      'Is C++ used for game development?'
    ],
    'General Knowledge': [
      'Is the Earth flat?',
      'Is the capital of France Paris?',
      'Is water wet?',
      'Is the sun a star?',
      'Does the moon have light of its own?',
      'Is Australia a country?',
      'Is the Pacific Ocean the largest ocean?',
      'Is the speed of light faster than sound?',
      'Is the Great Wall of China visible from space?',
      'Is the human body 90% water?'
    ],
    'Pakistan History': [
      'Was Pakistan created in 1947?',
      'Is Islamabad the capital of Pakistan?',
      'Did Pakistan win the 1992 Cricket World Cup?',
      'Is the Indus River in Pakistan?',
      'Is Quaid-e-Azam Muhammad Ali Jinnah the founder of Pakistan?',
      'Is Pakistan part of South Asia?',
      'Did the Mughal Empire rule Pakistan?',
      'Is Lahore the second largest city of Pakistan?',
      'Is the Kashmir issue a historical conflict?',
      'Is the Pakistan flag green and white?'
    ],
  };

  Map<String, List<bool>> answers = {
    'Mind Questions': [true, true, false, true, false, true, true, true, false, false],
    'Programming Questions': [false, false, false, true, true, true, false, false, true, true],
    'General Knowledge': [false, true, true, true, false, true, true, true, false, true],
    'Pakistan History': [true, true, true, true, true, true, true, true, true, true],
  };

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    remainingTime = 5; // Resetting timer
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          checkAnswer(false); // Automatically marks wrong if time runs out
          timer.cancel();
        }
      });
    });
  }

  void checkAnswer(bool? userAnswer) {
    bool correctAnswer = (widget.customQuestions != null && widget.customQuestions!.isNotEmpty)
        ? widget.customQuestions![questionIndex]['answer']
        : answers[widget.category]![questionIndex];

    setState(() {
      if (userAnswer == correctAnswer) {
        scoreKeeper.add(Icon(Icons.check, color: Colors.green));
        correctAnswers++;
      } else {
        scoreKeeper.add(Icon(Icons.close, color: Colors.red));
      }

      if (questionIndex < (widget.customQuestions?.length ?? questions[widget.category]!.length) - 1) {
        questionIndex++;
        startTimer();
      } else {
        timer?.cancel();
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Quiz Finished!"),
            content: Text(
              "You've answered $correctAnswers out of ${widget.customQuestions?.length ?? questions[widget.category]!.length} correctly.",
            ),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String question;
    bool? answer;

    if (widget.customQuestions != null && questionIndex < widget.customQuestions!.length) {
      question = widget.customQuestions![questionIndex]['question'];
      answer = widget.customQuestions![questionIndex]['answer'];
    } else {
      question = questions[widget.category]![questionIndex];
      answer = answers[widget.category]![questionIndex];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz - ${widget.category}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Time Remaining: $remainingTime seconds', // Timer display
              style: TextStyle(fontSize: 20, color: Colors.yellow),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => checkAnswer(true),
                  child: Text('True', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton(
                  onPressed: () => checkAnswer(false),
                  child: Text('False', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: scoreKeeper,
            ),
          ],
        ),
      ),
    );
  }
}
