class Game
  attr_accessor :player1, :player2

  def initialize
    @board = Board.new
    welcome
    get_players
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
        puts "Do you want the computer to be a bit smart?"
        ans = gets.chomp.downcase
        if ans == 'y'
          @player2.smart = 'on'
        end
      when '2'
        print "First player, "
        @player1 = Human.new(get_player_name)
        print "Second player, "
        @player2 = Human.new(get_player_name)
      end 
    else
      puts "Invalid number of players. Pleae try again."
      get_num_human_players
    end
  end

  def player_num_valid?(player_num)
    true if player_num == '1' || player_num == '2'
  end

  def select_who_goes_first
    puts "Please choose who begins the game:"
    puts "(1) #{@player1.name}"
    puts "(2) #{@player2.name}"
    puts "(3) Random - doesn't matter who goes first"
    
    selection = gets.chomp.to_s

    if selection_valid?(selection)
      case selection
      when '1'
        @player1.marker = 'x'
        @player2.marker = 'o'
      when '2'
        @player2.marker = 'x'
        @player1.marker = 'o'
      when '3'
        markers = ['x', 'o']
        @player1.marker = markers.sample
        @player2.marker = (markers - [@player1.marker])[0]
      end
    else
      puts "Invalid section. Please try again."
      select_who_goes_first
    end
    puts "You've chosen #{selection}."

    if @player2.marker == 'x'
      player = @player1
      self.player1 = @player2
      self.player2 = player
    end

    puts "#{@player1.name} will go first."
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
      puts "Invalid answer. Try again."
      play_again
    end
  end
end