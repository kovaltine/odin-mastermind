# frozen_string_literal: true

require './display'

# let the computer work off of the best guess, and eventually don't let it use the same attempts over again
# AI a little smarter, but still doesnt work how i want it to
# I want it to read the output and make a guess based off of previous attempts

# need to get memory working so it doesn't make the same attempts over and over

# TOP LEVEL COMMENT
class Guess
  include Display

  def initialize
    @previous_guesses = []
    @best_guess = []
    @highest_points = 0
    state_rules
    start_game
  end

  def start_game
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

  # this doesn't save the best guess.
  # let the computer work off of the best guess, and eventually don't let it use the same attempts over again

  # update best_attempt
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

  def calculate_points
    points = 0
    unless @output.empty?
      # '!' will be worth 2 points
      points += @output.count('!') * 2
      # '?' will be worth 1 point
      points += @output.count('?')
    end
    points
  end

  def compare_attempts(current)
    return unless current > @highest_points

    @best_guess = @guess
    @best_output = @output
    @highest_points = current
  end

  def make_output
    @output = []
    @code.each_with_index do |_num, index|
      @output.push('!') if @code[index] == @guess[index]
    end
    @guess.each_index do |index|
      next unless @guess[index] != @code[index]

      @output.push('?') if @guess.any? @code[index]
    end
    @output
  end

  def solved?
    return unless @code == @guess

    @solved = true
    true
  end
end

# computer makes the code
class Computer < Guess
  def make_code
    Array.new(4) { rand(1..4).to_s }
  end

  def input_guess
    puts "Guess the computer's code. You have #{@round} more guesses: "
    gets.chomp.chars
  end

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

# player makes the code
class Player < Guess
  def make_code
    puts 'Enter a four digit code for the computer to guess'
    code = gets.chomp.chars
    while code.length != 4
      puts 'Please enter a 4 digit code'
      code = gets.chomp.chars
    end
    code
  end

  def input_guess
    puts "The computer is guessing your code. It has #{@round} more guesses: "
    # delay the guess
    # sleep 1
    return Array.new(4) { rand(1..4).to_s } if @previous_guesses.empty?

    computer_guess
  end

  def computer_guess
    return empty_output if @output == []

    # next_guess = []

    misplaced_numbers = check_number_placement
    next_guess = right_numbers(misplaced_numbers)

    # next_guess = computer_guess while @previous_guesses.include?(next_guess)
  end

  # don't include the numbers that don't produce any output
  def empty_output
    new_guess = Array.new(4) { rand(1..4).to_s }
    new_guess.each_with_index do |num, index|
      new_guess[index] = rand(1..4).to_s if @guess.include? num
    end
    new_guess
  end

  def check_number_placement
    next_guess = Array.new(4) { rand(1..4).to_s }
    return next_guess if @best_output.nil?

    next_guess = @best_guess

    if @best_output.include?('?')
      x = @best_output.count('?')
      keep = @best_guess.sample(x)
      keep.each { |keeper| next_guess[rand(next_guess.length)] = keeper }
    end

    next_guess = check_number_placement while @previous_guesses.include?(next_guess)
    # next_guess
  end

  def right_numbers(next_guess)
    # return next_guess if @best_output.nil?

    if @best_output.include?('!')
      x = @best_output.count('!')
      keep = @best_guess.sample(x)
      i = 0
      x.times do
        index = @best_guess.index(keep[i])
        next_guess[index] = keep[i]
        i += 1
      end
    end
    next_guess
  end

  def finish_game
    creator = 'Player'
    solver = 'Computer'
    if @solved == true
      puts "Sorry, #{solver} won!"
    else
      puts "Congratulations #{creator}, you won!"
    end
    puts @code.to_s
  end
end
