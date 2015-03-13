class Board
  attr_accessor :board, :turn

  def initialize
    @board = [['1', '2', '3'], ['4', '5', '6'], ['7', '8', '9']]
    @turn = 0
  end

  def show_board
    puts <<-board

      #{self.board[0][0]} | #{self.board[0][1]} | #{self.board[0][2]}
      ---------
      #{self.board[1][0]} | #{self.board[1][1]} | #{self.board[1][2]}
      ---------
      #{self.board[2][0]} | #{self.board[2][1]} | #{self.board[2][2]} 

    board
  end

  def self.wins
    [[[0,0], [0,1], [0,2]], 
    [[1,0], [1,1], [1,2]], 
    [[2,0], [2,1], [2,2]],
    [[0,0], [1,0], [2,0]], 
    [[0,1], [1,1], [2,1]], 
    [[0,2], [1,2], [2,2]],
    [[0,0], [1,1], [2,2]], 
    [[0,2], [1,1], [2,0]]]
  end

  def self.center
    [1,1]
  end

  def self.corners
    [[0,0], [0,2], [2,0], [2,2]]
  end

  def self.sides
    [[0,1], [1,0], [2,1], [1,2]]
  end

  def win?
    if self.turn >= 5
      Board.wins.each do |win|
        values = []
        win.each do |position|
          values << self.board[position.first][position.last]
        end
        if values.uniq.size == 1
          return true
        end
      end
    end
    false
  end

  def get_free_spaces
    spaces = []
    self.board.each_with_index do |rows, row_index|
      rows.each_index do |index|
        if self.board[row_index][index] != 'x' &&  self.board[row_index][index] != 'o'
          spaces << [row_index, index]
        end
      end
    end
    spaces
  end

  def free_space?
    !get_free_spaces.empty? ? true : false
  end

  def find_position_coords(position)
    coords = []
    self.board.each_with_index do |rows, row_index|
      rows.each_index do |index|
        if self.board[row_index][index] == position
          coords << row_index << index
        end
      end
    end
    coords
  end

  def find_position_value(coords)
    self.board[coords.first][coords.last]
  end

  def position_free?(position)
    true if get_free_spaces.include?(find_position_coords(position))
  end

  def take_position(position, marker)
    if position_free?(position)
      coords = find_position_coords(position)
      self.board[coords.first][coords.last] = marker
      self.turn += 1
    else
      self.turn += 0
      puts 'Invalid position. Please try again'
    end
  end
end