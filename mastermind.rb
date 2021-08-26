# frozen_string_literal: true

require './display'

# guess class makes the code, tracks guesses, and starts game
class Guess
  include Display

  def initialize
    @previous_guesses = []
    @best_guess = []
    @highest_points = 0
    @no_output_numbers = []
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

      @output.push('?') if @guess.include? @code[index]
    end
    @output
  end

  def solved?
    return unless @code == @guess

    @solved = true
    true
  end

  def valid_input?(guess)
    return false if guess.length < 4

    guess.map do |char|
      return false unless char.to_i.between?(1, 4)
    end
    true
  end
end

# computer makes the code
class Computer < Guess
  def make_code
    Array.new(4) { rand(1..4).to_s }
  end

  def input_guess
    puts "\nGuess the computer's code. You have #{@round} more guesses: "
    guess = gets.chomp.chars
    valid_input?(guess) ? guess : try_guess_again
  end

  def try_guess_again
    puts "\nInvalid guess"
    state_rules
    input_guess
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
    valid_input?(code) ? code : make_code
  end

  def input_guess
    puts "The computer is guessing your code. It has #{@round} more guesses: "
    sleep 1
    return Array.new(4) { rand(1..4).to_s } if @previous_guesses.empty?

    guess = computer_guess

    @previous_guesses.include?(guess) ? try_guess_again : guess
  end

  def try_guess_again
    puts 'The computer has already made that guess'
    puts 'Recalculating....'
    input_guess
  end

  def computer_guess
    if @output == []
      @no_output_numbers = @no_output_numbers.push(@guess).flatten.uniq!
      return empty_output
    end

    puts "no output numbers #{@no_output_numbers}"
    misplaced_numbers = check_number_placement
    guess = right_numbers(misplaced_numbers)
    empty_output(guess)
  end

  # don't include the numbers that don't produce any output
  def empty_output(new_guess = Array.new(4) { rand(1..4).to_s })
    return new_guess if @no_output_numbers.empty?

    options = %w[1 2 3 4]

    leftovers = find_options(options)
    replace_num(new_guess, leftovers)
  end

  def find_options(arr)
    @no_output_numbers.map do |num|
      arr.delete_if { |option| option == num }
    end
    puts "options #{arr}"
    arr
  end

  # find all the no_output nums and replace it with a different one
  def replace_num(guess, options)
    puts "new_guess before exclusions #{guess}"
    new_guess = []

    # p array.map { |x| x == 4 ? 'Z' : x }
    guess.each_with_index do |num, index|
      # might have to put a condition if it's nil/empty?
      if @no_output_numbers[index] == num
        new_guess.push(options[rand(options.length)])
      else
        new_guess.push(num)
      end
      # guess.map do |x|
      #   if x == num
      #     new_guess.push(options[rand(options.length)])
      #   else
      #     new_guess.push(x)
      #   end

      # if new_guess.include?(num)
    end

    # new_guess.each_with_index do |num, index|
    #   if
    #   var = options[rand(options.length)]
    #   puts "var from replace_num #{var}"
    #   new_guess[index] = num
    # end

    puts "new_guess replace_num #{new_guess}"
    new_guess
  end

  def check_number_placement
    next_guess = Array.new(4) { rand(1..4).to_s }
    return next_guess if @best_output.empty?

    if @best_output.include?('?')
      x = @best_output.count('?')
      keep = @best_guess.sample(x)
      keep.each { |keeper| next_guess[rand(next_guess.length)] = keeper }
    end
    next_guess
  end

  def right_numbers(next_guess)
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
