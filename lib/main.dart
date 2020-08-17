import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			title: 'Tic Tac Toe AI',
			theme: ThemeData(
				primarySwatch: Colors.grey,
			),
			home: Scaffold(
				appBar: AppBar(
					title: Text('Tic Tac Toe AI'),
				),
				body: Game()
			),
		);
	}
}

class Move {
  int score;
  int index;
  Move({
	  this.score = 0, 
	  this.index
	});
}

class Game extends StatefulWidget {
	@override
	_GameState createState() => _GameState();
}

class _GameState extends State<Game> {
	List<String> game = new List.filled(9, '');
	bool gameOver = false;
	int moves = 0;
	int result = 0;

	gameMove() {
		if (!gameOver) {
			Move best = minimiser(game, 0);
			print("Game sets -> ${best.index}");
			setState(() {
			  game[best.index] = 'X';
			  moves++;
			});
			checkVictory();
		}
	}

	void onClick(int index) {
		if (game[index] == '') {
			setState(() {
				game[index] = 'O';
				moves++;
			});
			checkVictory();
			gameMove();
		}
	}

	void reset() {
		setState(() {
			game.fillRange(0, 9, '');
			gameOver = false;
			moves = 0;
			result = 0;
		});
	}

	void checkVictory() {
		print(game);
		print(isEndState(game));
		int res = findResult(game);
		if (res != -1) {
			setState(() {
				result = res;
				gameOver = true;
			});
		}
	}

	@override 
	Widget build(BuildContext context) {
		return Container(
			child: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
					Column(
						crossAxisAlignment: CrossAxisAlignment.center,
						children: <Widget>[
							Expanded(
								child: Container(
									width: kIsWeb ? MediaQuery.of(context).size.width > 300 ? 
									300 : MediaQuery.of(context).size.width : MediaQuery.of(context).size.width,
								child: GridView.count(
									padding: EdgeInsets.symmetric(vertical: 100, horizontal: 40),
									crossAxisCount: 3,
									children: List.generate(9, (index) {
										return GestureDetector(
											onTap: () {
												if (!gameOver) {
													onClick(index);
												}
											},
											child: getTile(index, game[index]),
										);
									}),
								),
							)),
							Opacity(
								opacity: gameOver ? 1.0:0.0,
								child: Padding(
									padding: EdgeInsets.only(
										bottom: 96.0,
									),
									child: GestureDetector(
										onTap: () {
											reset();
										},
										child: Text(
											'Click to play again!',
											style: TextStyle(
												fontSize: 25.0
											)),
									)
								)
							),
						],
					)
				],
			)
		);
	}
}


int findResult(List<String> game) {
	for(int i=0; i<9; i+=3) {
		if ((game[i] == game[i+1]) && (game[i+1] == game[i+2]) && (game[i] != '')) {
			if (game[i] == 'O') { return 1; } 
			else if (game[i] == 'X') { return 2; }
		}
	}

	for(int i=0; i<3; i++) {
		if ((game[i] == game[i+3]) && (game[i+3] == game[i+6]) && (game[i] != '')) {
			if (game[i] == 'O') { return 1; } 
			else if (game[i] == 'X') { return 2; }
		}
	}

	if ((game[0] == game[4]) && (game[4] == game[8]) && (game[0] != '')) {
		if (game[0] == 'O') { return 1; } 
		else if (game[0] == 'X') { return 2; }
	}

	else if (game[2] == game[4] && game[4] == game[6] && game[2] != '') {
		if (game[2] == 'O') { return 1; } 
		else if (game[2] == 'X') { return 2; }
	}

	for(int i=0; i<9; i++) {
		if (game[i] == '') { return -1; }
	}

	return 0;
}


bool isEndState(List<String> s) {
	var temp = findResult(s);
	if (temp == -1) { return false; }
	return true;
}


int getScore(List<String> s, int depth) {
	int res = findResult(s);
	if (res == 1) { return (10 + depth); }
	else if (res == 2) { return (depth - 10); }
	return 0;
}


Move minimiser (List<String> s, int depth) {
	if (isEndState(s)) { return Move(score: getScore(s, depth), index: -1);	}

	Move min = new Move(score: 1000, index: -1);
	for(int i=0; i<9; i++) {
		if (s[i] == '') {
			s[i] = 'X';
			Move curr = maximiser(s, depth+1);
			if (curr.score < min.score) {
				min.score = curr.score;
				min.index = i;
			}
			s[i] = '';
		}
	}
	return min;
}

Move maximiser (List<String> s, int depth) {
	if (isEndState(s)) { return Move(score: getScore(s, depth), index: -1);	}

	Move max = new Move(score: -1000, index: -1);
	for(int i=0; i<9; i++) {
		if (s[i] == '') {
			s[i] = 'O';
			Move curr = minimiser(s, depth+1);
			if (curr.score > max.score) {
				max.score = curr.score;
				max.index = i;
			}
			s[i] = '';
		}
	}
	return max;
}


Widget getTile (int index, String text) {
	return Container(
		decoration: BoxDecoration(
			border: getBorders(index)
		),
		child: Center(
			child: Text(
				text,
				style: TextStyle(
					fontSize: 64, 
					fontWeight: FontWeight.w400),  
			),
		)
	);
}


Border getBorders(int index) {
	switch (index) {
		case 0: return Border(
			bottom: BorderSide(width: 5, color: Colors.grey),
			right: BorderSide(width: 5, color: Colors.grey)
		);
		case 1: return Border(
			bottom: BorderSide(width: 5, color: Colors.grey),
			left: BorderSide(width: 5, color: Colors.grey),
			right: BorderSide(width: 5, color: Colors.grey)
		);
		case 2: return Border(
			bottom: BorderSide(width: 5, color: Colors.grey),
			left: BorderSide(width: 5, color: Colors.grey),
		);
		case 3: return Border(
			top: BorderSide(width: 5, color: Colors.grey),
			bottom: BorderSide(width: 5, color: Colors.grey),
			right: BorderSide(width: 5, color: Colors.grey)
		);
		case 4: return Border.all(width: 5, color: Colors.grey); 
		case 5: return Border(
			top: BorderSide(width: 5, color: Colors.grey),
			bottom: BorderSide(width: 5, color: Colors.grey),
			left: BorderSide(width: 5, color: Colors.grey),
		);
		case 6: return Border(
			top: BorderSide(width: 5, color: Colors.grey),
			right: BorderSide(width: 5, color: Colors.grey)
		);
		case 7: return Border(
			top: BorderSide(width: 5, color: Colors.grey),
			left: BorderSide(width: 5, color: Colors.grey),
			right: BorderSide(width: 5, color: Colors.grey)
		);
		case 8: return Border(
			top: BorderSide(width: 5, color: Colors.grey),
			left: BorderSide(width: 5, color: Colors.grey),
		);
	}
	return Border.all(width: 5, color: Colors.grey);
}