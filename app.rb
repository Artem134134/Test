# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
 require 'sqlite3'

def is_barmen_exists? db, name
	db.execute('select * from Barmens where name=?',[name]).size > 0
end

def seed_db db, barmens

	barmens.each do |barmen|
		if !is_barmen_exists? db, barmen
			db.execute 'insert into barmens (name) values (?)', [barmen]
		end
	end
end

def get_db
       	db = SQLite3::Database.new 'ShopBar.db'
 	 db.results_as_hash = true
  	return db
end

 configure do
 	db = get_db	
	db.execute 'CREATE TABLE IF NOT EXISTS
 "Users" 
 (
 	"id" INTEGER PRIMARY KEY AUTOINCREMENT,
 	"Name" TEXT,
 	"Phone" TEXT,
 	"DateTime" TEXT,
 	"Barmen" TEXT,
	"Color" TEXT
 )'

 	db.execute 'CREATE TABLE IF NOT EXISTS
 "Barmens" 
 (
 	"id" INTEGER PRIMARY KEY AUTOINCREMENT,
 	"name" TEXT
 )'
 
seed_db db, ['Walter White', 'Jessie Pinkman', 'Gus Fring', 'Mike Ehrmantraut']


end

  db = get_db
 db.execute 'insert into Users
 (	Name, Phone, DateTime, Barmen, Color)
 values (?, ?, ?, ?, ?)', [@Name, @Phone, @DateTime, @Barmen, @Color]

 # erb "OK, username is #{@Name}, #{@Phone}, #{@DateTime}, #{@Barmen}, #{@Color}"
 db.close

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

	erb :message
end


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

get '/showusers' do
	db = get_db

	@results = db.execute 'select * from Users order by id desc'
	
	erb :showusers
end

