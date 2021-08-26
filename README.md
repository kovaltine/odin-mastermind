# odin-mastermind
Mastermind game created in ruby according to specifications by The Odin Project

Description:

    This is a console application. A user can choose to make the secret code or try to guess what the computer's secret code is.

    It was created via the Ruby stream of The Odin Project under the heading: Project Mastermind. This was meant to practice new Ruby skills

    The AI isn't very smart. This current version of the program doesn't use strategies besides random guesses. It knows when a guess generates no clues that the numbers in the guess aren't in the end result. It bases its new guess off of the output, but it rarely guesses the correct code.


Future improvements:

    - improve clues. Right now there can be more than one '?' if one of the correct numbers appears in more than one place in the guess. Should just be one '?'
    - create an AI that follows a strategy in order to win. 


How to Use:

    To use this application copy the files and in the console run the command: ruby game.rb
    
    Instructions on how to play are included in the application.