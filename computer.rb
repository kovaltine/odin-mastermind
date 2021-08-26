# frozen_string_literal: true

require './guess'

# computer makes the code
class Computer < Guess
  # generates a code from random numbers
  def make_code
    Array.new(4) { rand(1..4).to_s }
  end

  def input_guess
    puts "\nGuess the computer's code. You have #{@round} more guesses: "
    guess = gets.chomp.chars
    valid_input?(guess) ? guess : try_guess_again
  end

  # if user puts an invalid code they can try again
  def try_guess_again
    puts "\nInvalid guess"
    state_rules
    input_guess
  end

  # finish_game is different depending on who the solver is
  def finish_game
    creator = 'Computer'
    solver = 'Player'
    if @solved == true
      puts "#{solver}! you won!"
    else
      puts "Sorry, #{creator} won!"
    end
    puts @code.to_s
  end
end
