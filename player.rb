# frozen_string_literal: true

require './guess'
require './display'

# player makes the code
class Player < Guess
  def enter_code
    puts 'Enter a four digit code for the computer to guess'
  end

  # player makes the code via valid numbers
  def make_code
    enter_code
    code = gets.chomp.chars
    valid_input?(code) ? code : make_code
  end

  # MAKE SURE CODE IS VALID

  def valid_input?(guess)
    return false if guess.length < 4

    guess.map do |char|
      return false unless char.to_i.between?(1, 4)
    end
    true
  end

  # COMPUTER GUESS

  # computer's guess cannot be the same as previous ones
  def input_guess
    comp_guess_code
    return Array.new(4) { rand(1..4).to_s } if @previous_guesses.empty?

    guess = computer_guess
    @previous_guesses.include?(guess) ? comp_guess_again : guess
  end

  # computer's next guess is based on output
  def computer_guess
    if @output == []
      @no_output_numbers = @no_output_numbers.push(@guess).flatten.uniq!
      return empty_output
    end

    misplaced_numbers = check_number_placement
    guess = right_numbers(misplaced_numbers)
    empty_output(guess)
  end

  # INTERPRETING OUTPUT

  # don't include the numbers that don't produce any output
  def empty_output(new_guess = Array.new(4) { rand(1..4).to_s })
    return new_guess if @no_output_numbers.empty?

    options = %w[1 2 3 4]

    leftovers = find_options(options)
    replace_num(new_guess, leftovers)
  end

  # a '?' means there is number misplaced
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

  # a '!' means there is a number in the right spot
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

  # GUESSING NUMBERS BASED ON OUTPUT

  # remove numbers from options arr if they don't generate any output
  def find_options(arr)
    @no_output_numbers.map do |num|
      arr.delete_if { |option| option == num }
    end
    arr
  end

  # find all the no_output nums and replace it with one from options arr
  def replace_num(guess, options)
    new_guess = []

    guess.each_with_index do |num, _index|
      if @no_output_numbers.include?(num)
        new_guess.push(options[rand(options.length)])
      else
        new_guess.push(num)
      end
    end
    new_guess
  end

  # end message
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

  def comp_guess_again
    puts "\nThe computer has already made that guess"
    puts 'Recalculating....'
    input_guess
  end
end
