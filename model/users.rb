require 'sqlite3'
#require_relative './authenticate.rb'

#Only deals with the users
#===========================================
class User
  attr_reader :user_name, :password, :points, :bet_player
  attr_accessor :points
  def initialize(user_name, password, points = 100)
     @user_name = user_name
     @password = password
     @points = points
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

  def self.update_record(new_points, username)
    DB.execute("update users set points = '#{new_points}' where user_name = '#{username}'")
  end

  def self.collect_points(password)
   return DB.execute("select points from users where password = '#{password}'").flatten[0]
  end

  def self.add_award_to_database(title, required_points)
    DB.execute("INSERT INTO awards (title, required_points)
                VALUES (?,?)", [title, required_points])
  end

  def self.get_user_id(username)
    DB.execute("SELECT id FROM users WHERE user_name = '#{username}'")
  end

  def self.check_user_award_id(username)
    user_id = self.get_user_id(username).flatten[0]
    award_id = DB.execute("SELECT award_id FROM user_awards JOIN users ON user_id = users.id WHERE user_id = '#{user_id}'")
    award_id.flatten
  end

  def self.check_user_award_title(username)
    titles = []
    award_id = self.check_user_award_id(username)
    award_id.each { |award_id| titles << DB.execute("SELECT title FROM awards WHERE id = '#{award_id}'")}
    titles
  end

  def self.get_award_id(award_title)
    DB.execute("SELECT id FROM awards WHERE title = '#{award_title}'")
  end

  def self.add_award_user_to_database(username, award)
    user_id = self.get_user_id(username)
    award_id = self.get_award_id(award)
    DB.execute("INSERT INTO user_awards (user_id, award_id)
                VALUES (?,?)", [user_id, award_id])
  end
end

