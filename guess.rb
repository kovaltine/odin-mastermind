# frozen_string_literal: true

require 'colorize'

# starts the game and generates clues based on the guess
class Guess
  def initialize
    @previous_guesses = []
    @best_guess = []
    @highest_points = 0
    @no_output_numbers = []
    start_game
  end

  # game logic
  def start_game
    state_rules
    @code = make_code
    @round = 12
    while @round.positive?
      @guess = input_guess
      @output = make_output
      update_best_guess
      display_info
      @round -= 1
      break if solved?
    end
    finish_game
  end

  # update best_attempt and previous_guesses
  def update_best_guess
    if @previous_guesses.empty?
      @best_guess = @guess
      @best_output = @output

      @previous_guesses.push(@guess)
      return
    end

    @previous_guesses.push(@guess)
    points = calculate_points
    compare_attempts(points)
  end

  # this determines the weight of the output. which attempt was better
  def calculate_points
    points = 0
    unless @output.empty?
      # '!' will be worth 3 points
      points += @output.count('!') * 3
      # '?' will be worth 1 point
      points += @output.count('?')
    end
    points
  end

  # using the points reassign best attempts
  def compare_attempts(current)
    return unless current > @highest_points

    @best_guess = @guess
    @highest_points = current
  end

  # generate the clues that coincide with guesses
  def make_output
    @output = []
    @output = correct_location
  end

  # check correct location first, add '!'
  def correct_location
    options = %w[1 2 3 4]
    @code.each_with_index do |num, index|
      if num == @guess[index]
        @output.push('!')
      elsif num != @guess[index]
        check_correct_number(@guess[index], options) ? @output.push('?') : next
        options.delete_if { |option| option == num }
      end
    end
    @output
  end

  def check_correct_number(num, options_arr)
    return true if options_arr.include?(num) && @code.include?(num)

    false
  end

  def solved?
    return unless @code == @guess

    @solved = true
    true
  end

  # make sure that user inputs valid data
  def valid_input?(guess)
    return false if guess.length < 4

    guess.map do |char|
      return false unless char.to_i.between?(1, 4)
    end
    true
  end

  def state_rules
    puts 'Guess the code and in the right order. The numbers will be  1-4'
    puts "'!' means a number is in the right place, don't change it"
    puts "'?' means a number is not in the right place, change the location"
  end

  def display_info
    puts "Guess: #{@guess}".colorize(:red)
    puts "Output: #{@output}".colorize(:light_blue)
    puts "\nBest try: #{@best_guess}\n".colorize(:yellow)
  end
end
