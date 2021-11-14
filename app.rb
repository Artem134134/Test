# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
 require 'sqlite3'

 configure do
 	db = get_db	
	db.execute 'CREATE TABLE IF NOT EXISTS
 "Users" 
 (
 	"id" INTEGER PRIMARY KEY AUTOINCREMENT,
 	"username" TEXT,
 	"phone" TEXT,
 	"datetime" TEXT,
 	"barmen" TEXT,
	"color" TEXT
 )'

 end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do 
	
	erb :about 
end

get '/visit' do
	erb :visit
end

post '/visit' do 

@username = params[:username]
@phone    =  params[:phone]
@datetime = params[:datetime]
@barmen  = params[:barmen]
@color    = params[:color]

# хеш
hh =  { :username => 'Введите имя', 
		:phone => 'Введите ваш телефон',
 		:datetime => 'Введите дату и время'}

@error = hh.select {|key,_| params[key] == ""}.values.join(", ")
if @error != ''
			return erb :visit
		
end	

  @title = "Спасибо что выбрали нас!"
  @message = "Дорогой клиент:  #{@username.capitalize},  ваш бармен:  #{@barmen}.  Мы будем ждать вас:  #{@datetime}, Цвет коктеля: #{@color};   " 

f = File.open './public/users.txt', 'a'
f.write "Ваш бармен: #{@barmen}, имя посетителя: #{@username.capitalize}, телефон: #{@phone}, дата и время: #{@datetime}, Цвет коктеля: #{@color};   "
f.close

 db = get_db
 db.execute 'insert into Users
 (	username, phone, datetime, barmen, color)
 values (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barmen, @color]

 erb "OK, username is #{@username}, #{phone}, #{datetime}, #{barmen}, #{color}"
 end

 def get_db
	 return SQLite3::Database.new 'ShopeBar.db'
	 db.results_as_hash = true
	 return db
 end


	erb :message
 

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	@name   =  params[:name]
	@email  =  params[:email]
	@body  =   params[:body]

	# хеш
	hh = {:name => 'Введите имя' ,
	 :email => 'E-mail' ,
	  :body => 'Введите текст '}


@error = hh.select {|key,_| params[key] == ""}.values.join(", ")
if @error != ''
			return erb :contacts
		
end	

 @title1 = "Сообщение отправил: #{@name.capitalize}, эл.почта: #{@email}, текст: #{@body}! "


f = File.open './public/contacts.txt', 'a'
f.write "Имя: #{@name}, E-mail клиента: #{@email}, Сообщение клиента: #{@body};   "
f.close

erb :message

end

