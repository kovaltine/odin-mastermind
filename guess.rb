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
    # @output = []
    @output = correct_location
    @output.push(correct_number)
    # p @output.flatten
    @output.flatten
  end

  # make sure ! is added for each num in the right spot
  def correct_location
    # options = %w[1 2 3 4]
    output = []
    @code.each_with_index do |num, index|
      output.push('!') if num == @guess[index]
    end
    # p "correct_location #{output}"
    output
  end

  def correct_number
    saved_numbers = save_list
    # delete the number after it's been used once
    output = []
    index = 0
    @code.length.times do
      if @guess.include?(@code[index]) && !saved_numbers.include?(@code[index])
        saved_numbers.push(@code[index])
        output.push('?')
      end
      # delete one of the saved numbers. if there are two threes get rid of one of them
      # saved_numbers = remove_saved_number(saved_numbers, @code[index])
      # delete the first instance of that number

      index += 1
    end
    # p "correct_location #{output}"
    output
  end

  # remove the first instance of num in the array
  # def remove_saved_number(arr, num)
  #   arr.each do |item|
  #     next unless item == num

  #     p "remove_saved_number #{arr}"
  #     arr.delete(item)
  #     p "remove_saved_number #{arr}"
  #     return arr
  #   end
  #   arr
  # end

  def save_list
    saved = []
    @code.each_with_index do |num, index|
      saved.push(num) if num == @guess[index]
    end
    saved
  end

  # def check_correct_number(num, options_arr)
  #   return true if options_arr.include?(num) && @code.include?(num)

  #   false
  # end

  # def check_number_appearance
  #   num = @guess[index]
  #   i = 0
  #   @guess.map { |item| i += 1 if num == item }
  #   i.times do
  #     @output.push('?')
  #   end
  # end

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
