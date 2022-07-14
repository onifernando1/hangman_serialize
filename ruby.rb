# frozen_string_literal: true

require 'yaml'

class Game
  def initialize
    @word = 'hey'
    @guess = 12
  end

  def random_word
    @fname = 'google-10000-english-no-swears.txt'

    @randnum = rand(1..9893)

    File.open(@fname, 'r') do |file|
      file.readlines.each_with_index do |line, idx|
        @word = line if idx == @randnum
      end
    end
    # puts @word
    @word
  end

  def correct_size_of_word
    until @word.length > 5 && @word.length < 12
      random_word
      puts @word.to_s
      @word
    end
  end

  def make_hint
    if @word.length > 4
      @length = @word.length - 1
      @hint = Array.new(@length, '_')
      p @hint
    end
  end

  def player_guess
    puts "Guess a letter (type 'save' to save/ 'load' to load)"
    @p_guess = gets.chomp.downcase
    if @p_guess != 'save' && @p_guess != 'load' && @p_guess != 'quit' && @p_guess.length > 1 || @p_guess.empty?
      puts 'INVALID'
      # @p_guess = gets.chomp
    end
    @guess -= 1
    @p_guess
  end

  def guesses
    puts "Guesses remaining: #{@guess}"
  end

  def add_to_hint
    if @word.include?(@p_guess)
      @index = (0...@word.length).find_all { |i| @word[i] == @p_guess.to_s }
      @index.each do |index|
        @hint[index] = @word[index]
      end
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

  def save_game
    File.delete('save_game.yml')
    File.open('save_game.yml', 'w') { |file| file.write(YAML.dump(self)) }
    puts 'GAME SAVED'
  end

  def load_game
    file = File.open('save_game.yml', 'r')
    game = YAML.unsafe_load(file)
    puts 'GAME LOADED'
    @p_guess = 'quit'
    game.game_play
  end

  # || @p_guess == "save"
  def round
    until @p_guess == @word || @guess.zero? || @p_guess == 'quit'
      player_guess
      case @p_guess
      when 'save'
        save_game
      when 'load'
        load_game
        puts 'LOADED'
      when 'quit'
        break
      end
      add_to_hint
      check_win

      @guess += 1 if @word.include?(@p_guess)
      guesses

      @guess = 0 if @game_running == false
    end

    puts @word
  end

  def game_play
    correct_size_of_word
    make_hint
    round
  end
end

game = Game.new
game.game_play
