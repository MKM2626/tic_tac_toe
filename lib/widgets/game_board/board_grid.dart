import 'package:flutter/material.dart';
import 'board_cell.dart';

class BoardGrid extends StatelessWidget {
  final List<List<String>> board;
  final Function(int row, int col) onTap;
  final Color cellColor;

  const BoardGrid({
    super.key,
    required this.board,
    required this.onTap,
    required this.cellColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.biggest.shortestSide;
        return Center(
          child: SizedBox(
            width: boardSize,
            height: boardSize,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                final row = index ~/ 3;
                final col = index % 3;

                BorderSide borderSide = const BorderSide(color: Colors.white, width: 2);
                Border border = Border(
                  top: row == 0 ? BorderSide.none : borderSide,
                  left: col == 0 ? BorderSide.none : borderSide,
                  right: col == 2 ? BorderSide.none : borderSide,
                  bottom: row == 2 ? BorderSide.none : borderSide,
                );

                return BoardCell(
                  value: board[row][col],
                  onTap: () => onTap(row, col),
                  border: border,
                  backgroundColor: cellColor,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
