require "sinatra"
require 'net/http'
#require 'sinatra/cookies'

enable :sessions

# # To be continue
before '/:relativepath' do
  relativepath = params[:relativepath]
  session[:displayname] ||= ""
  if session[:displayname] == ""
    puts "session is empty"
    if relativepath != "login" && relativepath != "register"
      puts "not login: "
      redirect "/login"
    else
      puts "is login"
    end
  else
    puts "session is not empty"
  end
  #redirect "/:relativepath"
end

# before '/*' do
#   unless params[:splat] == 'login' || params[:splat] == 'beta'
#     redirect '/beta'
#   end
# end


# get "/test/:idea" do
#   puts "the idea is: "
#   puts :idea
#   puts params[:idea]
#   "hi"
# end

# get "/:relativepath" do
#   if :relativepath != "bbb"
#     puts "not login: "
#     if :relativepath.to_s == "bbb"
#       puts "string to login"
#     else
#       puts "string to not login"
#       puts :relativepath.to_s
#       a = :relativepath.to_s
#       puts "now the converted: "
#       puts a
#     end
#     # puts :relativepath
#     # :relativepath
#     #redirect "/login"
#   else
#     puts ":relative path is login"
#   end
# end


def valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
end


get "/login" do
  puts "I am in login"
  erb :login
end

post "/login" do
  puts "I am in login action"
  uri = URI('http://127.0.0.1:8001/login')
  res = Net::HTTP.post_form(uri, 'username' => params[:email], 'password' => params[:password])
  puts res.body
  puts res.code
  if res.code === "200"
    session[:displayname] = params[:email]
    return erb :msg, :locals => {:msg => "User loggedin successfully"}
  else
      if valid_json?(res.body)
        j = JSON.parse(res.body)
        return erb :msg, :locals => {:msg => j["error"]}
      else
        return erb :msg, :locals => {:msg => "Internal Error"}
      end
  end
end

get "/register" do
    puts "I am in register"
    erb :register
end


post "/register" do
  uri = URI('http://127.0.0.1:8001/register')
  res = Net::HTTP.post_form(uri, 'username' => params[:email], 'password' => params[:password])
  puts res.body
  puts res.code
  if res.code === "201"
    return erb :msg, :locals => {:msg => "User is created successfully"}
  else
      if valid_json?(res.body)
        j = JSON.parse(res.body)
        return erb :msg, :locals => {:msg => j["error"]}
      else
        return erb :msg, :locals => {:msg => "Internal Error"}
      end
  end
end

get "/home" do
  @displayname = session[:displayname]
  erb :home
end

get "/" do
    redirect "/home"
end
