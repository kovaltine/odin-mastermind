# frozen_string_literal: true

require 'colorize'

# starts the game and generates clues based on the guess
class Guess
  def initialize
    @previous_guesses = []
    @best_guess = []
    @highest_points = 0
    @no_output_numbers = []
    @code = make_code
    @round = 12
    state_rules
    start_game
  end

  def state_rules
    puts 'Guess the code and in the right order. The numbers will be  1-4'
    puts "'!' means a number is in the right place, don't change it"
    puts "'?' means a number is not in the right place, change the location"
  end

  # game logic
  def start_game
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

  # MAKE_OUTPUT

  # generate the clues that coincide with guesses
  def make_output
    @output = correct_location
    @output.push(correct_number)
    @output.flatten
  end

  # ! is added for each num in the right spot
  def correct_location
    output = []
    @code.each_with_index do |num, index|
      output.push('!') if num == @guess[index]
    end
    output
  end

  # ? is added for each num in the guess but not in the right spot
  def correct_number
    saved_numbers = save_list
    output = []
    index = 0
    @code.length.times do
      if @guess.include?(@code[index]) && !saved_numbers.include?(@code[index])
        saved_numbers.push(@code[index])
        output.push('?')
      end

      index += 1
    end
    output
  end

  # make a list of the numbers that are in the right location. Don't add a ? for these
  def save_list
    saved = []
    @code.each_with_index do |num, index|
      saved.push(num) if num == @guess[index]
    end
    saved
  end

  # UPDATE_BEST_GUESS

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

  # this determines which attempt was better
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

  # SOLVED?

  def solved?
    return unless @code == @guess

    @solved = true
    true
  end

  def display_info
    puts "Guess: #{@guess}".colorize(:red)
    puts "Output: #{@output}".colorize(:light_blue)
    puts "\nBest try: #{@best_guess}\n".colorize(:yellow)
  end

  def comp_guess_code
    puts "The computer is guessing your code. It has #{@round} more guesses: "
    sleep 1
  end
end
