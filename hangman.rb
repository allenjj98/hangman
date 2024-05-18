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
            check_guess(guess)
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
            puts "Guess a letter: "
            letter = gets.chomp.downcase
            if correct_guesses.include?(letter) || incorrect_guesses.include?(letter)
                puts "You have already guessed the letter #{letter}"
            elsif !ALPHABET.include?(letter)
                puts "You enter a letter between a-z"
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


play = Game.new()
play.play








