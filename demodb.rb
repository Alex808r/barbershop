#encoding: utf-8

require 'sqlite3'
db = SQLite3::Database.new 'barbershop.db'
db.results_as_hash = true

db.execute 'select * from Users' do |row|
			puts "#{row['username']} записался на #{row['datestamp']}"
			puts '==========='
end 