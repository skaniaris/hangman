require "yaml"

module Serializable

    def save_game

        puts "Would you like to save and quit the game? y/n"
        answer = gets.chomp.downcase 

        if answer == "y" 
            files = File.open("saved.yml", "w") do |file| YAML.dump([] << self, file)
            exit 
            end 
        end 
    end 

    def load_game
        yaml = YAML.load_file("saved.yml")
        self.display_word = yaml[0].display_word
        self.guess_word = yaml[0].guess_word
        self.@hidden_display = yaml[0].@hidden_display
    end 
end 


class Hangman

    include Serializable

    def initialize

        @hidden_display = Array.new 
        @letter_guess = ""
        @wrong_letters = ""
        @computer_word = ""
        @display_guess = Array.new
        @number_of_guesses = 6 
        puts "HANGMAN"
        puts "Would you like to load the game? y/n"
        answer = gets.chomp.downcase
        p answer 
        if answer == "y"
            p "loading game"
            load_game
        end 
        if answer == "n"
            p "answer is n"
            select_word
        end   
    end  

    def select_word
        p "selecting word"
        dictionary = File.open("google-10000-english-no-swears.txt")
        @computer_word = dictionary.readlines.sample.chomp

        while @computer_word.nil? || @computer_word.length < 5 || @computer_word.length > 12 
            if @computer_word.nil?
                dictionary.rewind
                @computer_word = dictionary.readlines.sample.to_s.chomp 
            else
                dictionary.rewind  
                @computer_word = dictionary.readlines.sample.to_s.chomp
            end
        end 

        @display_guess = @computer_word.split("")
        dictionary.close
        display_word 
    end 

    def display_word 
        p @display_guess
        i = 0 
        while i < @display_guess.length
            print " _ "
            i += 1 
        end 
        puts "\n\n"
        guess_word 
    end 
    
    def guess_word

        @hidden_display = Array.new(@display_guess.length, "_")
        correct = false 
        i = 0 

        while i <= @number_of_guesses
            if @number_of_guesses == 0 
                p "You lose, the word was #{@computer_word.chomp}."
                replay_game
                return
            end 

            save_game 

            puts "You have #{@number_of_guesses} guesses." 
            @letter_guess = gets.chomp

            @display_guess.each_with_index do |letter, index|
                if @letter_guess == letter 
                    @hidden_display[index] = @letter_guess
                end 
                
                if @hidden_display == @display_guess
                    p "You win!"
                    replay_game
                    return
                end 
            end  
                
                if !(@display_guess.include?(@letter_guess)) 
                    @wrong_letters = @wrong_letters + @letter_guess
                    @number_of_guesses = @number_of_guesses - 1      
                end

                p "incorrect letters: #{@wrong_letters}"
                p @hidden_display
                puts "\n"
        end 
    end 

    def replay_game

        p "Do you want to replay y/n?"
        answer = gets.chomp 

        if answer == "y" 
            new_game = Hangman.new 
        elsif answer == "n" 
            return 
        else 
            p "That answer is invalid."
            replay_game
        end 
    end 
end 

game = Hangman.new