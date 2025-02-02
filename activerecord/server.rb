require "sinatra/activerecord"
require "sinatra"

#establishes connection to the database so SQLite can access it in the first place
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database:"./database.sqlite3")
#set :database, {adapter: "sqlite3", database: "./database.sqlite3"}
enable :sessions #enables cookies

#User inherits ActiveRecord to allow the user to access the information that they made
class User < ActiveRecord::Base
end

get "/" do
  puts "Running"
  erb :home
end

get "/signup" do
  @user = User.new #Useless (aka MUDA MUDA MUDA)
  erb :'users/signup'
end

post '/signup' do
  @user = User.new(params) #allows user to create a User object with the parameters saved in the "create_users.rb" in the migrate folder
  if @user.save #Able to save because user is able to inherit the Active record
    p "#{@user.first_name} was saved to the database"
  end
  erb :'users/thanks'
end

get '/thanks' do
  erb :'users/thanks'
end

get '/login' do
  if session[:user_id] #aka cookies. NOTE: Look up cookies and sessions
    redirect '/'
  else
    erb :'users/login'
  end
end
#Lines 35 to 41: If the user is logged in or signed up, it redirects to the home page with their content
#IF not, it redirects them to login page

post '/login' do
  given_password = params[:password]
  user = User.find_by(email:params[:email])
  if user
    if user.password == given_password
      p "user authenticated successfully"
      session[:user_id] = user.id # setting the session id to the user id
    else
      p "invalid password"
    end
  end
end

# Delete request
post '/logout' do
  session.clear #Look up sinatra active records methods for clear
  p 'user logged out successfully'
  redirect '/'
end
# MVC
