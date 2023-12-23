import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'dart:math';



class XOXGame extends StatefulWidget {
  @override
  _XOXGameState createState() => _XOXGameState();
}

class _XOXGameState extends State<XOXGame> {
  List<List<String>> board = List.generate(3, (i) => List<String>.filled(3, ''));
  bool isPlayerX = true;

  @override
  void initState() {
    super.initState();
    initializeBoard();


  }

  void initializeBoard() {
    board = List.generate(3, (i) => List<String>.filled(3, ''));
    isPlayerX = true;
  }

void makeMove(int row, int col) {
    if (board[row][col] == '') {
      setState(() {
        board[row][col] = 'X';
        isPlayerX = false;
        if (checkForWinner()) {
          showWinnerDialog();
        } else if (isBoardFull()) {
          showDrawDialog();
        } else {
          makeAIMove(); // Make AI move after player
        }
      });
    }
  }

  void makeAIMove() {
    // Simple AI: Randomly choose an empty cell for 'O'
    List<int> emptyCells = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          emptyCells.add(i * 3 + j);
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      int randomIndex = Random().nextInt(emptyCells.length);
      int cell = emptyCells[randomIndex];
      int aiRow = cell ~/ 3;
      int aiCol = cell % 3;

      board[aiRow][aiCol] = 'O';
      isPlayerX = true;

      if (checkForWinner()) {
        showWinnerDialog();
      } else if (isBoardFull()) {
        showDrawDialog();
      }
    }
  }



  bool checkForWinner() {
    // Dikey, yatay ve çapraz kazanan kontrolü
    for (int i = 0; i < 3; i++) {
      if (board[i][0] != '' &&
          board[i][0] == board[i][1] &&
          board[i][1] == board[i][2]) {
        return true; // Dikey kontrol
      }
      if (board[0][i] != '' &&
          board[0][i] == board[1][i] &&
          board[1][i] == board[2][i]) {
        return true; // Yatay kontrol
      }
    }
    if (board[0][0] != '' &&
        board[0][0] == board[1][1] &&
        board[1][1] == board[2][2]) {
      return true; // Soldan sağa çapraz kontrol
    }
    if (board[0][2] != '' &&
        board[0][2] == board[1][1] &&
        board[1][1] == board[2][0]) {
      return true; // Sağdan sola çapraz kontrol
    }
    return false;
  }


  bool isBoardFull() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          return false; // Hala boş hücre var
        }
      }
    }
    return true; // Tüm hücreler dolu
  }

void showWinnerDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Kazanan'),
        content: Text(isPlayerX ? 'Oyuncu O kazandı!' : 'Oyuncu X kazandı!'),
        actions: <Widget>[
          TextButton(
            child: Text('Tamam'),
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
          ),
        ],
      );
    },
  );
}

  void showDrawDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Berabere'),
          content: Text('Oyun berabere bitti.'),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      initializeBoard();
    });
  }

Widget buildGameBoard() {
  List<Widget> rows = [];
  for (int i = 0; i < 3; i++) {
    List<Widget> rowChildren = [];
    for (int j = 0; j < 3; j++) {
      rowChildren.add(
        GestureDetector(
          onTap: () => makeMove(i, j),
          child: Container(
            width: 137.1,
            height: 137.1,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
            ),
            child: Center(
              child: Stack(
                children: [
                  // X işareti
                  if (board[i][j] == 'X')
                    NeonSign(
                      text: 'X',
                      color: Colors.blue,
                    ),
                  // O işareti
                  if (board[i][j] == 'O')
                    NeonSign(
                      text: 'O',
                      color: Colors.pink,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    rows.add(Row(children: rowChildren));
  }
  return Center(
    child: Column(children: rows),
  );
}

@override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('XOX Game'),
      ),
      backgroundColor: Colors.black87,
      // Arka plan resmi eklemek için Scaffold'un body özelliğini kullanın
      body: Container(
        decoration: BoxDecoration(
        ),
        child: Center( // Add this
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Add this
            children: [
              Center(child: buildGameBoard()), // Ensure the game board is also centered if it's a Row
              SizedBox(height: 20),
              AppText(
                text: isPlayerX ? "Sıra X'in" : "Sıra O'nun",
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7C7C7C),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NeonSign extends StatelessWidget {
  final String text;
  final Color color;

  const NeonSign({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mavi veya pembe gölge
        Positioned(
          top: 0,
          left: 0,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40.0,
              color: color,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: color,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
        // Ana metin
        Text(
          text,
          style: TextStyle(
            fontSize: 40.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
class FavouriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        
        child: XOXGame(),
        
      ),
    );
  }
}
