require "sinatra"
require "sinatra/reloader"

get "/" do
  @entries = Dir.glob("public/*").shuffle
  @entries.map! { |file| File.basename(file, ".txt") }
  erb :home
end

get "/ascending" do
  @entries = Dir.glob("public/*")
  @entries.map! { |file| File.basename(file, ".txt") }
  erb :ascending
end

get "/descending" do
  @entries = Dir.glob("public/*").reverse
  @entries.map! { |file| File.basename(file, ".txt") }
  erb :descending
end