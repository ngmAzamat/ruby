Docker как я понял это:

1. Как виртуальная машина, ведь виртуальная машина нужна для того что бы компилируемый код мог быть запущен на разных операционнох системах, а тут есть контейнезатор который можно запустить на каждой операионной системе при условии что там есть Docker Engine
2. Но при том не требует полной устоновки операционной системы для себя
3. Как следствее произзвотельнее и менее затратое
4. Сосотоит из контейнеров: каждый контейнер имеет всю экосистему для сосуществования
5. Если в двух разных контейнеров есть одинаковая библиотека на разных версиях, это не вызывает ошибку
6. Поледняя Версия 28.2.2, однко chatGPT узнает информацию от людей а значит если никто ему не разкажет что оказывается есть версия 28.2.2, то он до того не будет знать информацию
7. docker - проэкт архетектуры, и нуждается в чертеже(см Образ)

Docker Engine - Клиент-Серверное Приложение, состоящий из

Сервера "Docker Демон" - фоновой просесс, которй всем рулит. он то и создает и упровляет образы, контейтеры, тома
API - Интерфейс обеспеивающий взаимодействия Демона с CLI клиентом
CLI клиент - по сути командная строка

Dockerfile - файл с инструкиями как созадать Образ
Dockerimage(Образ) - Шаблон на основании которога создаются и запускаются контейнеры для создание контейнеров
Dockercontainer - которые предстовляют из себя набор файлов, деректорий, символиеский ссылок и необходимй инструментов

иными словами чертеж для формы для печенья это Dockerfile, сама форма для запекания это как Dockerimage, а Пеенье это Docker container

Откслки:
Великий образ Амбера из Хроник Амбера как "Образ" ну и Деймон Таргариен как "Демон"

Практика:

🐧 Устоновим на Ubuntu Docker:

```bash
# 1. Обнови индекс пакетов
sudo apt update

# 2. Установи зависимости
sudo apt install apt-transport-https ca-certificates curl software-properties-common

# 3. Добавь официальный GPG ключ Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg

# 4. Добавь репозиторий Docker
sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# 5. Ещё раз обнови индекс пакетов
sudo apt update

# 6. Установи Docker Engine
sudo apt install docker-ce docker-ce-cli containerd.io

# 7. Проверь, что Docker работает
sudo docker run hello-world

sudo usermod -aG docker $USER

docker --version
```

Dockerfile: надо настроить для созадания Оброза:

```Dockerfile
FROM alpine
CMD ["echo", "Hello from Alpine!"]
```

создание образ а потом делаем container

```bash
sudo docker build -t testimage .
sudo docker run testimage
```

Факт!
Docker Hub - Общедоступный репозиторий образов — как GitHub для кода.

вывод всех образов - docker image ls
docker push - отправить образ в docker hub
docker pull - скачать образ

вообщем, с нуля делаем все:

Команды:

```bash
mkdir docker
touch Dockerfile
```

Dockerfile:

```Dockerfile
FROM alpine
CMD ["echo", "Hello from Alpine!"]
```

Команды:

```bash
docker build -t testimage .
docker run testimage
```

регистрируемся на docker hub

Команды:

```bash
sudo docker login
sudo docker tag testimage azamatnigmatullin/testimage:latest
sudo docker push azamatnigmatullin/testimage:latest
```

копируем оттуда:

```bash
sudo docker pull azamatnigmatullin/testimage
```

проверка:

```bash
sudo docker image list
```

создать проэкт:

sudo docker tag testimage azamatnigmatullin/testimage:latest
sudo docker push azamatnigmatullin/testimage:latest

залить проэкт:

sudo docker build -t rails .
sudo docker run -p 3000:3000 rails
sudo docker tag rails azamatnigmatullin/rails:latest
sudo docker push azamatnigmatullin/rails:latest

sudo docker build -t rails .
sudo docker tag rails azamatnigmatullin/rails:latest
sudo docker push azamatnigmatullin/rails:latest
sudo docker pull azamatnigmatullin/rails:latest

## Melisearch

Gemfile:

```ruby
gem 'meilisearch-rails'
```

<!-- и заменить гем `gem "sqlite3", ">= 1.4"` на `gem 'pg', '~> 1.5'` -->

<!-- Убедись, что в config/database.yml указан adapter: postgresql -->

