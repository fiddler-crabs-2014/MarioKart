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
  #Controls the entire game flow
  #========================================
  def self.run_game
    game_user = self.login_screen
    puts "game user class: #{game_user.class}"
    puts game_user.points
    players = self.ask_for_players
    game_user.choose_racers(players) #users.rb
    my_bet = Bet.new
    my_bet.choose_bet
    race = MarioKart.new(players) #controller.rb
    winner = race.return_winner #controller.rb
    p my_bet
    my_bet.update_points(winner, game_user)
    p my_bet
    p game_user
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

  #Logs in user/ signs up new user
  #========================================
  def self.login_screen
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
    return user
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

  #Sees what players you would like to have race
  #========================================
  def self.display_players
    puts "\nWho would you like to see race (type the numbers of each player)?"
    CHARACTERS.each { |key, value| puts "#{key}.) #{value}"}
    puts "9) finished"
  end

  def self.ask_for_players
    selected = []
    display_players
    player_select = ""

    until player_select == "9"
      puts "\nSelection: \n"
      player_select = gets.chomp
      unless player_select == "9"
        selected << player_select
      end
    end

    players = []
    selected.uniq.each { |number|  players << CHARACTERS[number] }
    return players
  end

end

class Bet
  attr_reader :bet_amount, :bet_player

    #Chooses the bet amount
  #========================================
  def initialize
    @bet_player = nil
    @bet_amount = nil
  end
  def choose_bet
    puts "Who would you like to bet on?"
    @bet_player = gets.chomp

    puts "How much would you like to bet?"
    @bet_amount = gets.chomp
  end

  def check_winner(winner)
    return true if winner.to_s == @bet_player
    return false
  end

  def update_points(winner, user)
    if check_winner(winner)
      user.points += @bet_amount*(@racers.length-1)
    else
      user.points -= @bet_amount.to_i
    end
  end

end

UserInterface.run_game


