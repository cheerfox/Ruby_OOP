class Card
  attr_accessor :suit, :number
  def initialize(suit, number)
    @suit = suit
    @number = number
  end

  def to_s
    "[#{suit}, #{number}]"
  end
end

class Deck
  SUIT = ['C', 'D', 'H', 'S']
  NUMBER = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
  attr_accessor :cards
  def initialize
    @cards = []
    SUIT.product(NUMBER) do |pair|
      @cards << Card.new(pair[0], pair[1])
    end
  end

  def shuffle_deck
    cards.shuffle!
  end

  def deal_a_card
    cards.pop
  end
end

module Hand
  def show_hand
    puts "=====#{name}'s cards====="
    cards.each do |card|
      puts "[#{card.suit}  #{card.number}]"
    end
    puts "Point: #{total_point}"
  end

  def add_a_card(new_card)
    cards << new_card
  end

  def total_point
    point = 0
    numbers = cards.map {|card| card.number}
    numbers.each do |number|
      if number == 'J' || number == 'Q' || number == 'K'
        point += 10
      elsif number == 'A'
        point += 11
      else
        point += number.to_i
      end
    end
    numbers.select {|e| e == 'A'}.count.times do
      point -= 10 if point > 21
    end
    point
  end

  def busted?
    total_point > 21
  end

  def blackjack?
    total_point == 21
  end

end

class Player
  include Hand
  attr_accessor :name, :cards
  def initialize(name)
    self.name = name
    self.cards = []
  end
end

class Dealer
  include Hand
  attr_accessor :name, :cards
  def initialize
    self.name = 'Dealer'
    self.cards = []
  end
end

class Blackjack
  attr_accessor :player, :dealer, :deck, :winner
  def initialize
    puts "What your name??"
    player_name = gets.chomp 
    self.player = Player.new(player_name)
    self.dealer = Dealer.new
    self.deck = Deck.new
    self.winner = ' '
  end

  def hit_or_stay
    begin
      result = ' '
      puts "Hit or Stay press h/s"
      result = gets.chomp.downcase
    end until ['h', 's'].include?(result)
    result
  end

  def initial_round
    2.times { player.add_a_card(deck.deal_a_card)}
    2.times { dealer.add_a_card(deck.deal_a_card)}
    player.show_hand
    dealer.show_hand
  end

  def player_round
    if player.blackjack?
      self.winner = player.name
      puts "Blackjack!!"
      return
    elsif dealer.blackjack?
      self.winner = dealer.name
      puts "Blackjack!!"
      return
    else
      loop do
        if hit_or_stay == 'h'
          player.add_a_card(deck.deal_a_card)
          player.show_hand
          if player.busted?
            self.winner = dealer.name
            puts "#{player.name} is busted!!"
            return
          elsif player.blackjack?
            self.winner = player.name
            puts "Blackjack!!"
            return
          end
        else
          break
        end
      end
    end  
  end

  def dealer_round
    if dealer.blackjack?
      self.winner = dealer.name
      puts "Blackjack!!"
      return
    end
    while dealer.total_point <= 17
      sleep(2)
      dealer.add_a_card(deck.deal_a_card)
      dealer.show_hand
      if dealer.busted?
        self.winner = player.name
        puts "Dealer is busted!!"
        break
      elsif dealer.blackjack?
        self.winner = dealer.name
        puts "Blackjack!!"
        break
      end
    end 
  end

  def compare_point
    if player.total_point > dealer.total_point
      self.winner = player.name
    elsif player.total_point < dealer.total_point
      self.winner = dealer.name
    end
  end

  def end_game
    if winner == ' '
      puts "Tie!!"
    else
      puts "Winner is #{winner}"
    end
  end

  def run
    deck.shuffle_deck
    initial_round
    player_round
    if winner == ' '
      dealer_round
      if winner == ' '
        compare_point
        end_game
      else
        end_game
      end
    else
      end_game
    end
  end
end

def play_again?
  puts "=> Start a new Game? Press 'Y' , Exit? Press 'N' "
  gets.chomp.downcase == 'y'
end

begin
  blackjack = Blackjack.new
  blackjack.run
end while play_again?