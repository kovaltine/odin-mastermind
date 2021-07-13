# frozen_string_literal: true

# everything runs, but the computer is more lucky than smart

# TOP LEVEL COMMENT
# when do you use a module vs a class?
class Guess
  def initialize
    @guess = []
    @round = 1
    @solved = false
    @code = []
    @output = []
    # @best_attempt = []
    # @best_output = []
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
      puts "Guess: #{@guess}"
      @output = make_output
      puts "Output: #{@output}"
      # puts "Best try: #{@best_attempt}"
      @round += 1
      break if solved?
    end
    finish_game
  end

  # display info function

  # def best_guess
  #   #the best attempt coincides with the output that makes the most exclamation points
  #   #let the computer work off of the best guess, and eventually don't let it use the same attempts over again
  #   if @output.includes?('!')
  #     x = @output.count('!')
  #     if x > @best_output.count('!')
  #       @best_attempt = @guess
  #     end
  #   end

  # end

  # make it so there's only one ? for every misplaced number
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
    # if @output.count('!') > @best_output.count('!')
    #   @best_output = @output
    #   @best_guess = @guess
    # end
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
  # def initialize
  #   @guessed_num = []
  # end

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
    return Array.new(4) { rand(1..4).to_s } if @round == 1

    exclude_num_guess = analyze_output
    check_number_guess = misplaced_numbers(exclude_num_guess)
    right_numbers(check_number_guess)
  end

  # if the output in empty, then the code does not include any numbers in the guess
  def analyze_output
    new_guess = Array.new(4) { rand(1..4).to_s }
    if @output.empty?
      # @guessed_num.push(@guess)
      new_guess = Array.new(4) { rand(1..4).to_s }
      # new_guess.each_index do |index|
      #   new_guess[index] = rand(1..4).to_s while @guessed_num.include?(new_guess[index])
      # end
    end
    new_guess
  end

  def misplaced_numbers(next_guess)
    if @output.include?('?')
      x = @output.count('?')
      keep = @guess.sample(x)
      keep.each { |keeper| next_guess[rand(@guess.length)] = keeper }
    end
    next_guess
  end

  def right_numbers(next_guess)
    if @output.include?('!')
      x = @output.count('!')
      keep = @guess.sample(x)
      i = 0
      x.times do
        index = @guess.index(keep[i])
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
    # case input
    # when 'y'
    #   Player.new
    # else
    #   Computer.new
    # end
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
