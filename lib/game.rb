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
    puts "How many human players? (1 or 2)"
    player_num = gets.chomp.to_s
    if player_num_valid?(player_num)
      case player_num
      when '1'
        @player1 = Human.new(get_player_name)
        @player2 = Computer.new(@board)
        computer_smart?
      when '2'
        print "First player, "
        @player1 = Human.new(get_player_name)
        print "Second player, "
        @player2 = Human.new(get_player_name)
      end 
    else
      invalid_try_again
      get_players
    end
  end

  def invalid_try_again
    puts "Invalid answer. Pleae try again."
  end

  def computer_smart?
    puts "Your opponent will be a computer. Do you want the computer to be a bit smart? (Y/N)"
    ans = gets.chomp.downcase

    if ans == 'y'
      puts "Computer will play a bit smart."
      @player2.smart = 'on'
      return true
    elsif ans == 'n'
      puts "Computer will play randomly."
    else
      invalid_try_again
      computer_smart?
    end
  end

  def player_num_valid?(player_num)
    true if player_num == '1' || player_num == '2'
  end

  def select_marker
    puts "#{@player1.name}, which marker would you like? ('x' / 'o')?"
    marker = gets.chomp.downcase
    if marker_valid?(marker)
      @player1.marker = marker
      if marker == 'x'
        @player2.marker = 'o'
      else
        @player2.marker = 'x'
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
    puts "(1) #{@player1.name}"
    puts "(2) #{@player2.name}"
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
      
      puts "You've chosen #{selection}."

      puts "#{@player1.name}-('#{@player1.marker}') will go first."
    else
      invalid_try_again
      select_who_goes_first
    end
  end

  def set_player2_to_go_first
    player = @player1
    self.player1 = @player2
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
        if @player1.instance_of?(Human)
          position = @player1.move
          @board.take_position(position, @player1.marker)
        else
          @player1.move
        end
      else
        if @player2.instance_of?(Human)
          position = @player2.move
          @board.take_position(position, @player2.marker)
        else
          @player2.move
        end
      end
      @board.show_board
    end
  end

  def show_winner
    @board.winner?(@player1, @player2)
  end

  def play_again
    puts "Do you want to play again? (Y/N)?"
    answer = gets.chomp.downcase
    if answer == 'y'
      Game.new
    elsif answer == 'n'
      puts "Thanks for playing!"
    else
      invalid_try_again
      play_again
    end
  end
end