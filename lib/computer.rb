class Computer
  attr_reader :name
  attr_accessor :marker, :smart, :position

  def initialize(board_state)
    @name = 'Computer'
    @board_state = board_state
    @smart = 'off'
  end

  def opponent_marker
    if self.marker == 'x'
      @opponent_marker = 'o'
    else
      @opponent_marker = 'x'
    end
  end

  def move
    if self.smart == 'on'
      return take_or_block_win, statement  if take_or_block_win?
      return take_center, statement  if take_center?
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
    random_position = @board_state.get_free_spaces.sample
    find_pos_val_and_take_pos(random_position)
  end

  def take_or_block_win?
    Board.wins.each do |win|
      markers = []
      win.each do |position|
        markers << @board_state.find_position_value(position)
      end

      if (markers.count(self.marker) == 2 && markers.count(self.opponent_marker) == 0) || (markers.count(self.opponent_marker) == 2 && markers.count(self.marker) == 0)
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

      if markers.count(self.marker) == 2 && markers.count(self.opponent_marker) == 0
        win_positions << (markers - [self.marker]).first
      elsif markers.count(self.opponent_marker) == 2 && markers.count(self.marker) == 0
        block_positions << (markers - [self.opponent_marker]).first
      end
    end

    if !win_positions.empty?
      self.position = win_positions.sample
    else
      self.position = block_positions.sample
    end

    @board_state.take_position(self.position, self.marker)
  end

  def take_center?
    true if @board_state.get_free_spaces.include?(Board.center)
  end

  def take_center
    find_pos_val_and_take_pos(Board.center)
  end

  def take_opposite_corner?
    diagonal_corners = {
      [0,0] => [2,2],
      [0,2] => [2,0],
      [2,0] => [0,2],
      [2,2] => [0,0]
    }

    diagonal_corners.each do |corner, opposite_corner|
      if @board_state.find_position_value(corner) == self.opponent_marker && @board_state.find_position_value(opposite_corner) != self.marker && @board_state.find_position_value(opposite_corner) != self.opponent_marker
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

    opposite_corners = []
    diagonal_corners.each do |corner, opposite_corner|
      if @board_state.find_position_value(corner) == self.opponent_marker && @board_state.find_position_value(opposite_corner) != self.marker
        opposite_corners << opposite_corner
      end
    end

    opposite_corner = opposite_corners.sample
    find_pos_val_and_take_pos(opposite_corner)
  end

  def take_empty_corner?
    Board.corners.each do |corner|
      if @board_state.find_position_value(corner) != self.marker && @board_state.find_position_value(corner) != self.opponent_marker
        return true
      end
    end
    false
  end

  def take_empty_corner
    empty_corners = []
    Board.corners.each do |corner|
      if @board_state.find_position_value(corner) != self.marker && @board_state.find_position_value(corner) != self.opponent_marker
        empty_corners << corner
      end
    end

    empty_corner = empty_corners.sample
    find_pos_val_and_take_pos(empty_corner)
  end

  def take_empty_side?
    Board.sides.each do |side|
      if @board_state.find_position_value(side) != self.marker && @board_state.find_position_value(side) != self.opponent_marker
        return true
      end
    end
    false
  end

  def take_empty_side
    empty_sides = []
    Board.sides.each do |side|
      if @board_state.find_position_value(side) != self.marker && @board_state.find_position_value(side) != self.opponent_marker
        empty_sides << side
      end
    end

    empty_side = empty_sides.sample
    find_pos_val_and_take_pos(empty_side)
  end

  def find_pos_val_and_take_pos(position_coords)
    self.position = @board_state.find_position_value(position_coords)
    @board_state.take_position(self.position, self.marker)
  end
end