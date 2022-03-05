require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "barbershop.db"}

class Client < ActiveRecord::Base
  validates :name, presence: true
  validates :phone, presence: true
  validates :datestamp, presence: true
end

class Barber < ActiveRecord::Base
end

class Contact < ActiveRecord::Base
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
  erb :visit
end

get '/contacts' do
  erb :contacts
end

post '/visit' do
  
  @c = Client.new params[:client]
  if @c.save
    erb "Спасибо, Вы записались"
  else
    @error = @c.errors.full_messages.first
    erb :visit
  end

end

post '/contacts' do
  @name = params[:name]
  @user_email = params[:user_email]
  @user_message = params[:user_message]

  warning_hash = {  :name => 'Введите имя', 
                    :user_email => 'Введите E-Mail', 
                    :user_message => 'Введите сообщение'
                  }
  
  @error = form_validation warning_hash

  if @error.size > 0
    return erb :contacts
  else
    contact = Contact.new :name => "#{@name}", :email => "#{@user_email}", :message => "#{@user_message}"
    contact.save
    erb "Ваше сообщение отправлено"
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
