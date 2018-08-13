require 'rubygems'
require 'sinatra'
require 'sinatra/base'
#require File.expand_path '../app.rb', __FILE__
#require File.expand_path('app.rb', File.dirname(__FILE__))
set :environment, :development
#set :port, 80
require './app'
run Sinatra::Application
