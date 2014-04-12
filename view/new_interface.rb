require_relative '../model/users.rb'
require_relative './prompt.rb'
require_relative '../controller/controller.rb'
require 'debugger'
DB = SQLite3::Database.open "../model/test.db"

class UserInterface
extend BackendCommunication
  MESSAGES = {introduction: ["\nWelcome to Mario Kart (DBC style)!",
                         "Are you a new user?"],
               no_problem_first: ["Ok, no problem. What is your first name?"],
               no_problem_last: ["What is your last name?"],
               }


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
    self.render_message(:introduction)

    answer = PromptManager.validated_prompt(/[yes|no]/) do
      puts "That is not acceptable, please put a yes, or a no..."
    end

    unless answer.downcase.to_s == "yes" || answer.downcase.to_s == "no"
      puts "That is not acceptable, please put a yes, or a no..."
      answer = gets.chomp!
    end
      if answer == "yes"
        self.new_user
      else
        self.login_user
      end
  end

  def self.new_user
    self.render_message(:no_problem_first)
    first_name = gets.chomp!

    self.render_message(:no_problem_last)
    last_name = gets.chomp!

    user_name = first_name[0] + last_name
    password = rand(1000).to_s + rand(1000).to_s
    puts "Your username is #{user_name} and password is #{password}."

    user = User.new(user_name, password)
    BackendCommunication.add_user_to_database(user_name, password)
  end

  def self.login_user
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
sleep(1.0)
puts game_user.points
puts game_user.bet_player
sleep(1.0)
#UserInterface.login_user()
#debugger
game_user.choose_racers('bowser', 'yoshi')
game_user.place_bet(10, 'yoshi')
sleep(1.0)
puts game_user.bet_player
#user.update_points(110)
race = MarioKart.new('bowser', 'yoshi')
winner = race.return_winner
#play_a_game('bowser', 'yoshi')
sleep(1.0)
game_user.update_points(winner)
sleep(1.0)
puts game_user.points
puts game_user.bet_player
sleep(1.0)

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
