# Sudoku Solver

In this file we explore the different ways of solving a Sudoku puzzle with a couple of different algorithm techniques.

Sudoku is an NP-complete problem in which there is no known algorithm that can estimate the runtime of the Solver.
So in order to solve Sudoku we can apply a variety of techniques:

1. Brute forze. This technique is the least efficient. In this technique given an uncompleted puzzle we try one by one every single possible solution, until we find the solution.
In the different solutions that we show in this folder this technique is not implemented.

2. Backtracking search. Given an uncompleted sudoku board we go through each empty cell or square and try each possibiity from 1 to 9. If the attempted solution doesn't cause a duplicate solution we move forward to the next empty cell. If the attempted solution creates a duplicate, we attempt another solution. If we end up running out of solutions in a given square, we go back to the previous square (backtrack) and try the next attempt.

This solution is implemented in the file: backtracking_search.
### benchmarck 150 seg

3. Constraint Satisfaction. Sudoku is a game that was to satisfy certain constraints. The same number can not be in the same column, row or box. So given an unsolved board if we go to every single blank cell, comparing the values od the neighbors; if there is only one possible value for that blank cell we can assign that cell the value of that number.

If this technique is applied, only easy sudoku puzzles can be solved. This technique is applied in the file: constraint_satisfaction_naive.rb

### There is no benchmark because it is not able to solve the difficult puzzles

4. Backtracking with Forward checking. This way of solving sudoku is an improvement over solving Sudoku with pure backtracking. In this algorithm, every time we assign a possible value to a blanck cell we check if, considering its neighbors, that's a possible value. By doing this, we reduce the number of iterations that the pure backtracking algorithm has to perform.
In the file backtracking_forward_checking.rb this technique is applied

### benchmarck 70 seg

5. Backtracking with forward checking and constraint satisfaction in the first iteration. A way to make backtracking with forward checking faster is to limit the number of options per blank space. This is done by applying the constraint satisfactions from algorithm (3) before running the forwar checking.

### benchmark 10 seg

6. Constraint propagation. This is the algorithm implementd by Peter Norvig to create the Sudoku Solver. He first created a way of propagating the constraints (explained in its file). And then we searches through all the blank cells with a Depth First Search, until the correct solution is found.

In constraint propagation the idea is that a blanck cell is only going to be filled with a guess only if its the correct guess. If it isn't the correct guess it will go to the next guess. In this solution there is no backtracking because its never wrong.

This algorithm is implemented in constraint_propagation_norvig (at this point it has a bug)
### benchmarck 0.135 seg
