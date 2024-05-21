require "yaml"

module Letters
    ALPHABET = ("a".."z").to_a
end



class Game
    include Letters
    attr_reader :dict_words, :secret_word, :incorrect_guesses
    attr_accessor :correct_guesses, :guesses

    def initialize
        @dict_words = File.readlines("google-10000-english-no-swears.txt")
        @secret_word = random_select_word

        @correct_guesses = display_correct_guesses

        @guesses = 8
        @incorrect_guesses = []
    end


    # continue to allow the user to guess until they have run out of guesses
    def play
        until guesses == 0
            guess = user_make_guess
            if guess == "save"
                serialize
                return
            else
                check_guess(guess)
                if user_has_won?
                    next
                else
                    puts "You have successfully guessed the secret word"
                    return
                end
            end
        end
        puts "You are out of guesses. The secret word was #{secret_word}"
    end

    def user_has_won?
        correct_guesses.any?("_")
    end


    # allow the user to save their current game. Check to see if the file name already in use.
    def serialize
        while true
            puts "Enter a file name: "
            file_name = gets.chomp.concat(".yaml")
            if File.exist?(file_name)
                puts "File name already in use. Enter another name!"
                next
            else
                File.open(file_name, "w") do |file|
                    file.write(YAML::dump(self))
                end
                return
            end
        end
    end

    

    



    # need to randomly select a word from the dictionary. This word has to be between 5 and 12 characters.
    def random_select_word
        filtered_dict = dict_words.select do |word|
            word.chomp.length >= 5 and word.chomp.length <= 12
        end
        filtered_dict.sample.chomp.downcase
    end

    # display the letters correctly guessed by the user. When initialised, this needs to represent the length of the secret words with underscores.
    def display_correct_guesses
        Array.new(secret_word.length, "_")
    end

    def user_make_guess
        while true
            puts "You have #{guesses} guesses remaining!"
            puts "Guess a letter or save game ('save'): "
            letter = gets.chomp.downcase
            if correct_guesses.include?(letter) || incorrect_guesses.include?(letter)
                puts "You have already guessed the letter #{letter}"
            elsif letter == "save"
                return letter
            elsif !ALPHABET.include?(letter)
                puts "You must enter a letter between a-z"
            else
                @guesses -= 1
                return letter
            end
        end
    end

    def check_guess(guess)
        array_secret_word = secret_word.split("")
        if array_secret_word.any?(guess)
            array_secret_word.each_with_index do |letter, index|
                if guess == letter
                    correct_guesses[index] = guess
                end
            end
        else
            incorrect_guesses.push(guess)
        end
        p "Your guess: #{correct_guesses.join(" ")}"
        puts "Incorrect letters: #{incorrect_guesses}" 
    end
end


def deserialise
    while true
        puts "Enter the name of the file you would like to load"
        load_file = gets.chomp.concat(".yaml")
        if File.exist?(load_file)
            File.open(load_file, "r") do |file|
                loaded_game = YAML.unsafe_load_file(file)
                return loaded_game
            end
        else
            puts "File does not exist!"
            next
        end
    end
end




puts "Would you like to load a previous game? (y/n): "
load_game_yes_no = gets.chomp.downcase
if load_game_yes_no == "y"
    play_loaded_game = deserialise
    play_loaded_game.play
else
    game = Game.new()
    game.play
end