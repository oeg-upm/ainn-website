require "sinatra"
require 'net/http'


def valid_json(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
end


get "/register" do
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
      if valid_json(res.body)
        j = JSON.parse(res.body)
        return erb :msg, :locals => {:msg => j["error"]}
      else
        return erb :msg, :locals => {:msg => "Internal Error"}
      end
  end
end


get "/" do
    erb :home
end
