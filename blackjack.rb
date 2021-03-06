class Card
  attr_reader :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def display_card
    "#{@value} of #{@suit}"
  end
end

class Deck
  def initialize
    @cards = []
    suits = [:diamonds, :hearts, :clubs, :spades]
    suits.each do |suit|
      (2..14).each do |value|
        @cards << Card.new(suit, value)
      end
    end
  end

  def count
    @cards.count
  end

  def shuffle
    @cards.shuffle!
  end

  def deal
    @cards.shift.display_card
  end

  def display_deck
    @cards.map do |card|
      card.display_card
    end
  end
end

class Hand
  attr_accessor :cards_in_hand

  def initialize
    @cards_in_hand = []
  end

  def add_to_hand(dealt_card)
    @cards_in_hand.push(dealt_card)
  end

  def calc_total
    total = 0
    @cards_in_hand.map do |card|
      if card.to_i > 10
        if card.to_i == 14
          card = 11
        else card.to_i == 10
        end
      end
      total += card.to_i
    end
    total
  end
end

class Game
  def get_player_input
    puts "(h)it or (s)tay?"
    puts
    gets.chomp.downcase
  end

  def card_corrector(card)
    if card[0..1].to_i > 10
      card_strings = card.split
      if card_strings[0] == "11"
        card_strings[0] = "J"
      elsif card_strings[0] == "12"
        card_strings[0] = "Q"
      elsif card_strings[0] == "13"
        card_strings[0] = "K"
      else card_strings[0] = "A"
      end
      card = card_strings.join(" ")
    end
    puts card
  end

  def run
    deck = Deck.new
    deck.shuffle

    player = Hand.new
    dealer = Hand.new

    2.times do
      player.add_to_hand(deck.deal)
      dealer.add_to_hand(deck.deal)
    end

    puts 'Your hand:'
    player.cards_in_hand.each do |card|
      card_corrector(card)
    end

    puts
    puts 'Dealer hand:'
    puts 'Unknown'
    card_corrector(dealer.cards_in_hand[1])

    puts
    puts "Player total: #{player.calc_total}"
    puts

    if player.calc_total == 21
      puts "You got a blackjack! Congrats."
      player.cards_in_hand.each do |card|
        card_corrector(card)
      end
    elsif player.calc_total > 21
      puts "Bust! Dealer automajically wins."
    elsif dealer.calc_total == 21
      puts "Dealer got a blackjack! Tough luck."
    elsif dealer.calc_total > 21
      puts "Dealer busts. You got lucky this time!"
    else
      loop_break = false
      loop do
        if loop_break
          break
        elsif player.calc_total < 21
          if get_player_input == "h" || get_player_input == "hit"
            puts "Hit:"
            player.add_to_hand(deck.deal)
            puts card_corrector(player.cards_in_hand.last)
          elsif get_player_input == "s" || get_player_input == "stay"
            puts "Stay. Wise choice."
            loop_break = true
          elsif get_player_input == "q" || get_player_input == "quit"
            break
          else
            puts "I don't understand. Do you want to (h)it or (s)tay?"
          end
        elsif player.calc_total == 21
          puts "Blackjack! You win!"
          break
        else
          puts "Bust! Dealer wins this one."
          break
        end
        puts "Player's total: #{player.calc_total}"
        puts
      end

      if player.calc_total < 21
        loop do
          if dealer.calc_total == 21
            puts "Dealer has a blackjack! You lose."
            break
          elsif dealer.calc_total < 16
            dealer.add_to_hand(deck.deal)
            puts "Dealer hits"
            puts card_corrector(dealer.cards_in_hand.last)
          elsif dealer.calc_total < 21
            puts "Dealer stays"
            break
          else
            puts "Dealer busts. You win!"
            break
          end
        end
      end

      puts
      puts "Player's hand:"
      player.cards_in_hand.each do |card|
        card_corrector(card)
      end
      player.calc_total

      puts
      puts "Dealer's hand:"
      dealer.cards_in_hand.each do |card|
        card_corrector(card)
      end
      dealer.calc_total

      if dealer.calc_total < 21 && player.calc_total < 21
        if player.calc_total <= dealer.calc_total
          puts "Dealer's hand is higher. You lose!"
        elsif player.calc_total > dealer.calc_total
          puts "Your hand wins!"
        else
          puts "Bust! You both lose!"
        end
      end
    end
  end
end

system('clear')
puts "Welcome to Kate's Jacked Game of Blackjack! Would you like to play?"
looped = false

loop do
  if looped
    puts
    puts "Play again?"
  end

  puts "Please type either (y)es or (n)o or (q) to quit"
  user_play = gets.chomp.downcase

  if user_play == "yes" || user_play == "y"
    system('clear')
    Game.new.run
  elsif user_play == "no" || user_play == "n"
    if looped
      puts "Sorry to hear that. Come back when you want to play!"
    else
      puts "Come back when you want to lose again!"
    end
    break
  elsif user_play == "quit" || user_play == "q"
    break
  else
    puts "Kate's Jacked Game of Blackjack doesn't understand. Please enter (y)es or (n)o or q to quit."
  end
  looped = true
end
