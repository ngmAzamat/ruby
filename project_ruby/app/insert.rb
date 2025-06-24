# require

require 'net/http'
require 'json'

# Настройки

host = "http://localhost:7700"  # имя сервиса в docker-compose
index = "books"
master_key = ENV['MEILI_MASTER_KEY']

# Мы это отправим

documents = [
  { id: 1, title: "The Hobbit", author: "Tolkien" },
  { id: 2, title: "The Lord of the Rings", author: "Tolkien" },
  { id: 3, title: "Harry Potter", author: "Rowling" }
]

# Формируем HTTP-запрос

uri = URI("#{host}/indexes/#{index}/documents")
req = Net::HTTP::Post.new(uri)
req['Content-Type'] = 'application/json'
req['Authorization'] = "Bearer #{master_key}"
req.body = documents.to_json

# Отправляем запрос

res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(req)
end

# Красивый вывод

result = JSON.parse(res.body)

puts "=== Insert result ==="
puts "Task UID: #{result['taskUid']}"
puts "Index UID: #{result['indexUid']}"
puts "Status: #{result['status']}"
puts "Type: #{result['type']}"
puts "Enqueued At: #{result['enqueuedAt']}"
