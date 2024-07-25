require_relative 'player'
require_relative 'clear_screen'
require 'colorize'

class Board
  include ClearScreen

  WINNING_COMBOS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]].freeze

  def initialize
    @turns = 0
    @player_one = Player.new('X')
    @player_two = Player.new('O')
    @board_data = (1..9).to_a
  end

  def start_game
    loop do
      if @turns == -1
        puts 'Want to play again? Type N to decline'
        break if gets.chomp.downcase == 'n'

        # Reinitialize the board along players
        initialize
      end
      puts self
      play
    end
  end

  private

  def who_is_playing
    @turns.even? ? @player_one : @player_two
  end

  # Checks if a player won
  def check_win(player)
    WINNING_COMBOS.any? { |combo| combo.all? { |position| @board_data[position - 1] == player } }
  end

  def play
    # To make sure the player enters the correct board number AND the board number is not already played
    player = who_is_playing
    loop do
      if (player_choice = gets.chomp.to_i).between?(1, 9) && (@board_data[player_choice - 1]).is_a?(Numeric)
        @board_data[player_choice - 1] = player
        @turns += 1
        if @turns >= 5 && check_win(player)
          puts self
          puts "Player #{player} has won!".colorize(:green)
          @turns = -1
        elsif @turns >= 9
          puts "It's a draw".colorize(:yellow)
          @turns = -1
        end
        break
      else
        puts self
        puts 'Wrong player choice...'
      end
    end
  end

  # Prints the board
  def to_s
    clear_screen
    "Turn : #{who_is_playing} \n " \
    "___________\n" \
    "| #{@board_data[0]} | #{@board_data[1]} | #{@board_data[2]} |\n" \
    "|___|___|___|\n" \
    "| #{@board_data[3]} | #{@board_data[4]} | #{@board_data[5]} |\n" \
    "|___|___|___|\n" \
    "| #{@board_data[6]} | #{@board_data[7]} | #{@board_data[8]} |\n" \
    "|___|___|___|\n".colorize(who_is_playing == @player_one ? :blue : :red)
  end
end
