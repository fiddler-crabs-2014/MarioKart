require_relative 'utils'

class MarioKart

  def initialize(players)
    @length = 20
    @players = players
    @winner = nil
    prepare_players(players)
    #return @winner
  end

  def prepare_players(players)
    @player_hash = {}
    players.each { |player| @player_hash[player] = 0 }
    run!
  end

  def advance_player!(player, position)
    @player_hash[player] = position + [*1..6].sample
  end

  def print_board
    @player_hash.each_pair do |player, position|
      position = @length if position >= @length
      (position).times { print ".".ljust(4) }
      print player[0].ljust(4)
      (@length - position).times { print ".".ljust(4) }
      puts; puts
    end
    puts; print @player_hash.flatten
  end

  def finished?
    @player_hash.each_value { |value| return true if value >= @length }
    return false
  end

  def winner(players)
    winner_arr = @player_hash.sort_by { |k,v| v }.last
    @winner = winner_arr[0]
    puts "#{@winner} wins!"
  end

  def run!
    clear_screen!
    until self.finished?
      @player_hash.each_pair do |player, position|
        move_to_home!
        self.advance_player!(player, position)
        self.print_board
        sleep(0.3)
      end
    end
    puts; puts
    puts winner(@players)
  end
  def return_winner
    return @winner
  end
end

