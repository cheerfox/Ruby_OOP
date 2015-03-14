#classes : Game, Computer, Human
#Add Comparable module 
#Add winning message 
class Hand
  attr_accessor :value
  include Comparable

  def initialize(value)
    @value = value
  end

  def <=>(another_hand)
    if value == another_hand.value
      0
    elsif (value == 'p' && another_hand.value == 'r') || (value == 's' && another_hand.value == 'p') || (value == 'r' && another_hand == 's')
      1
    else
      -1
    end
  end
end

class Player
  attr_accessor :hand
end

class Human < Player
  def pick_hand
    begin
      puts "Choose P/R/S for Paper/Rock/Scissors"
      choice = gets.chomp.downcase
    end until Game::CHOICES.keys.include?(choice)
    self.hand = Hand.new(choice)
    puts "You choose #{Game::CHOICES[hand.value]}"
  end
end

class Computer < Player
  def pick_hand
    self.hand = Hand.new(Game::CHOICES.keys.sample)
    puts "Computer pick #{Game::CHOICES[hand.value]}"
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
      human.pick_hand
      computer.pick_hand
      compare_hands
    end until !play_again?
  end

  def compare_hands 
    if human.hand == computer.hand
      puts "Tie!!"
    elsif human.hand > computer.hand
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

game = Game.new.run