Команды:

```bash
bundle install
docker run --rm -p 7700:7700 -e MEILI_MASTER_KEY=SUPERSECRET getmeili/meilisearch:v1.7
```

Факт по умолчанию Melisearch идет на `http://127.0.0.1:7700`

SearchController:

```ruby
class SearchController < ApplicationController
  def index
    if params[:q].present?
      @wars = War.search(params[:q])
      @countries = Country.search(params[:q])
      @figures = Figure.search(params[:q])
      @battles = Battle.search(params[:q])
      @users = User.search(params[:q])
      @events = Event.search(params[:q])
    else
      @wars = []
      @countries = []
      @figures = []
      @events = []
      @battles = []
      @users = []
    end
  end
end
```

config/routes.rb:

```ruby
get 'search', to: 'search#index'
```

navbar:

```ruby
<form action="/search" method="get">
  <input name="q" type="text" placeholder="Search...">
  <button type="submit"><i class='bx bx-search'></i></button>
</form>
```

Model:

```ruby
meilisearch do
  attributes :name, :number, :first_belligerents, :second_belligerents, :date # какие то парметры
end
```

touch config/initializers/meilisearch.rb:

```ruby
MeiliSearch::Rails.configuration = {
  meilisearch_url: ENV.fetch('MEILISEARCH_URL', 'http://127.0.0.1:7700'),
  meilisearch_api_key: ENV.fetch('MEILISEARCH_API_KEY', 'SUPERSECRET')
}
```

mkdir -p app/views/search
touch app/views/search/index.html.erb:

```erb
<h1>Search results for: <%= params[:q] %></h1>

<h2>Wars</h2>
<ul>
  <% @wars.each do |war| %>
    <li><%= link_to war.name, war_path(war) %></li>
  <% end %>
</ul>

<h2>Countries</h2>
<ul>
  <% @countries.each do |country| %>
    <li><%= link_to country.name, country_path(country) %></li>
  <% end %>
</ul>

<h2>Figures</h2>
<ul>
  <% @figures.each do |figure| %>
    <li><%= link_to figure.name, figure_path(figure) %></li>
  <% end %>
</ul>

<h2>Battles</h2>
<ul>
  <% @battles.each do |battle| %>
    <li><%= link_to battle.name, battle_path(battle) %></li>
  <% end %>
</ul>

<h2>Events</h2>
<ul>
  <% @events.each do |event| %>
    <li><%= link_to event.name, event_path(event) %></li>
  <% end %>
</ul>

<h2>Users</h2>
<ul>
  <% @users.each do |user| %>
    <li><%= link_to user.email, user_path(user) %></li>
  <% end %>
</ul>
```

touch docker-compose.yml:

```yml
version: "3.8"

services:
  web:
    build: .
    command: bundle exec rails s -b 0.0.0.0 -p 3000
    ports:
      - "3000:3000"
    depends_on:
      - meilisearch
    environment:
      RAILS_ENV: development
      MEILISEARCH_URL: "http://meilisearch:7700"
      MEILISEARCH_API_KEY: "SUPERSECRET"
    volumes:
      - .:/app:delegated
      - ./db:/app/db # <-- монтируем локальную папку db внутрь контейнера
      - bundle_cache:/usr/local/bundle
      - db_data:/app/db # ✅ БАЗА ВСЕГДА В db/ !!!
      - /app/tmp
      - /app/node_modules

  meilisearch:
    image: getmeili/meilisearch:v1.7
    ports:
      - "7700:7700"
    environment:
      MEILI_MASTER_KEY: "SUPERSECRET"

volumes:
  bundle_cache:
  db_data: # ✅ Том теперь под db/
```

config/database.yml:

```yml
default: &default
  adapter: sqlite3
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000

development:
  <<: *default
  database: db/development.sqlite3

test:
  <<: *default
  database: db/test.sqlite3

production:
  <<: *default
  database: db/production.sqlite3
```

sudo docker compose down -v
sudo docker compose up --build

в терминале:

`sudo docker compose down --volumes`
`sudo docker compose up --build`
и у нас появится 3000 локалхост и 7700 для melisearch.

Если что-то поменял в Dockerfile или в гемах:

sudo docker-compose build
sudo docker compose up

sudo docker compose up --build
