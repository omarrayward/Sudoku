# Ruby translation of Peter Norvig's solution
# This solution applies constraint propagation, depth first search and minimum remaining
# values hueristic

# In this implementation. First the gris is parsed one time to assign the given values
# to the values map (constraint propagation is used here)
# It is faster if

#!/usr/bin/env ruby
#
#  Translated into ruby from python by Martin-Louis Bright
#  Algorithm, overall structure and original python source code by Peter Norvig
#  See http://norvig.com/sudoku.html

# Throughout this program:
#   r is a row,    e.g. 'A'
#   c is a column, e.g. '3'
#   s is a square, e.g. 'A3'
#   d is a digit,  e.g. '9'
#   u is a unit,   e.g. ['A1','B1','C1','D1','E1','F1','G1','H1','I1']
#   g is a grid,   e.g. 81 non-blank chars, e.g. starting with '.18...7...
#   values is a hash of possible values, e.g. {'A1'=>'123489', 'A2'=>'8', ...}

class SudokuSolver
  VERSION = "1.4"
  attr_reader :rows, :cols, :squares, :unitlist, :peers, :units

  # Cross-product
  def cross(a, b)
    cp = Array.new # cross product
    a.each do |x|
      b.each do |y|
        cp << x+y
      end
    end
    return cp
  end

  def initialize()
    @rows = ('A'..'I').to_a
    @cols = ('1'..'9').to_a
    @squares = cross(@rows, @cols)
    @unitlist = Array.new
    cols.each { |c| @unitlist.push(cross(rows, [c])) } # OMAR: The c was put in brackets by me
    rows.each { |r| @unitlist.push(cross([r], cols)) } # OMAR: The r was put in brackets by me
    for rb in ['ABC','DEF','GHI'] do
      for cb in ['123','456','789'] do
        @unitlist << cross(rb.split(''),cb.split(''))
      end
    end

    @units = Hash.new
    squares.each do |s|
      @units[s] = Array.new
      unitlist.each do |u|
        u.each do |x|
          @units[s].push(u) if s == x
        end
      end
    end

    @peers = Hash.new
    squares.each do |s|
      @peers[s] = Array.new
      units[s].each do |u|
        u.each { |s2| @peers[s] << s2 if s2 != s }
      end
      @peers[s] = @peers[s].uniq  #OMAR: This was implemented by me
    end
  end

  # A grid is an 81 character string composed of the digits 1-9
  # A blank is represented as a period.
  def parse_grid(g)
    g = g.chomp
    g = g.split('')
    values = Hash.new
    # Initially any square can be anything.
    squares.each { |s| values[s] = "123456789" }
    for s,d in squares.zip(g)
      # values[s] = d # OMAR It is faster with line and deleting the line below
      return false unless assign(values, s, d) if d =~ /\d/ # it will not be /\d/ if it's a '.'
    end
    return values
  end

  # Assign a value to a square in the Sudoku grid:
  # Eliminate all other possible digits from the square
  # by calling the eliminate function (mutually recursive)
  def assign(values, s, d)
    values[s].split('').each do |d2|
      unless d2 == d
        return false if eliminate(values, s, d2) == false
      end
    end
    return values
  end

  # Remove a possibility from a square.
  # Recursively propagate the constraints: look at the source code for how this is done.
  def eliminate(values, s, d)
    return values unless values[s].include?(d) ## Already eliminated.

    values[s] = values[s].sub(d,'') # Remove the digit from the string of possibilities
    #  values[s].sub!(d,'') => why doesn't sub!() work?

    return false if values[s].length == 0 # Contradiction: no more values (no more digits can be assigned)

    # Remove digit from all peers
    # If the square has only one remaining possibility, that is the assigned value for the square and
    # that value must be removed from all that square's peers.
    peers[s].each { |s2| return false unless eliminate(values, s2, values[s]) } if values[s].length == 1

    # Assign the digit to the square if, by elimination
    # this is the only square that has the digit as a possibility
    # It is faster deleting the 6 lines below.
    units[s].each do |u|
      dplaces = Array.new
      u.each { |s2| dplaces << s2 if values[s2].include?(d) }
      return false if dplaces.length == 0 # bad
      return false if assign(values, dplaces[0], d) == false if dplaces.length == 1
    end
    return values
  end

  # Search if constraint satisfaction does not solve the puzzle
  def search(values)
    return false if values == false

    solved = true # assumption
    squares.each do |s|
      unless values[s].length == 1
        solved = false
        break
      end
    end
    return values if solved == true  ## Solved!

    min = 10
    start = nil
    squares.each do |s| # Chose the undetermined square s with the fewest possibilities
      l = values[s].length
      if l > 1 && l < min
        min = l
        start = s
      end
    end

    values[start].split('').each do |d|
      solution = search(assign(values.clone,start,d))
      return solution unless solution == false
    end
    return false
  end

  # Print a text Sudoku grid to STDOUT
  def print_grid(values)
    return if values == false
    max = 0
    squares.each { |s| max = values[s].length if values[s].length > max }
    width = 1 + max
    a = Array.new
    3.times do |c|
      tmp = ""
      (3*width).times do
        tmp = tmp + '-'
      end
      tmp += "-" if c == 1
      a.push(tmp)
    end
    line  = "\n" + a.join('+')

    tmp = ""
    for r in rows
      for c in cols
        tmp = tmp + values[r+c].center(width)
        if c == '3' or c == '6'
          tmp = tmp + '| '
        end
      end
      tmp = tmp + line if r == 'C' or r == 'F'
      tmp = tmp + "\n"
    end
    puts tmp + "\n"
    return values
  end

  # Transform the solution into an 81 character string
  def string_solution(values)
    solution = ""
    squares.each do |s|
      solution += values[s]
    end
    return solution
  end

  # Verify the Sudoku solution
  def check_solution(solution)
    values = Hash.new
    for s,d in squares.zip(solution.split(''))
      values[s] = d
    end

    unitlist.each do |u|
      tmp = Hash.new
      u.each do |s|
        tmp[values[s]] = true
      end
      return false unless tmp.keys.length == 9
    end
    return true
  end

