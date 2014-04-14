require_relative '../model/users.rb'
require_relative './prompt.rb'
require_relative '../controller/controller.rb'
require 'debugger'

DB = SQLite3::Database.open "../model/test.db"

CHARACTERS = {"1"=> "Mario", "2"=> "Luigi", "3"=> "Yoshi", "4"=> "Peach", "5"=> "Bowser", "6"=> "Wario", "7"=> "Donkey Kong", "8"=> "Toad"}

AWARDS = { 'red shell' => 200, 'green shell' => 180, 'banana' => 150, 'star' => 125,
  'mushroom' => 110  }

MESSAGES = {   introduction: ["\nWelcome to Mario Kart (DBC style)!", "Are you a new user?"],
               no_problem_first: ["Ok, no problem. What is your first name?"],
               no_problem_last: ["What is your last name?"],
               not_acceptable: ["That is not acceptable, please put a yes, or a no..."],
               bet_on: ["Who would you like to bet on?"],
               not_option: ["Not actually an option, bro. Try again"],
               username_req: ["\nPlease enter your user_name:"],
               password_req: ["\n...and password:"],
               selection:["\nSelection:\n"],
               how_much: ["How much would you like to bet?"],
               try_again: ["\nSorry that does not match our records. Try again.",
               "Please enter your user_name:"]
               }

class UserInterface
  extend BackendCommunication

  def self.run_game
    game_user = self.login_screen
    title = BackendCommunication.check_user_award_title(game_user.user_name).flatten.join(", ")
    puts "you have earned: #{title}"
    self.game_loop(game_user)
  end

  def self.game_loop(game_user)
    answer = ""
    first = true

    until answer == "no" || answer == "exit"
      answer = gets.chomp unless first

      if answer == "no" || answer == "exit"
        BackendCommunication.update_record(game_user.points, game_user.user_name)
        abort("goodbye")
      end

      players = self.ask_for_players
      game_size = players.length
      my_bet = Bet.new
      my_bet.choose_bet(players)
      race = MarioKart.new(players)
      winner = race.return_winner
      my_bet.update_points(winner, game_user, game_size)
      first = false
      puts "User Points: #{game_user.points}"
      puts "Would you like to play again? (please type yes or no)"
    end
  end

  def self.render_message(id)
    puts MESSAGES[id]
    gets.chomp
  end

  def self.login_screen
    answer = self.render_message(:introduction)
    until answer == "yes" or answer == "no"
      answer = self.render_message(:not_acceptable)
    end
    self.login_answer(answer)
  end

  def self.login_answer(answer)
    if answer == "yes"
      self.new_user
    else
      self.login_user
    end
  end

  def self.new_user
    first_name = self.render_message(:no_problem_first)
    last_name = self.render_message(:no_problem_last)
    user_name = first_name[0] + last_name
    password = rand(1000).to_s + rand(1000).to_s
    puts "Your username is #{user_name} and password is #{password}."
    user = User.new(user_name, password)
    BackendCommunication.add_user_to_database(user_name, password)
    return user
  end

  def self.login_user
    user_name = self.render_message(:username_req)
    password = self.render_message(:password_req)
    until BackendCommunication.validate_user(user_name, password)
      user_name = self.render_message(:try_again)
      password = self.render_message(:password_req)
    end
    points = BackendCommunication.collect_points(password)
    puts; puts "Welcome #{user_name}! You currently have #{points} to bet with."
    user = User.new(user_name, password, points)
    return user
  end

  def self.display_players
    puts; puts "Who would you like to see race (type the numbers of each player)?"
    CHARACTERS.each { |key, value| puts "#{key}.) #{value}"}
    puts "9.) finished"
  end

  def self.ask_for_players
    selected = []
    player_select = ""
    display_players

    until player_select == "9"
      player_select = self.render_message(:selection)
      until player_select =~ /\d/ && player_select.length == 1
        player_select = self.render_message(:not_option)
      end
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

  def initialize
    @bet_player = nil
    @bet_amount = nil
  end

  def render_message(id)
    puts MESSAGES[id]
    gets.chomp
  end

  def choose_bet(players)
    @bet_player = render_message(:bet_on).capitalize
    @bet_player = render_message(:not_option).capitalize until players.include?(@bet_player)
    @bet_amount = render_message(:how_much).to_i
  end

  def check_winner(winner)
    return true if winner.to_s == @bet_player
    return false
  end

  def update_points(winner, user, game_size)
    if check_winner(winner)
      user.points += @bet_amount.to_i*(game_size.to_i-1)
      give_award(user)
    else
      user.points -= @bet_amount.to_i
    end
    BackendCommunication.update_record(user.points, user.user_name)
  end

  def give_award(user)
    AWARDS.each do |key, value|
      if user.points >= value
        `say -v "Good News" congratulations you won a #{key}`
        puts "Congratulations! You won a #{key}"
        BackendCommunication.add_award_user_to_database(user.user_name, key)
        break
      end
    end
  end

end

UserInterface.run_game


