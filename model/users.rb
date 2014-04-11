require 'sqlite3'


#Only deals with the users
#===========================================
class User
  attr_reader :user_name, :password, :points
  def initialize(user_name, password, points = 100)
     @user_name = user_name
     @password = password
     @points = points
     @bet_amount = 0
     @bet_player
  end

  def place_bet(value)

  end

  def check_winner
    # get the winner from the game, compare it to @bet_player
    # update points accordingly
  end

end



module BackendCommunication
  DB = SQLite3::Database.open "../model/test.db"

  def add_user_to_database
    DB.execute("INSERT INTO users (user_name, password, points)
                VALUES (?, ?, ?)", [@user_name, @password, @points])
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
