import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int oScore = 0;
  int xScore = 0;
  bool oTurn = true;
  var displayXO = List.filled(9, '', growable: false);
  int filledCellsNum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Column(
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 83),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(children: <Widget>[
                  const Text(
                    'Player O',
                    style: TextStyle(color: Colors.white, fontSize: 21),
                  ),
                  Text(
                    oScore.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 21),
                  ),
                ]),
                Column(children: <Widget>[
                  const Text(
                    'Player X',
                    style: TextStyle(color: Colors.white, fontSize: 21),
                  ),
                  Text(
                    xScore.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 21),
                  ),
                ]),
              ],
            ),
          )),
          Expanded(
            flex: 3,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    _tapped(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        displayXO[index],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ),
                  ),
                );
              },
              itemCount: 9,
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  void _tapped(int index) {
    setState(() {
      if (displayXO[index] == '') {
        if (oTurn) {
          displayXO[index] = 'o';
          filledCellsNum++;
          _checkWinner();
          oTurn = !oTurn;
        } else {
          displayXO[index] = 'x';
          filledCellsNum++;
          _checkWinner();
          oTurn = !oTurn;
        }
      }
    });
  }

  void _checkWinner() {
    // Figures in line on 1st row -OR- on 1st column -OR- falling diagonal
    if ((displayXO[0] == displayXO[1] &&
            displayXO[0] == displayXO[2] &&
            displayXO[0] != '') ||
        (displayXO[0] == displayXO[3] &&
            displayXO[0] == displayXO[6] &&
            displayXO[0] != '') ||
        (displayXO[0] == displayXO[4] &&
            displayXO[0] == displayXO[8] &&
            displayXO[0] != '')) {
      _showDialog(displayXO[0]);
    }
    // Figures in line on 2nd row
    if (displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5] &&
        displayXO[3] != '') {
      _showDialog(displayXO[3]);
    }

    // Figures in line on 3rd row
    if (displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8] &&
        displayXO[6] != '') {
      _showDialog(displayXO[6]);
    }

    // Figures in line on 2st column
    if (displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7] &&
        displayXO[1] != '') {
      _showDialog(displayXO[1]);
    }

    // Figures in line on 3st column -OR- on rising diagonal
    if ((displayXO[2] == displayXO[5] &&
            displayXO[2] == displayXO[8] &&
            displayXO[2] != '') ||
        (displayXO[2] == displayXO[4] &&
            displayXO[2] == displayXO[6] &&
            displayXO[2] != '')) {
      _showDialog(displayXO[2]);
    }

    if (filledCellsNum == 9) {
      _showDrawDialog();
    }
  }

  void _showDialog(String winner) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Text(
                    winner.toUpperCase(),
                    style: const TextStyle(fontSize: 60),
                  ),
                  const Text('WINNER!'),
                ],
              ),
            ),
            actions: [
              Center(
                child: Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _clearBoard();
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Restart Game'),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 13),
                      child: Text(
                        'Made by @AitmaZh',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, .4),
                            fontSize: 12,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });

    if (winner == 'o') {
      oScore += 1;
    } else if (winner == 'x') {
      xScore += 1;
    }
  }

  _showDrawDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  const Text(
                    'DRAW!',
                    style: TextStyle(fontSize: 60),
                  ),
                  Text(
                    _randomQuote(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            actions: [
              Center(
                child: Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _clearBoard();
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Restart Game'),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 13),
                      child: Text(
                        'Made by @AitmaZh',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, .4),
                            fontSize: 12,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < displayXO.length; i++) {
        displayXO[i] = '';
      }
    });

    filledCellsNum = 0;
  }

  /// Generates Random number in range from 0 to 4
  ///
  /// Returns a quote according to the drawn number
  _randomQuote() {
    var quoteNum = Random().nextInt(4);
    switch (quoteNum) {
      case 1:
        return '“Do you know what my favorite part of the game is? The opportunity to play.” \n--Mike Singletary';
      case 2:
        return '“Instead of playing to win, I was playing not to lose." \n--Sean Covey';
      case 3:
        return '"We must accept finite disappointment, but never lose infinite hope." \n--Martin Luther King';
      case 4:
        return '"You cannot win unless you learn how to lose." \n--Kareem Abdul-Jabbar';
      default:
        return '"Win if you can, lose if you must, but always cheat." \n--Jesse Ventura';
    }
  }
}
