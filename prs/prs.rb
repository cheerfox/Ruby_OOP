#classes : Game, Computer, Human
class Player
  attr_accessor :hands

end

class Human < Player
  def pick_hands
    begin
      puts "Choose P/R/S for Paper/Rock/Scissors"
      hands = gets.chomp.downcase
    end until Game::CHOICES.keys.include?(hands)
    puts "You choose #{Game::CHOICES[hands]}"
    self.hands = hands
  end
end

class Computer < Player
  def pick_hands
    self.hands = Game::CHOICES.keys.sample
    puts "Computer pick #{Game::CHOICES[self.hands]}"
  end
end

class Game
  attr_accessor :human, :computer
  CHOICES = {'p' => 'Paper','r' => 'Rock', 's' => 'Scissors'}

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def run
    begin
      human.pick_hands
      computer.pick_hands
      compare
    end until !play_again?
  end

  def compare
    if human.hands == computer.hands
      puts "Tie!!"
    elsif human.hands == 'p' && computer.hands == 'r' || human.hands == 's' && computer.hands == 'p' || human.hands == 'r' && computer.hands == 's'
      puts "You Win!!"
    else
      puts "You Lose!!!"
    end
  end

  def play_again?
    puts "Want to play again??  Y/N"
    gets.chomp.downcase != 'n'
  end
end

game = Game.new
game.run