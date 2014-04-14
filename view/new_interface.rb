require_relative '../model/users.rb'
require_relative './prompt.rb'
require_relative '../controller/controller.rb'
require 'debugger'
DB = SQLite3::Database.open "../model/test.db"

CHARACTERS = {"1"=> "Mario", "2"=> "Luigi", "3"=> "Yoshi", "4"=> "Peach", "5"=> "Bowser", "6"=> "Wario", "7"=> "Donkey Kong", "8"=> "Toad"}

class UserInterface
  extend BackendCommunication

  MESSAGES = {introduction: ["\nWelcome to Mario Kart (DBC style)!",
                         "Are you a new user?"],
               no_problem_first: ["Ok, no problem. What is your first name?"],
               no_problem_last: ["What is your last name?"],
               }

  def self.run_game
    game_user = self.login_screen
    players = self.ask_for_players
    game_user.choose_racers(players)
    #game_user.place_bet(10, 'mario')
    self.choose_bet(game_user)
    race = MarioKart.new(players) #controller.rb
    winner = race.return_winner
    game_user.update_points(winner) #users.rb
    # puts game_user.points #users.rb
    # puts game_user.bet_player
  end

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

  def self.login_screen
    self.render_message(:introduction)

    answer = PromptManager.validated_prompt(/[yes|no]/) do
      puts "That is not acceptable, please put a yes, or a no..."
    end

    unless answer.downcase.to_s == "yes" || answer.downcase.to_s == "no"
      puts "That is not acceptable, please put a yes, or a no..."
      answer = gets.chomp
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
    return user
  end

  def self.login_user
    puts "\nPlease enter your user_name:"
    user_name = gets.chomp!
    puts "\n...and password:"
    password = gets.chomp!

    until BackendCommunication.validate_user(user_name, password)
      puts "\nSorry that does not match our records. Try again."
      puts "\nPlease enter your user_name:"
      user_name = gets.chomp!
      puts "\n...and password:"
      password = gets.chomp!
    end
    points = BackendCommunication.collect_points(password)
    puts "\nWelcome #{user_name}! You currently have #{points} to bet with."
    user = User.new(user_name, password, points)
    # else
    #   puts "\nSorry that does not match our records."
    # end
    return user
  end

  def self.display_players
    puts "Who would you like to see race (type the numbers of each player)?"
    CHARACTERS.each { |key, value| puts "#{key}.) #{value}"}
    puts "9) finished"
  end

  def self.ask_for_players
    selected = []
    display_players
    player_select = ""

    until player_select == "9"
      puts "Selection: \n"
      player_select = gets.chomp
      unless player_select == "9"
        selected << player_select
      end
    end
    players = []
    selected.uniq.each { |number|  players << CHARACTERS[number] }
    return players
  end

  def self.choose_bet(user)
    puts "who would you like to bet on?"
    player = gets.chomp
    #user.bet_player = player
    puts "how much would you like to bet?"
    amount = gets.chomp.to_i
    #user.bet_amount = amount.to_i
    puts amount.class
    puts amount.to_i
    user.place_bet(amount.to_i, player)
  end

end



UserInterface.run_game


