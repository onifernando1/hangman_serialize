# frozen_string_literal: true
class Start
    attr_reader :word, :hint
    attr_accessor :game_running
  
    def initialize
      @word = 'hey'
      @game_running = true
    end
  
    def random_word
      @fname = "google-10000-english-no-swears.txt"
      
      @randnum = rand(1..9893)
  
      File.open(@fname, 'r') do |file|
        file.readlines.each_with_index do |line, idx|
          @word = line if idx == @randnum
        end
      end
      # puts @word
      @word
    end
  
    def make_hint
      if @word.length > 3
        @length = @word.length - 1
        @hint = Array.new(@length, '_')
      end
    end
  end
  
  class Player
    attr_reader :p_guess
    attr_accessor :guess
  
    def initialize
      @p_guess = 'AB'
      @guess = 12
    end
  
    def guesses
      puts "Guesses remaining: #{@guess}"
    end
  
    def player_guess
      puts 'Guess a letter'
      @p_guess = gets.chomp.downcase
      if @p_guess.length > 1 || @p_guess.empty?
        puts 'INVALID'
        @p_guess = gets.chomp
      end
      @guess -= 1
      @p_guess
    end
  end
  
  class Game
    attr_reader :game_running, :correct
    attr_accessor :guess
  
    def initialize(p_guess, word, hint)
      @p_guess = p_guess
      @word = word
      @hint = hint
      @game_running = true
      @correct = false
    end
  
    def add_to_hint
      if @word.include?(@p_guess)
        @index = (0...@word.length).find_all { |i| @word[i] == @p_guess.to_s }
        @index.each do |index|
          @hint[index] = @word[index]
        end
        @correct = true
        puts correct.to_s
      end
      p @hint
    end
  
    def check_win
      joined_hint = @hint.join('')
      joined_hint = joined_hint.to_s
      word = @word.strip
      word = word.to_s
      if joined_hint == word
        puts 'YOU WIN!'
        @game_running = false
      end
    end
  end
  
  class Round
  
    def start_game
      player = Player.new
      start = Start.new
      until start.word.length >= 5 && start.word.length <= 12
        start.random_word
        start.make_hint
      end
  
      until player.p_guess == start.word || player.guess.zero?
        player.player_guess
        game = Game.new(player.p_guess, start.word, start.hint)
  
        game.add_to_hint
        game.check_win
  
        if game.correct == true
          player.guess += 1
          # puts "#NEW #{player.guess}"
        end
        player.guesses
  
        player.guess = 0 if game.game_running == false
      end
  
      puts start.word
    end
  end
  round = Round.new
  round.start_game
  
  # stop same letter being entered
  # save game
  # resume game
  