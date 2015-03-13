class Computer
  attr_reader :name
  attr_accessor :marker, :smart, :position

  def initialize(board_state)
    @name = 'Computer'
    @board_state = board_state
    @smart = 'off'
  end

  def opponent_marker
    if @marker == 'x'
      @opponent_marker = 'o'
    else
      @opponent_marker = 'x'
    end
  end

  def move
    if self.smart == 'on'
      return take_or_block_win, statement  if take_or_block_win?
      return take_center, statement  if take_center?
      binding.pry
      return take_opposite_corner, statement  if take_opposite_corner?
      return take_empty_corner, statement  if take_empty_corner?
      return take_empty_side, statement  if take_empty_side?
    else
      return take_random, statement
    end
  end

  def statement
    puts "#{self.name}-('#{self.marker}') plays position #{self.position}."
  end

  def take_random
    position = @board_state.get_free_spaces.sample
    @position = @board_state.find_position_value(position)
    @board_state.take_position(@position, marker)
  end

  def take_or_block_win?
    Board.wins.each do |win|
      markers = []
      win.each do |position|
        markers << @board_state.find_position_value(position)
      end

      if (markers.count(marker) == 2 && markers.count(opponent_marker) == 0) || (markers.count(opponent_marker) == 2 && markers.count(marker) == 0)
        return true
      end
    end
    false
  end

  def take_or_block_win
    win_positions = []
    block_positions = []

    Board.wins.each do |win|
      markers = []
      win.each do |position|
        markers << @board_state.find_position_value(position)
      end

      if markers.count(marker) == 2 && markers.count(opponent_marker) == 0
        win_positions << (markers - [marker]).first
      elsif markers.count(opponent_marker) == 2 && markers.count(marker) == 0
        block_positions << (markers - [opponent_marker]).first
      end
    end

    if !win_positions.empty?
      @position = win_positions.sample
    else
      @position = block_positions.sample
    end

    @board_state.take_position(@position, marker)
  end

  # def fork
  # end

  # def block_fork
  # end

  def take_center?
    true if @board_state.get_free_spaces.include?([1,1])
  end

  def take_center
    @position = @board_state.find_position_value(Board.center)
    @board_state.take_position(@position, marker)
  end

  def take_opposite_corner?
    diagonal_corners = {
      [0,0] => [2,2],
      [0,2] => [2,0],
      [2,0] => [0,2],
      [2,2] => [0,0]
    }

    diagonal_corners.each do |corner, opposite_corner|
      if @board_state.find_position_value(corner) == opponent_marker && @board_state.find_position_value(opposite_corner) != marker && @board_state.find_position_value(opposite_corner) != opponent_marker
        return true
      end
    end
    false
  end

  def take_opposite_corner
    diagonal_corners = {
      [0,0] => [2,2],
      [0,2] => [2,0],
      [2,0] => [0,2],
      [2,2] => [0,0]
    }

    diagonal_corners.each do |corner, opposite_corner|
      if @board_state.find_position_value(corner) == opponent_marker && @board_state.find_position_value(opposite_corner) != marker
        @position = @board_state.find_position_value(opposite_corner)
        @board_state.take_position(@position, marker)
      end
    end
  end

  def take_empty_corner?
    Board.corners.each do |corner|
      if @board_state.find_position_value(corner) != 'x' && @board_state.find_position_value(corner) != 'o'
        return true
      end
    end
    false
  end

  def take_empty_corner
    empty_corners = []
    Board.corners.each do |corner|
      if @board_state.find_position_value(corner) != 'x' && @board_state.find_position_value(corner) != 'o'
        empty_corners << corner
      end
    end

    empty_corner = empty_corners.sample
    @position = @board_state.find_position_value(empty_corner)
    @board_state.take_position(@position, marker)
  end

  def take_empty_side?
    Board.sides.each do |side|
      if @board_state.find_position_value(side) != 'x' && @board_state.find_position_value(side) != 'o'
        return true
      end
    end
    false
  end

  def take_empty_side
    empty_sides = []
    Board.sides.each do |side|
      if @board_state.find_position_value(side) != 'x' && @board_state.find_position_value(side) != 'o'
        empty_sides << side
      end
    end

    position = empty_sides.sample
    @position = @board_state.board[position.first][position.last]
    @board_state.take_position(@position, marker)
  end
end