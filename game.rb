# frozen_string_literal: true

require './guess'
require './computer'
require './player'

def play_mastermind
  flag = true
  while flag
    system('clear')
    puts 'Welcome to Mastermind'
    puts 'Would you like to be the creator of the secret code? y/n'
    input = gets.chomp.downcase
    input == 'y' ? Player.new : Computer.new
    flag = play_again?
  end
end

def play_again?
  puts 'Would you like to play again? y/n'
  again = gets.chomp.downcase
  case again
  when 'y'
    true
  else
    false
  end
end

play_mastermind
