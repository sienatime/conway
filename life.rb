# start with a size, generate a board

class Board
  attr_accessor :raw_board

  def initialize(columns, rows)
    @columns = columns
    @rows = rows
    @raw_board = generate_board
  end

  def generate_board
    Array.new(@rows){ Array.new(@columns, 0) }
  end

  def live(row, column)
    @raw_board[row][column] = 1
  end

  def die(row, column)
    @raw_board[row][column] = 0
  end

  def clone
    new_board = Board.new(@columns, @rows)

    @raw_board.each_with_index do |row, i|
      row.each_with_index do |column, j|
        if cell_is_alive?(i, j) == 1
          new_board.live(i, j)
        end
      end
    end

    new_board
  end

  def generate_neighbor_indeces(row, col)
    indeces = []
    indeces += [[row - 1, col - 1], [row - 1, col], [row - 1, col + 1]]
    indeces += [[row, col - 1], [row, col + 1]]
    indeces += [[row + 1, col - 1], [row + 1, col], [row + 1, col + 1]]
    indeces.select do |pair|
      row, col = pair
      row > -1 && row < @rows - 1 && col > -1 && col < @columns - 1
    end
  end

  def get_neighbors(row, col)
    neighbors_indeces = generate_neighbor_indeces(row, col)
    neighbors_indeces.map do |pair|
      row, col = pair
      @raw_board[row][col]
    end
  end

  def cell_is_alive?(row, col)
    @raw_board[row][col] == 1
  end

  def cell_should_live?(row, col)
    live_neighbors = get_neighbors(row, col).inject(:+)
    if cell_is_alive?(row, col)
      live_neighbors == 2 || live_neighbors == 3
    else
      live_neighbors == 3
    end
  end

  def tick
    next_step = clone

    @raw_board.each_with_index do |row, i|
      row.each_with_index do |column, j|
        if cell_should_live?(i, j)
          next_step.live(i, j)
        else
          next_step.die(i, j)
        end
      end
    end

    @raw_board = next_step.raw_board
  end

  def to_s
    output = ""
    @raw_board.each do |row|
      row_output = ""
      row.each do |column|
        row_output += "#{column} "
      end
      output += row_output + "\n"
    end
    output
  end
end

board = Board.new(5,5)
board.live(2, 1)
board.live(2, 2)
board.live(2, 3)

while true do
  puts board.to_s
  board.tick
  sleep 1
  puts "*********"
end
