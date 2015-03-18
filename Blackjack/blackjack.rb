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

  def is_busted?
    total_point > 21
  end

  def is_blackjack?
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

  def show_one_card_only
    puts "=====#{name}'s cards====="
    puts "First card is hidden"
    puts "[#{cards[1].suit}  #{cards[1].number}]"
  end
end

class Blackjack
  attr_accessor :player, :dealer, :deck
  def initialize
    puts "What your name??"
    player_name = gets.chomp 
    self.player = Player.new(player_name)
    self.dealer = Dealer.new
    self.deck = Deck.new
  end

  def blackjack_or_busted(player_or_dealer)
    if player_or_dealer.is_a?(Player)
      if player_or_dealer.is_busted?
        puts "#{player_or_dealer.name} busted!!"
        puts "Dealer Wins!!"
        play_again?
      elsif player_or_dealer.is_blackjack?
        puts "Blackjack!!"
        puts "#{player_or_dealer.name} Win!!!"
        play_again?
      end
    elsif player_or_dealer.is_a?(Dealer)
      if player_or_dealer.is_busted?
        puts "Dealer busted!!!"
        puts "You Win!!!"
        play_again?
      elsif player_or_dealer.is_blackjack?
        puts "Blackjack!!"
        puts "Dealer Wins!!"
        play_again?
      end
    end
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
    dealer.show_one_card_only
  end

  def player_round
    blackjack_or_busted(player)
    loop do
      if hit_or_stay == 'h'
        player.add_a_card(deck.deal_a_card)
        player.show_hand
        blackjack_or_busted(player)
      else
        break
      end
    end
  end  

  def dealer_round
    blackjack_or_busted(dealer)
    while dealer.total_point <= 17
      sleep(2)
      dealer.add_a_card(deck.deal_a_card)
      dealer.show_hand
      blackjack_or_busted(dealer)
    end 
    dealer.show_hand
  end

  def compare_point
    if player.total_point > dealer.total_point
      puts "#{player.name} Wins!!"
    elsif player.total_point < dealer.total_point
      puts "Dealer Wins!!"
    else
      puts "Tie!!!"
    end
    play_again?
  end

  def run
    deck.shuffle_deck
    initial_round
    player_round
    dealer_round
    compare_point
  end

  def reset
    system('clear')
    puts "Start a new game!!"
    deck = Deck.new
    player.cards = []
    dealer.cards = []
  end

  def play_again?
    puts "=> Start a new Game? Press 'Y' , Exit? Press 'N' "
    if gets.chomp.downcase == 'y'
      reset
      run
    else
      exit
    end
  end
end

blackjack = Blackjack.new
blackjack.run