class Game
  attr_accessor :player1, :player2

  def initialize
    @board = Board.new
    welcome
    get_players
    select_marker
    select_who_goes_first
    play
    show_winner
    play_again
  end

  def welcome
    puts "Let's play tic-tac-toe! =)"
    puts "To play, enter the position you want to place your marker as indicated by the numbers. But first please answer a few questions."
    @board.show_board
  end

  def get_players
    puts "Do you want to play against a computer? (Y/N)"
    ans = gets.chomp.to_s

    if ans_valid?(ans)
      case ans
      when 'y'
        self.player1 = Human.new(get_player_name)
        self.player2 = Computer.new(@board)
        select_computer_smart
      when 'n'
        print "First human player, "
        self.player1 = Human.new(get_player_name)
        print "Second human player, "
        self.player2 = Human.new(get_player_name)
      end 
    else
      invalid_try_again
      get_players
    end
  end

  def ans_valid?(ans_valid)
    true if ans_valid == 'y' || ans_valid == 'n'
  end

  def invalid_try_again
    puts "Invalid answer. Pleae try again."
  end

  def select_computer_smart
    puts "Do you want the computer to play 'smart'? (Y/N)"
    ans = gets.chomp.downcase

    if ans_valid?(ans)
      case ans
      when 'y'
        puts "Computer will play 'smart'."
        self.player2.smart = 'on'
      when 'n'
        puts "Computer will play randomly."
      end
    else
      invalid_try_again
      select_computer_smart
    end
  end

  def select_marker
    players = [self.player1, self.player2]
    rand_player = players.sample
    puts "#{rand_player.name}, which marker would you like? ('x' or 'o')"

    marker = gets.chomp.downcase
    if marker_valid?(marker)
      rand_player.marker = marker
      if marker == 'x'
        (players - [rand_player])[0].marker = 'o'
      else
        (players - [rand_player])[0].marker = 'x'
      end
    else
      invalid_try_again
      select_marker
    end
  end

  def marker_valid?(marker)
    true if marker == 'x' || marker == 'o'
  end

  def select_who_goes_first
    puts "Who will begin the game? (1, 2, or 3)"
    puts "(1) #{self.player1.name}-('#{self.player1.marker}')"
    puts "(2) #{self.player2.name}-('#{self.player2.marker}')"
    puts "(3) Random - doesn't matter who goes first"
    
    selection = gets.chomp.to_s

    if selection_valid?(selection)
      case selection
      when '2'
        set_player2_to_go_first
      when '3'
        rand_num = rand(2)
        if rand_num == 1
          set_player2_to_go_first
        end
      end
      
      puts "You've chosen #{selection}. #{self.player1.name}-('#{self.player1.marker}') will go first."
    else
      invalid_try_again
      select_who_goes_first
    end
  end

  def set_player2_to_go_first
    player = self.player1
    self.player1 = self.player2
    self.player2 = player
  end

  def selection_valid?(selection)
    true if selection == '1' || selection == '2' || selection == '3'
  end

  def get_player_name
    puts "Please enter your name:"
    name = gets.chomp.capitalize
  end

  def play
    while !@board.win? && @board.free_space?
      if @board.turn % 2 == 0
        if self.player1.instance_of?(Human)
          position = self.player1.move
          @board.take_position(position, self.player1.marker)
        else
          self.player1.move
        end
      else
        if self.player2.instance_of?(Human)
          position = self.player2.move
          @board.take_position(position, self.player2.marker)
        else
          self.player2.move
        end
      end
      @board.show_board
    end
  end

  def show_winner
    if @board.win? == true
      if @board.turn % 2 == 0
        puts "#{self.player2.name}-('#{self.player2.marker}') wins"
      elsif @board.turn % 1 == 0
        puts "#{self.player1.name}-('#{self.player1.marker}') wins"
      end
    else
      puts "Game over! Tied Game!"
    end
  end

  def play_again
    puts "Do you want to play again? (Y/N)"
    ans = gets.chomp.downcase

    if ans_valid?(ans)
      case ans
      when 'y'
        Game.new
      when 'n'
        puts "Thanks for playing!"
      end
    else
      invalid_try_again
      play_again
    end
  end
end