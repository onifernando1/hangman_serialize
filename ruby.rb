# #Put everything into one class
# # stop same letter being entered
# # save game
# # resume game


class Game 
  
  def initialize
    @word = 'hey'
  #   # @game_running = true
  #   # @p_guess = 'AB'
    @guess = 12
  #   # @p_guess = p_guess
  #   # @word = word
  #   # @hint = hint
  #   # @game_running = true
  end
  
  def random_word
    @fname = 'google-10000-english-no-swears.txt'

    @randnum = rand(1..9893)

    File.open(@fname, 'r') do |file|
      file.readlines.each_with_index do |line, idx|
        @word = line if idx == @randnum
      end
    end
    puts @word
    @word
  end

  def correct_size_of_word

    until @word.length > 5 && @word.length < 12
      random_word()
      puts "#{@word}"
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
    puts 'Guess a letter'
    @p_guess = gets.chomp.downcase
    if @p_guess.length > 1 || @p_guess.empty?
      puts 'INVALID'
      @p_guess = gets.chomp
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

  def round()
    until @p_guess == @word || @guess.zero?
      player_guess()
      add_to_hint()
      check_win()

      if @word.include?(@p_guess)
        @guess += 1
        # puts "#NEW #{player.guess}"
      end
      guesses()

      @guess = 0 if @game_running == false
    end

    puts @word
  end


end 

game = Game.new
game.correct_size_of_word()
game.make_hint()
# game.player_guess()
# game.add_to_hint()
# game.check_win()
game.round()