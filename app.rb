require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'active_record'

set :database, {adapter: "sqlite3", database: "barbershop.db"}

class Client < ActiveRecord::Base
end

configure do
  
end


get '/' do
  erb 'Hello'
end
