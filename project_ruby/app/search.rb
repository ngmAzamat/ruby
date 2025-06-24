# require

require 'net/http'
require 'json'

# Настройки

host = "http://localhost:7700"
index = "books"
master_key = ENV['MEILI_MASTER_KEY']

query = "Hobbit"

# Формируем HTTP-запрос

uri = URI("#{host}/indexes/#{index}/search")
req = Net::HTTP::Post.new(uri)
req['Content-Type'] = 'application/json'
req['Authorization'] = "Bearer #{master_key}"
req.body = { q: query }.to_json

# Отправляем запрос

res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(req)
end

# Распарсим JSON
result = JSON.parse(res.body)

puts "=== Результаты поиска ==="

hits = result["hits"]

if hits && !hits.empty?
  hits.each do |hit|
    puts "ID: #{hit['id']}"
    puts "Название: #{hit['title']}"
    puts "Автор: #{hit['author']}"
    puts "-------------------------"
  end
else
  puts "Ничего не найдено."
end