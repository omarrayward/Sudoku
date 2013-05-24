# This solution applies constraint satisfaction to solve the sudoku puzzle.
# It can only solve the easy puzzles.

# We check the possible results for the white spaces and if there is only one posibility, that
# possibility is assigned to that square.

# Peter Norvig (http://norvig.com/sudoku.html) applies constraint propagation, which is based in
# constaraint satisfaction but has more power.

# 1. Uses a grid (string) to represent the input (81 char string beign the <.> or <0> the empty cells)
# He represents the possible values in a map with the keys being the cells of the grid and the
# values beign the nine possible values
# 2. Iterate through all the cells in the values map
# 3. Then iterate through every *char (except the corresponding char in grid) in the value of the values
# map (if the corresponding place in the grid(input) is between 1-9) (e.i. if char in grid is 1,
# it will iterate from 2-8)
# 4. Eliminate that *char from the possibilities in the values
# => If there is only 1 char remaining: that's the answer for that *cell (the same piece of constaint satisfaction
#  that is done in constraint_satisfaction_naive.rb)
# => It checks all the other squares(in the values map) in every unit (col, row, box) related with the square that
# we were initially testing.
#      If the deleted value is the only posibility in the one *square of the remaining squares for any unit.
#      That *square gets assigned the value that was initially deleted in the initial *cell
#  (cell and square are used with the same meaning)
#  This is all done with a functon called assign, and it returns false when there are contradictions

# 5. Up to this point of the sudoku solver, one could solve the easy puzzles, but the difficult puzzles need
# some guessing.
# => We could guess brute force (not recommended)
# => We could guess with backtraking .This is a strategy in wich we guess an option a from the different options. Three things can happen:
#     A. The overall result of the game is solved, in which case we return the result
#     B. The partial result (duplicates in the same column) is wrong, in which case we go to the next option
#     C. The partial result is ok, but we can not assure that the overall result is going to be ok. In that case we go to the next unresolved
#         cell in the grid. If a guess at that next cell is wrong we have to go back (backtracking) to the previous cell in which we tried
#         a possibility
# => We could guess with depth first search + constraint propagation. In this case we go through every possibility in the first unsolved
#    cell. We apply constraint propagation to that guess, and if the game is solved, we return that solution.
#    If the game is not resolved we go to the next possibility in the first unsolved cell. Once finished with that cell we go to the next
#    cell and so on.
#
# Backtracking(keep track of each change in the values). This can be difficult when each of the changes maked more changes through constant
# propagation. This would be a good soultion if we were dealing with a complex data structure and we were only making one change at a time.
# In a problem like Sudoku it is more efficient to do constraint propagation + DFS instead of backtracking



def sudoku_naive (input)
  grid = input.split('')
  solver(grid)
end

def solver(grid)
  numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
  while grid.include?("0")
    grid.each_with_index do |cell, index|
      if cell == '0'
        neighbors = neighbors(grid, index)
        posible_results = numbers-neighbors
        grid[index] = posible_results[0] if posible_results.length == 1
      end
    end
  end
  grid
end

def neighbors(grid, location)
  solution = row_neighbor(grid, location) + col_neighbor(grid, location) + box_neighbor(grid, location)
  solution.uniq - ['0']
end

def row_neighbor(grid, location)
  solution = []
  grid.each_with_index do |element, index|
    solution << element if (index/9 == location/9  && index != location)
  end
  solution
end


def col_neighbor(grid, location)
  solution = []
  grid.each_with_index do |element, index|
    solution << element if (index%9 == location%9 && index != location)
  end
  solution
end

def box_neighbor(grid, location)
  solution = []
  grid.each_with_index do |element, index|
    ind_y, ind_x = index.divmod(9)
    loc_y, loc_x = location.divmod(9)
    solution << element if (ind_y/3 == loc_y/3 && ind_x/3 == loc_x/3 && index != location)
  end
  solution
end

def check_solution(grid)
  grid.each_with_index{|el , index| return false if !check_cell(grid, index)}
  true
end

def check_cell(grid, index)
  return false if neighbors(grid, index).include?(grid[index])
  true
end

def display(sudoku)
  sudoku.each_with_index do | ele, index |
    y, x = index.divmod(9)
    print ele
    print "|" if index%3 == 2
    puts "\n" if index%9 == 8
    puts "------------"  if index%27 == 26
  end
end


sud = sudoku_naive('619030040270061008000047621486302079000014580031009060005720806320106057160400030')
display(sud)