end

# s = SudokuSolver.new()
# p = s.parse_grid('096040001100060004504810390007950043030080000405023018010630059059070830003590007'.gsub('0', '.'))


def method
  s = SudokuSolver.new()
  s.parse_grid('096040001100060004504810390007950043030080000405023018010630059059070830003590007'.gsub('0', '.'))
  s = SudokuSolver.new()
  s.parse_grid('105802000090076405200400819019007306762083090000061050007600030430020501600308900'.gsub('0', '.'))
  s = SudokuSolver.new()
  s.parse_grid('005030081902850060600004050007402830349760005008300490150087002090000600026049503'.gsub('0', '.'))
  s = SudokuSolver.new()
  s.parse_grid('302609005500730000000000900000940000000000109000057060008500006000000003019082040'.gsub('0', '.'))
  s = SudokuSolver.new()
  s.parse_grid('370000001000700005408061090000010000050090460086002030000000000694005203800149500'.gsub('0', '.'))
  s = SudokuSolver.new()
  s.parse_grid('030500804504200010008009000790806103000005400050000007800000702000704600610300500'.gsub('0', '.'))
  s = SudokuSolver.new()
  s.parse_grid('000689100800000029150000008403000050200005000090240801084700910500000060060410000'.gsub('0', '.'))
  s = SudokuSolver.new()
  s.parse_grid('608730000200000460000064820080005701900618004031000080860200039050000100100456200'.gsub('0', '.'))
  s = SudokuSolver.new()
  s.parse_grid('080020000040500320020309046600090004000640501134050700360004002407230600000700450'.gsub('0', '.'))
  s = SudokuSolver.new()
  s.parse_grid('290500007700000400004738012902003064800050070500067200309004005000080700087005109'.gsub('0', '.'))
  s = SudokuSolver.new()
  s.parse_grid('300000000050703008000028070700000043000000000003904105400300800100040000968000200'.gsub('0', '.'))
  s = SudokuSolver.new()
  s.parse_grid('000075400000000008080190000300001060000000034000068170204000603900000020530200000')
end

require 'benchmark'
n = 1
Benchmark.bmbm do |x|
  x.report("norvig") { n.times{method} }
end



# s.print_grid(p)
# Algorithm by Peter Norvig @ http://www.norvig.com/sudoku.html

# More constraints:
# http://www.scanraid.com/BasicStrategies.htm
# http://www.krazydad.com/blog/2005/09/29/an-index-of-sudoku-strategies/
# http://www2.warwick.ac.uk/fac/sci/moac/currentstudents/peter_cock/python/sudoku/
