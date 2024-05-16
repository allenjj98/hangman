module Letters
    ALPHABET = ("a".."z").to_a
end



class Game
    include Letters
    attr_reader :dict_words, :secret_word
    attr_accessor :correct_guesses

    def initialize
        @dict_words = File.readlines("google-10000-english-no-swears.txt")
        @secret_word = random_select_word

        @correct_guesses = display_correct_guesses

        @guesses = 0
        @incorrect_guesses = []
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
        "_ " * secret_word.length
    end

    def user_make_guess
        while true
            puts "Guess a letter: "
            letter = gets.chomp.downcase
            if ALPHABET.include?(letter)
                return letter
            else
                next
            end
        end
    end


end


play = Game.new()
play.user_make_guess






