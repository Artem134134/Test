# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'


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
@barmans  = params[:barmans]
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
  @message = "Дорогой клиент:  #{@username.capitalize},  ваш бармен:  #{@barmans}.  Мы будем ждать вас:  #{@datetime}, Цвет коктеля: #{@color};   " 

f = File.open './public/users.txt', 'a'
f.write "Ваш бармен: #{@barmans}, имя посетителя: #{@username.capitalize}, телефон: #{@phone}, дата и время: #{@datetime}, Цвет коктеля: #{@color};   "
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

