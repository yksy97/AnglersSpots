# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "csv"

CSV.foreach('db/csv/code.csv', headers: true) do |row|
  Tide.find_or_create_by(prefecture_name: row['prefecture_name'], port_name: row['port_name']) do |tide|
    tide.prefecture_code = row['prefecture_code']
    tide.port_code = row['port_code']
  end
end

tackle_items = [
  {name: 'ロッド', order: 10},
  {name: 'リール', order: 20},
  {name: 'ライン', order: 30},
  {name: 'リーダー', order: 40},
  {name: 'ルアー', order: 50},
  {name: '針', order: 60},
  {name: 'ウキ', order: 70},
  {name: 'その他', order: 9999}
]

tackle_items.each do |ti|
  TackleItem.find_or_create_by(name: ti[:name]) do |i|
    i.order = ti[:order]
  end
end