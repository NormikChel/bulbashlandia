require 'sequel'

DB = Sequel.sqlite(File.expand_path('database.sqlite3', __dir__))

Sequel.extension :migration
Sequel::Migrator.run(DB, File.expand_path('migrate', __dir__))

puts "✅ Миграции применены"
puts "   Таблицы: #{DB.tables.inspect}"