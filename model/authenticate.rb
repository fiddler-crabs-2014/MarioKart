require 'sqlite3'
require 'faker'
require_relative './users.rb'

#puts Faker::Date.between("01/01/1950", "01/01/2014")

#open database
`rm test.db`

DB = SQLite3::Database.new "test.db"
DB.execute("PRAGMA foreign_keys = ON;")
#Time.now
#creating database
#DROP TABLE IF EXISTS authors;
    # created_at timestamp,
    # updated_at timestamp
DB.execute <<-SQL

  create table users (
    id integer primary key,
    user_name varchar(30),
    password varchar(30),
    points integer
    );
SQL

DB.execute <<-SQL
  create table awards (
    id integer primary key,
    title varchar(30),
    required_points integer
    );
SQL

DB.execute <<-SQL
  create table user_awards (
    id integer primary key,
    user_id integer,
    award_id integer,
    foreign key(user_id) references users(id),
    foreign key(award_id) references awards(id)
    );
SQL


BackendCommunication.add_user_to_database('agodel', 'adam')
BackendCommunication.add_user_to_database('bscarano', 'brendan')
BackendCommunication.add_user_to_database('keaty', 'keaty')
BackendCommunication.add_user_to_database('kuy', 'ken')
BackendCommunication.add_award_to_database('mushroom', 110)
BackendCommunication.add_award_to_database('star', 125)
BackendCommunication.add_award_to_database('banana', 150)
BackendCommunication.add_award_to_database('green shell', 180)
BackendCommunication.add_award_to_database('red shell', 200)

BackendCommunication.update_record(110, 'kuy')
BackendCommunication.add_award_user_to_database('kuy', 'mushroom')
