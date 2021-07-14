# frozen_string_literal: true

# let the computer work off of the best guess, and eventually don't let it use the same attempts over again
# AI a little smarter, but still doesnt work how i want it to
# I want it to read the output and make a guess based off of previous attempts

# need to get memory working so it doesn't make the same attempts over and over

# TOP LEVEL COMMENT
# when do you use a module vs a class?
class Guess
  def initialize
    @guess = []
    @round = 1
    @solved = false
    @code = []
    @output = []
    @best_attempt = []
    @best_output = []
    # @attempts = []
    state_rules
    check_guess
  end

  def state_rules
    puts 'Guess the code and in the right order. The numbers will be  1-4'
    puts "'!' means a number is in the right place, don't change it"
    puts "'?' means a number is not in the right place, change the location"
  end

  def check_guess
    @code = make_code
    12.times do
      @guess = input_guess
      # if @round == 1

      #   @attempts.push([@guess])
      # else
      #   check_unique_guess
      # end

      # puts "Attempts: #{@attempts}"
      display_info
      @round += 1
      break if solved?
    end
    finish_game
  end

  def display_info
    puts "Guess: #{@guess}"
    @output = make_output
    puts "Output: #{@output}"
    best_guess
    # puts "\nbest output: #{@best_output}"
    puts "\nBest try: #{@best_attempt}\n"
  end

  # def check_unique_guess
  #   # @guess = input_guess
  #   @attempts.each do |arr|
  #     @guess = input_guess until @guess != arr
  #   end
  #   @attempts.push([@guess])
  # end
  # display info function

  def best_guess
    # let the computer work off of the best guess, and eventually don't let it use the same attempts over again
    if @round == 1
      @best_attempt = @guess
      @best_output = @output
    elsif @output.count('!') >= @best_output.count('!')
      @best_attempt = @guess
      @best_output = @output
      if @output.count('?') > @best_output.count('?')
        @best_attempt = @guess
        @best_output = @output
      end
    end
  end

  def make_output
    @output = []
    @code.each_with_index do |_num, index|
      @output.push('!') if @code[index] == @guess[index]
    end
    @guess.each_index do |index|
      # exclude cases where they're an exact match
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
    Array.new(4) { |_i| rand(1..4).to_s }
  end

  def input_guess
    puts "Guess the computer's code. Round: #{@round}"
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
  # need to put in conditions so it's the right input
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
    puts "The computer is guessing your code. Round: #{@round}"
    # can i put a delay here so it doesn't guess instantly?
    return Array.new(4) { rand(1..4).to_s } if @round == 1

    if @output == []
      analyze_output
    else
      check_number_guess = misplaced_numbers
      right_numbers(check_number_guess)
    end
  end

  def analyze_output
    new_guess = Array.new(4) { rand(1..4).to_s }
    new_guess.each_with_index do |num, index|
      new_guess[index] = rand(1..4).to_s if @guess.include? num
    end
  end

  def misplaced_numbers
    next_guess = Array.new(4) { rand(1..4).to_s }
    if @best_output.include?('?')
      x = @best_output.count('?')
      keep = @best_attempt.sample(x)
      keep.each { |keeper| next_guess[rand(next_guess.length)] = keeper }
    end

    next_guess
  end

  def right_numbers(next_guess)
    if @best_output.include?('!')
      x = @best_output.count('!')
      keep = @best_attempt.sample(x)
      i = 0
      x.times do
        index = @best_attempt.index(keep[i])
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

def play_game
  flag = true
  while flag
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

# start the game
play_game
