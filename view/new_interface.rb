require_relative '../model/users.rb'
require_relative './prompt.rb'
DB = SQLite3::Database.open "../model/test.db"

class UserInterface
extend BackendCommunication
  MESSAGES = {preamble: ["\nWelcome to Mario Kart (DBC style)!",
                         "Are you a new user?"]}


  def self.render(content)
    if content.is_a? Array
      content.each {|msg| puts msg}
    else
      puts content
    end
  end

  def self.render_message(id)
    self.render(MESSAGES[id])
  end

  def self.welcome_screen
    self.render_message(:preamble)

    answer = PromptManager.validated_prompt(/[yes|no]/) do
      puts "That is not acceptable, please put a yes, or a no..."
    end

    unless answer.downcase.to_s == "yes" || answer.downcase.to_s == "no"
      puts "That is not acceptable, please put a yes, or a no..."
      answer = gets.chomp!
    end


    if answer == 'yes'
      puts "Ok, no problem. What is your first name?"
      first_name = gets.chomp!
      puts "What is your last name?"
      last_name = gets.chomp!
      user_name = first_name[0] + last_name
      password = rand(1000).to_s + rand(1000).to_s
      puts "Your username is #{user_name} and password is #{password}."
      user = User.new(user_name, password)
      user.add_user_to_database

    else
      puts "\nPlease enter your user_name:"
      user_name = gets.chomp!
      puts "\n...and password:"
      password = gets.chomp!
      if BackendCommunication.validate_user(user_name, password)

      points = BackendCommunication.collect_points(password)
      puts "\nWelcome #{user_name}! You currently have #{points} to bet with."
      user = User.new(user_name, password, points)
      else
        puts "\nSorry that does not match our records."
      end
      return user
    end
  end

  def self.run_game
    # initialize a new game with the players and the bet placed
    # it will return a boolean of true or false based on if they won
  end

  def self.pick_players(*players)
    return *players
  end

  def self.place_bet(player)
    return "you bet on #{player}"
  end

end



fake_game = "this is the game playing"
game_user = UserInterface.welcome_screen

user.pick_players('bowser', 'yoshi')
user.place_bet('yoshi')
#user.update_points(110)
puts fake_game
user.check_winner('winner of game')


#p user


  # welcome screen
  # we need to figure out if it is an existsing user
  # or not
  # if it is a new user, we need to ask for information
  # and add them to the database
  # if not


      #Users would pick their players
      #Place your bets
      #Game would run
      #Winners/Losers would be determined
      #Points updated accordingly

# get the players they want to race
# get who they want to bet on
# amount they will bet
# initialize game with those two players and who they expect to win

#run, return who won
# if that was who they bet on, add points
# if not subtract points
