#classes list
 # Human < Player
 # Computer < Player
 # Board 
 # Game

 class Player
  attr_accessor :choices, :name, :mark
  def initialize(name, mark)
    @name = name
    @mark = mark
    @choices = []
  end
end

class Human < Player
  def pick_position(empty_positions)
    position = 0
    begin
      puts "Choose position from 1 to 9"
      position = gets.chomp.to_i
    end until empty_positions.include?(position)
    @choices << position 
  end
end

class Computer < Player
  def pick_position(empty_positions)
    position = empty_positions.sample
    @choices << position
  end
end

class Board
  attr_accessor :board_data
  
  def initialize
    @board_data = {}
    (1..9).each {|position| @board_data[position] = ' '}
  end

  def board_data_update(choice, mark) 
    @board_data[choice] = mark
  end

  def draw
    system 'clear'
    puts "     |     |     "
    puts "  #{board_data[1]}  |  #{board_data[2]}  |  #{board_data[3]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{board_data[4]}  |  #{board_data[5]}  |  #{board_data[6]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{board_data[7]}  |  #{board_data[8]}  |  #{board_data[9]}  "
    puts "     |     |     "    
  end

  def empty_positions
    positions = board_data.keys.select {|position| board_data[position] == ' '}
    positions
  end

  def is_full?
    empty_positions.empty?
  end

end

class Game
  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]
  attr_accessor :human, :computer, :board, :winner, :current_player

  def initialize(name)
    @human = Human.new(name, 'O')
    @computer = Computer.new('Computer', 'X')
    @board = Board.new
    @current_player = @human
  end

  def switch_current_player
    if current_player == human
      self.current_player = computer
    else
      self.current_player = human
    end
  end

  def is_winner?(player)
    WINNING_LINES.each do |line|
      if (line - player.choices).empty?
        return true
      end
    end
    false
  end

  def is_tie?
    board.is_full?
  end

  def play_again?
    puts " Start a new Game? Press 'Y' , Exit? Press 'N' "
    gets.chomp.downcase == 'y'
  end

  def run
    board.draw
    loop do
      current_player.pick_position(board.empty_positions)
      board.board_data_update(current_player.choices.last, current_player.mark)
      board.draw
      if is_winner?(current_player)
        puts "#{current_player.name} Win!!"
        break
      elsif is_tie?
        puts "Tie!!"
        break
      end
      switch_current_player
    end
  end

end

loop do
  game = Game.new('Bob')
  game.run
  break unless game.play_again?
end