require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "barbershop.db"}

class Client < ActiveRecord::Base
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
  @barbers = Barber.order "created_at desc"
end

get '/' do
  @contacts = Contact.all
  erb :index
end

get '/visit' do
  barbers_table
  erb :visit
end

get '/contacts' do
  erb :contacts
end

post '/visit' do
  @user_name = params[:user_name]
  @phone_number = params[:phone_number]
  @date_time = params[:date_time]
  @master = params[:master]

  warning_hash = {  :user_name => 'Введите имя', 
                    :phone_number => 'Введите номер телефона', 
                    :date_time => 'Введите время и дату посещения', 
                    :master => 'Выберите мастера'
                  }
  
  @error = form_validation warning_hash

  if @error.size > 0
    barbers_table
    return erb :visit 
  else
    client = Client.new :name => "#{@user_name}", :phone => "#{@phone_number}", :datestamp => "#{@date_time}", :barber => "#{@master}"
    client.save
    erb "#{@user_name}, Вы записаны на посещение #{@date_time} #{@master} будет ждать Вас в указанное время!"
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
