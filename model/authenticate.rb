require 'sqlite3'
require 'faker'

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
rows = DB.execute <<-SQL

  create table users (
    id integer primary key,
    user_name varchar(30),
    password varchar(30),
    points integer
    );
SQL

adam = User.new('agodel', 'adam')
brendan = User.new('bscarano', 'brendan')
keaty = User.new('kgross', 'keaty')
ken = User.new('kuy', 'ken')
adam.add_user_to_database
brendan.add_user_to_database
keaty.add_user_to_database
ken.add_user_to_database
puts User.validate_user('agodel', 'adam')


