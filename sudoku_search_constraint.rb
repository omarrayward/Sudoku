# This algorithm applies search plus constraint propagation to solve the sudoku

# The steps for this implementation of sudoku are:
# A.  Given an initial grid composed of an 81 character string, being '0' the empty spaces and numbers
#   (chars "1" to "9") the partial solutions in the grid, return a solved grid
# B.  First step: Convert the input to an 81 element array called <grid> (done with input.split(''))
# C.  Substitute the '0' inside the grid by a string of possible solutions (method <grid_sub>)
# D.  Solve the problem(method solve). This is a depth first search way of solving the problem
#   => Find the first element in grid that is an array
#   => Iterate through the elements of that array and substitue that cell for each element of the Array
#   => Run the method solve with the new grid (in which the constraing propagation has been applied)
# E. These algorithm is can be easily improved. There are 2 ways in which we can improve the solution:
#   => I. If we improve the contraints, we will have to check for less options (now we are only checking
#      to see if there is only one posibility remaining). Peter Norvig checks to different things and so
#      it constraints the posibility even further
#   => II. Improving the search. Right now we are only searching at the first cell with no solution, to make
#   => this algorithm more efficient we should chech the cell with the minimal number of possibilities.
#   => This is called choosing most constraint value first (type of heuristics)


def sudoku_constraint(input)
  grid = grid_sub(input.split(''))
  grid = solve(grid)
end

def solve(grid)
  return grid if grid.inject(0){|memo, el| memo+= el.length} == 81
  first_index = grid.index {|e| e.length>1}
  possible_results = grid[first_index]
  possible_results.each_char do |guess|
    new_grid = grid.clone   # The reason we choose to substitute each empty space with a sting instead of an array is because clone only creates a shallow copy of the array.
    new_grid[first_index] = guess
    if check_cell(new_grid, first_index)
      result = solve(grid_sub(new_grid)) #Constraint progagation applied to every new grid
      return result if result
    end
  end
  false
end

def grid_sub(grid)
  grid.each_with_index {| ele, index | grid[index] = possible_results(grid, index) if ele == '0'}
end

def possible_results(grid, index)
  result =['1', '2', '3', '4', '5', '6', '7', '8', '9'] - neighbors(grid, index)
  result.join('')
end

def neighbors(grid, location)
  solution = row_neighbor(grid, location) + col_neighbor(grid, location) + box_neighbor(grid, location)
  solution.uniq - ['0']
end

def row_neighbor(grid, location)
  solution = []
  grid.each_with_index do |element, index|
    solution << element if (index/9 == location/9  && index != location && element.length == 1)
  end
  solution
end

def col_neighbor(grid, location)
  solution = []
  grid.each_with_index do |element, index|
    solution << element if (index%9 == location%9 && index != location && element.length == 1)
  end
  solution
end

def box_neighbor(grid, location)
  solution = []
  grid.each_with_index do |element, index|
    ind_y, ind_x = index.divmod(9)
    loc_y, loc_x = location.divmod(9)
    solution << element if (ind_y/3 == loc_y/3 && ind_x/3 == loc_x/3 && index != location && element.length == 1)
  end
  solution
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

def method
  # res = sudoku_constraint('096040001100060004504810390007950043030080000405023018010630059059070830003590007')
  # display(res)
  # res = sudoku_constraint('105802000090076405200400819019007306762083090000061050007600030430020501600308900')
  # display(res)
  # res = sudoku_constraint('005030081902850060600004050007402830349760005008300490150087002090000600026049503')
  # display(res)
  # res = sudoku_constraint('302609005500730000000000900000940000000000109000057060008500006000000003019082040')
  # display(res)
  # res = sudoku_constraint('370000001000700005408061090000010000050090460086002030000000000694005203800149500')
  # display(res)
  # res = sudoku_constraint('030500804504200010008009000790806103000005400050000007800000702000704600610300500')
  # display(res)
  # res = sudoku_constraint('000689100800000029150000008403000050200005000090240801084700910500000060060410000')
  # display(res)
  # res = sudoku_constraint('608730000200000460000064820080005701900618004031000080860200039050000100100456200')
  # display(res)
  # res = sudoku_constraint('080020000040500320020309046600090004000640501134050700360004002407230600000700450')
  # display(res)
  # res = sudoku_constraint('290500007700000400004738012902003064800050070500067200309004005000080700087005109')
  # display(res)
  # res = sudoku_constraint('300000000050703008000028070700000043000000000003904105400300800100040000968000200')
  # display(res) # Need to make this faster
  # res = sudoku_constraint('000075400000000008080190000300001060000000034000068170204000603900000020530200000')
  # display(res) # Need to make this faster
  res = sudoku_constraint('000000000000000000000000000000000000000000000000000000000000000000000000000000000')
  display(res)
end
method
# require 'benchmark'
# x = sudoku_constraint('302609005500730000000000900000940000000000109000057060008500006000000003019082040')
# n = 10
# Benchmark.bmbm do |x|
#   x.report("propagation") { n.times{method} }
# end

