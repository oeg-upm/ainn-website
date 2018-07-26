require "sinatra"

get "/register" do
    erb :register
end

post "/register" do
    "Registered"
    erb :msg, :locals => {:msg => "Registered"}
end

get "/" do
    erb :home
end
