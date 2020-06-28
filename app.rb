#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Users" 
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"username" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"barber" TEXT,
			"color" TEXT
		);'
	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Barbers" 
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"barber" TEXT
		);'
	db.execute 'Insert into Barbers (barber) values ("Виктор В."),("Сергей Ц."),("Ульяна К.")'
				#where not exists
				#(select * from Barbers where barber = '1');'
	#where not exists(select * from Barbers where barber="Виктор В."'
	

end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School!!</a>"			
end

get '/about' do
  erb :about
end

get '/visit' do
  erb :visit
end

get '/contacts' do
  erb :contacts
end

get '/showusers' do
	@rows = []
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	db.execute 'select*from Users order by id desc --' do |row|
			@rows << "#{row['username']}, контактный телефон: #{row['phone']} записался на #{row['datestamp']} к #{row['barber']} на цвет #{row['color']}<br>"
	end
	erb :showusers
end

post '/visit' do
	@user_name = params[:user_name]
	@user_phone = params[:user_phone]
	@user_date_visit = params[:user_date_visit]
	@master = params[:selected_master]
	@color = params[:color]

	hh = {  :user_name => "Введите имя",
			:user_phone => "Введите телефон",
			:user_date_visit => "Введите дату и время"	}

	@error = hh.select {|key,_| params[key] == ''}.values.join(", ")

	if @error != ''
	  return erb :visit
	end

	db = get_db
	db.execute 'insert into 
		Users 
		(
			username,
			phone,
			datestamp,
			barber,
			color
		)
		values (?,?,?,?,?)' , [@user_name, @user_phone, @user_date_visit, @master,@color]

	#File.open('./public/visit.txt', 'a'){|f| f.write("#{@user_name},#{@user_phone},#{@user_date_visit},#{@master}, #{@color}\n")}
	erb :visit
end




post '/contacts' do
	@user_mail = params[:user_mail]
	@user_feedback = params[:user_feedback]

	hh2 = { :user_mail => "Введите вашу почту",
			:user_feedback => "Введите ваш отзыв"	}

	@error = hh2.select {|key,_| params[key] == ''}.values.join(", ")

	if @error != ''
	  return erb :contacts
	end

	File.open('./public/contacts.txt', 'a'){|f| f.write("Begin\n#{'=' * 20}\n#{@user_mail}\n#{@user_feedback}\n#{'=' * 20}\nEnd\n")}

	erb :contacts
end