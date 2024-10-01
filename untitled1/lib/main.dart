import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(CoinTossApp());

class CoinTossApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coin flip',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: CoinTossScreen(),
    );
  }
}

class CoinTossScreen extends StatefulWidget {
  @override
  _CoinTossScreenState createState() => _CoinTossScreenState();
}

class _CoinTossScreenState extends State<CoinTossScreen> with SingleTickerProviderStateMixin {
  String _coinSide = ""; // To hold the current coin image
  String _result = ""; // To hold the result of the coin toss
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  late Animation<double> _rotateAnimation;
  bool _isFlipping = false; // To track if the coin is flipping

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2), // Increased duration for more flips
      vsync: this,
    );

    // Create a flip animation for the vertical flip
    _flipAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear, // Continuous flipping
      ),
    );

    // Create a rotation animation for 360 degrees
    _rotateAnimation = Tween<double>(begin: 0, end: 4 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear, // Continuous flipping
      ),
    );
  }

  void _flipCoin() {
    if (_isFlipping) return; // Prevent flipping if already flipping

    setState(() {
      _isFlipping = true; // Set flipping state
      _controller.forward().then((_) {
        // Randomly determine heads or tails after the flip
        bool isHeads = Random().nextBool();
        _coinSide = isHeads ? "images/head.png" : "images/tail.png";
        _result = isHeads ? "Heads" : "Tails"; // Set result text

        // Reverse animation after the coin flip
        _controller.reverse().then((_) {
          // Show the result after the flip animation is complete
          setState(() {
            _isFlipping = false; // Reset flipping state
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Toss', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the result of the coin flip
              Text(
                _result.isNotEmpty ? _result : 'Result',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              SizedBox(height: 20),
              // Display the tossing animation
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translate(0.0, -50 * _flipAnimation.value) // Move upward
                      ..rotateX(pi * (_flipAnimation.value % 2)) // Rotate around the X-axis for flip
                      ..rotateZ(_rotateAnimation.value) // Rotate around the Z-axis for full flips
                      ..scale(1 - 0.1 * (_flipAnimation.value % 2)), // Scale down during flip
                    child: _coinSide.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        _coinSide,
                        height: 200, // Set height for the image
                        width: 200, // Set width for the image
                      ),
                    )
                        : Text(
                      'Press the button to toss the coin!',
                      style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _flipCoin,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
                  elevation: MaterialStateProperty.all(5), // Add shadow
                ),
                child: Text(
                  'Toss the Coin',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






