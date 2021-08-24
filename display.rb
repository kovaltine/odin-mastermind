# frozen_string_literal: true

require 'colorize'

# display information to the user
module Display
  def state_rules
    puts 'Guess the code and in the right order. The numbers will be  1-4'
    puts "'!' means a number is in the right place, don't change it"
    puts "'?' means a number is not in the right place, change the location"
  end

  def display_info
    puts "Guess: #{@guess}".colorize(:red)
    puts "Output: #{@output}".colorize(:light_blue)
    puts "Previous guesses: #{@previous_guesses}"
    puts "\nBest try: #{@best_guess}\n".colorize(:yellow)
  end
end
