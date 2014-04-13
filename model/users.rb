require 'sqlite3'


#Only deals with the users
#===========================================
class User
  attr_reader :user_name, :password, :points, :bet_player
  attr_accessor :points
  def initialize(user_name, password, points = 100)
     @user_name = user_name
     @password = password
     @points = points
     @bet_amount = 0
     @bet_player = nil
     @racers = []
  end

  def choose_racers(*racers)
    @racers = *racers
  end

  def check_winner(winner)
    return true if winner.to_s == @bet_player
    return false
  end

  def place_bet(value, player)
    @bet_amount = value
    @bet_player = player
  end

  def update_points(winner)
    if check_winner(winner)
      @points += @bet_amount*(players.length-1)
    else
      @points = @points - @bet_amount.to_i
    end
  end

end


module BackendCommunication
  DB = SQLite3::Database.open "../model/test.db"

  def self.add_user_to_database(user_name, password)
    DB.execute("INSERT INTO users (user_name, password, points)
                VALUES (?, ?, ?)", [user_name, password, 100])
  end

  def self.validate_user(user, pw)
    username = DB.execute("select user_name from users where password = '#{pw}'")
    return username.flatten[0] == user.to_s
  end

  def self.update_points(new_points)
    DB.execute("update users set points = '#{new_points}' where user_name = '#{@user_name}'")
  end

  def self.collect_points(password)
   return DB.execute("select points from users where password = '#{password}'").flatten[0]
  end
end

# ----
## Non-executable driver code

module GameLogic
  def find_winners_and_update_points(winners, users)
    winners.each do |winner|
      if user.bet_player == winner
        user.update_points
      end
    end
  end
end
