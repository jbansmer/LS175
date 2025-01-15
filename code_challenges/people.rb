require "sinatra"
require "sinatra/reloader"
require "yaml"

before do
  @user_data = YAML.load_file("users.yaml")
end

helpers do
  def users
    @user_data.keys
  end

  def email
    @user_data[@user.to_sym][:email]
  end

  def interests
    @user_data[@user.to_sym][:interests]
  end

  def other_users
    users.reject { |user| user.to_s == @user }
  end

  def count_interests
    interest_count = 0
    
    users.each do |user|
      @user = user
      interest_count += interests.size
    end

    interest_count
  end
end

get "/" do
  redirect "/users"
end

get "/users" do
  @user = "All Users"
  @users = users

  erb :users
end

get "/:name" do
  @user = params[:name]
  @email = email
  @interests = interests

  erb :name
end
