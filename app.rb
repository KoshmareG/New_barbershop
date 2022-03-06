require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "barbershop.db"}

class Client < ActiveRecord::Base
  validates :name, presence: true
  validates :phone, presence: true
  validates :datestamp, presence: true
  validates :barber, presence: true
end

class Barber < ActiveRecord::Base
end

class Contact < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true
  validates :message, presence: true
end

configure do  
end

def form_validation hash
  error = hash.select {|key, value| params[key].empty?}.values.join("; ")
end

def barbers_table
  @barbers = Barber.all
end

get '/' do
  barbers_table
  @contacts = Contact.all
  erb :index
end

get '/visit' do
  @c = Client.new
  @barbers = Barber.all
  erb :visit
end

get '/contacts' do
  @contact = Contact.new
  erb :contacts
end

post '/visit' do
  
  @barbers = Barber.all
  @c = Client.new params[:client]

  if @c.save
    erb "Спасибо, Вы записались"
  else
    @error = @c.errors.full_messages.first
    erb :visit
  end
end

post '/contacts' do

  @contact = Contact.new params[:contact]

  if @contact.save
    erb "Ваше сообщение отправлено"
  else
    @error = @contact.errors.full_messages.first
    erb :contacts
  end
end

get '/barber/:id' do
  @barber = Barber.find params[:id]
  erb :barber
end

get '/bookings' do
  @clients = Client.order('created_at desc')
  erb :bookings
end

get '/client/:id' do
  @client = Client.find params[:id]
  erb :client
end
