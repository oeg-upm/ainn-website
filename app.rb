require "sinatra"
require 'net/http'
require "fileutils"
include FileUtils::Verbose

# so sinatra will reload whenever a new changes happen

require "sinatra/reloader"
# require "sinatra/config_file"
# config_file 'config.yml'
#set :environment, :development

# enable :reloader
# configure :staging do
#   enable :reloader
# end
after_reload do
  puts 'sinatra reloaded '
end





enable :sessions

# # To be continue
before '/:relativepath' do
  relativepath = params[:relativepath]
  session[:displayname] ||= ""
  if session[:displayname] == ""
    puts "session is empty"
    if relativepath != "login" && relativepath != "register" && relativepath != "about" && relativepath != "upload"
      puts "not login: "
      redirect "/login"
    else

      puts "is login"
    end
  else
    puts "session is not emptyy"
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

def call_tada(name, csv_url)
    # tada is being used by the experiment, we will enable it later on
    # To enable it, just comment the below return
  return ""
  uri = URI('http://tadaa.linkeddata.es/api/type_entity_col')
  res = Net::HTTP.post_form(uri, 'csv_url' => csv_url, 'name' => name)
  puts res.body
  puts res.code
  if res.code === "200"
    return ""
  else
    if valid_json?(res.body)
      j = JSON.parse(res.body)
      return j["error"]
    else
      return "Server error"
    end
  end
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

MPE_DATASET_ADD = 'http://localhost:8092/datasets/'
post "/dataset" do
  organization_id = params[:organization_id]
  distribution_download_url = params[:distribution_download_url]
  uri = URI(MPE_DATASET_ADD + "/" + organization_id)
  res = Net::HTTP.post_form(uri, 'distribution_download_url' => distribution_download_url)
  puts res.body
  puts res.code
  if res.code === "200"
    if valid_json?(res.body)
      j = JSON.parse(res.body)
      dataset_id = j["dataset_id"]
      tada_err_msg = call_tada("marketplace_"+dataset_id, distribution_download_url)
      return erb :msg, :locals => {:msg => "Dataset " + dataset_id + " is created successfully, "+tada_err_msg, :organization_id => organization_id}
    else
      return erb :msg, :locals => {:msg => "Internal Error"}
    end

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

CKAN_ORGANIZATION_LIST = 'http://83.212.100.226/ckan/api/action/organization_list?all_fields=true'
MPE_DATASET_LIST = 'http://localhost:8092/datasets'

get "/mydatahub" do
  puts "I am in mydatahub"

  uri = URI(CKAN_ORGANIZATION_LIST)
  res = Net::HTTP.get_response(uri)
  organization_list = Array.new
  if res.code === "200"
    if valid_json?(res.body)
      j = JSON.parse(res.body)
      organization_list = j["result"]
      #return erb :mydatahub, :locals => {:organization_list => organization_list}
    else
      #return erb :msg, :locals => {:msg => "Internal Error"}
    end
  else
    if valid_json?(res.body)
      j = JSON.parse(res.body)
      #return erb :msg, :locals => {:msg => j["error"]}
    else
      #return erb :msg, :locals => {:msg => "Internal Error"}
    end
  end

  uri = URI(MPE_DATASET_LIST)
  res = Net::HTTP.get_response(uri)
  dataset_list = Array.new
  if res.code === "200"
    if valid_json?(res.body)
      j = JSON.parse(res.body)
      dataset_list = j["results"]
      #return erb :mydatahub, :locals => {:organization_list => organization_list}
    else
      #return erb :msg, :locals => {:msg => "Internal Error"}
    end
  else
    if valid_json?(res.body)
      j = JSON.parse(res.body)
      #return erb :msg, :locals => {:msg => j["error"]}
    else
      #return erb :msg, :locals => {:msg => "Internal Error"}
    end
  end

  return erb :mydatahub, :locals => {:organization_list => organization_list, :dataset_list => dataset_list}


end

get "/" do
  redirect "/home"
end

get "/about" do
  erb :about
end

get "/annotations" do
  datasetid = params[:datasetid]
  requestid = params[:requestid]

  return erb :annotations, :locals => {:datasetid => datasetid, :requestid => requestid}
end

get "/requests" do
  datasetid = params[:datasetid]
  puts "datasetid in request "
  puts datasetid

  query = '{
  request{
    edges{
      node{
        id
        description
        requestedOn
        datasetId
      }
    }
  }
  }'
  uri = URI('http://127.0.0.1:5000/graphql?query='+query)
  res = Net::HTTP.get_response(uri)
  puts res.body
  puts res.code

  if res.code === "200"
    puts 'will check the results'
    if valid_json?(res.body)
      j = JSON.parse(res.body)
      return erb :requests, :locals => {:requests => j["data"]["request"]["edges"], :datasetid => datasetid}
    else
      return erb :msg, :locals => {:msg => "Internal Error"}
    end
  else
    if valid_json?(res.body)
      j = JSON.parse(res.body)
      return erb :msg, :locals => {:msg => j["error"]}
    else
      return erb :msg, :locals => {:msg => "Internal Error"}
    end
  end
  erb :requests
end

post "/request" do
  displayname=session[:displayname]
  datasetid=params[:datasetid]
  description=params[:description]
  puts displayname
  puts datasetid
  puts description
  query = "mutation{
  createRequest(requesterId:\"#{displayname}\", datasetId:\"#{datasetid}\", description:\"#{description}\"){
    request{
      id
    }
  }
  }"
  puts "the query is: "
  puts query
  uri = URI('http://127.0.0.1:5000/graphql?query='+query)
  puts "the params: "
  puts params
  res = Net::HTTP.post_form(uri, params)
  puts res.body
  puts res.code
  if res.code === "200"
    puts '200 and redirect to requestsss'
    redirect '/requests'
  else
    if valid_json?(res.body)
      j = JSON.parse(res.body)
      return erb :msg, :locals => {:msg => j["error"]}
    else
      return erb :msg, :locals => {:msg => "Internal Error"}
    end
  end
end

post "/upload" do
    tempfile = params[:file][:tempfile]
    filename = params[:file][:filename]
    mapping_id = params[:mapping_id]
    puts "mapping id: "
    puts mapping_id
    cp(tempfile.path, "uploads/#{filename}")
    return erb :msg, :locals => {:msg => "Done"}
end









