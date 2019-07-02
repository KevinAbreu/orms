require "sinatra/activerecord"

set :database, {adapter: "sqlite3", database: "./database.sqlite3"}
