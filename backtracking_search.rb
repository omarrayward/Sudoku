# This is the first


# This is an easy to understand backtracking search solution that solves every Sudoku
# It solves it recursively by trying all the available numbers.
# I learned about this solution at Dev Bootcamp, thanks to the founder Sherif.
# In this solution there are 2 different data types to represent the board or grid
# => One of them is an 81 element Array in which we check if there are any "0"
# => The other one is a set of 3 2D Arrays representing rows cols and boxes where we
#    check if there are any duplicates

class Sudoku
  def initialize(input)
    @grid  = input.split('')
    prepare_grid # create a rows, cols, boxes instance variable (each a 2D 9x9 Array)
  end

  def solve!

    return false unless valid? # check if there are any duplicates in the board
    return @grid.join if solved? # solved? is true if there are no '0'
    first_zero = @grid.index("0")

    (1..9).each do |guess|
      @grid[first_zero] = guess
      solution = Sudoku.new(@grid.join).solve!
      return solution if solution
    end
    return false
  end

  def valid? #valid? is true if there are no duplicates in row cols and boxes
    no_dups?(@rows) && no_dups?(@cols) && no_dups?(@boxes)
  end

  def solved?# solved? is true if there are no '0'
    !@grid.include?('0')
  end


  def no_dups?(coll)
    coll.all?{|ele| ele.uniq.length == ele.length }
  end

  def prepare_grid
    @rows  = Array.new(9){Array.new}
    @cols  = Array.new(9){Array.new}
    @boxes = Array.new(9){Array.new}
    @grid.each_with_index do |ele, index|
      @rows[index/9] << ele unless ele =='0'
      @cols[index%9] << ele unless ele =='0'
      @boxes[box(index)] << ele unless ele =='0'
    end
  end

  def box(index)
    # index.divmod(9)[1]/3 + (index.divmod(9)[0]/3)*3
    (index%9)/3 + (index/27)*3
  end

end


def method
  sudoku = Sudoku.new('096040001100060004504810390007950043030080000405023018010630059059070830003590007')
  sudoku.solve!
  sudoku = Sudoku.new('105802000090076405200400819019007306762083090000061050007600030430020501600308900')
  sudoku.solve!
  sudoku = Sudoku.new('005030081902850060600004050007402830349760005008300490150087002090000600026049503')
  sudoku.solve!
  sudoku = Sudoku.new('302609005500730000000000900000940000000000109000057060008500006000000003019082040')
  sudoku.solve!
  sudoku = Sudoku.new('370000001000700005408061090000010000050090460086002030000000000694005203800149500')
  sudoku.solve!
  sudoku = Sudoku.new('030500804504200010008009000790806103000005400050000007800000702000704600610300500')
  sudoku.solve!
  sudoku = Sudoku.new('000689100800000029150000008403000050200005000090240801084700910500000060060410000')
  sudoku.solve!
  sudoku = Sudoku.new('608730000200000460000064820080005701900618004031000080860200039050000100100456200')
  sudoku.solve!
  sudoku = Sudoku.new('080020000040500320020309046600090004000640501134050700360004002407230600000700450')
  sudoku.solve!
  sudoku = Sudoku.new('290500007700000400004738012902003064800050070500067200309004005000080700087005109')
  sudoku.solve!
  sudoku = Sudoku.new('300000000050703008000028070700000043000000000003904105400300800100040000968000200')
  sudoku.solve!
  sudoku = Sudoku.new('000075400000000008080190000300001060000000034000068170204000603900000020530200000')
  sudoku.solve!
end

require 'benchmark'
n = 1
Benchmark.bmbm do |x|
  x.report("backtracking") { n.times{method} }
end

