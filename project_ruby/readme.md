sudo docker compose run app ruby search.rb - сеарх
sudo docker compose run app ruby insert.rb - инсерт
sudo docker compose up --build -d - билд

надо сделать так что бы можно было локально запускать через ruby name.rb

надо всего лишь поменять в файлах `host = "http://meilisearch:7700"` на `host = "http://localhost:7700"`

теперь

sudo docker compose up --build -d
curl http://localhost:7700
ruby insert.rb
ruby search.rb
