require_relative 'utils'

class Game
  attr_accessor :player_hash
  attr_reader :game_die

  def initialize(*players)
    @length = 30 # or whatever
    @players = players
    prepare_players(players)
    run!
  end

  def advance_player!(player, position)
    @player_hash[player] = position + [*1..6].sample
    @player_hash[player] = 30 if @player_hash[player] >= 30

    puts @player_hash
  end

  def print_board
    @player_hash.each_pair do |player, position|
      (position).times { print ".".ljust(4) }
      print player[0].ljust(4)
      (@length - position).times { print ".".ljust(4) }
      puts
      puts
    end
  end

  def finished?
    @player_hash.each_value do |value|
      return true if value >= @length
    end
    return false
  end

  def prepare_players(players)
    @player_hash = {}
    players.each do |player|
      @player_hash[player] = 0
    end
  end

  def winner(players)
    if @player_hash[players[0]] > @player_hash[players[1]]
      return "#{players[0]} wins!"
    elsif @player_hash[players[0]] < @player_hash[players[1]]
      return "#{players[1]} wins!"
    else
      puts "Game is a tie!"
    end
  end

  def run!
    clear_screen!
    until self.finished?
      @player_hash.each_pair do |player, position|
        move_to_home!
        self.advance_player!(player, position)
        self.print_board
        sleep(0.2)
      end
    end
    puts winner(@players)
  end
end

# class Player
#   def initialize(name)
#     @name = name
#   end
# end


Game.new("Bowser", "Yoshi")




# The game is over, so we need to print the "winning" board
# game.print_board()

# puts "Player '#{game.winner}' has won!"
