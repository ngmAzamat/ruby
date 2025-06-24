# README

Отлично, что ты это напомнил! Давай закрепим это как **готовый пошаговый рецепт**, если ты хочешь **начать новый проект «чисто и правильно»**, но с учётом твоего желания **`--skip-bundle`**, чтобы всё поставить внутри Docker.

Вот как это будет выглядеть 👇

---

## ✅ Новый чистый проект с Meilisearch и Docker (`--skip-bundle`)

### 🚩 1️⃣ Создай новый проект **и пропусти bundler**

```bash
rails new my_new_app --database=sqlite3 --skip-bundle
cd my_new_app
```

---

### 🚩 2️⃣ Добавь гемы в `Gemfile`

Открой `Gemfile` и добавь:

```ruby
gem 'meilisearch-rails'
gem 'dotenv-rails', groups: [:development, :test]
```

---

### 🚩 3️⃣ Добавь `.env`

Создай файл `.env` в корне проекта:

```dotenv
MEILISEARCH_URL=http://meilisearch:7700
MEILISEARCH_API_KEY=your_secret_key
```

И добавь в `.gitignore`:

```bash
echo ".env" >> .gitignore
```

---

### 🚩 4️⃣ Добавь инициализатор

Создай `config/initializers/meilisearch.rb`:

```ruby
MeiliSearch::Rails.configuration = {
  meilisearch_host: ENV.fetch('MEILISEARCH_URL', 'http://localhost:7700'),
  meilisearch_api_key: ENV.fetch('MEILISEARCH_API_KEY', '')
}
```

---

### 🚩 5️⃣ Создай `Dockerfile`

```dockerfile
FROM ruby:3.4.4

# Системные зависимости
RUN apt-get update -qq && apt-get install -y build-essential libsqlite3-dev git curl

# Node.js и Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# Рабочая папка
WORKDIR /app

# Копируем только Gemfile (lock ещё нет!)
COPY Gemfile ./

# Установим гемы (и создадим lock внутри!)
RUN bundle install

# Теперь копируем всё остальное приложение
COPY . .

# Порт
EXPOSE 3000

# Команда для сервера
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0 -p 3000"]
```

---

### 🚩 6️⃣ Создай `docker-compose.yml`

```yaml
services:
  # web:
  #   build: .
  #   command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0 -p 3000"
  #   ports:
  #     - "3000:3000"
  #   depends_on:
  #     - meilisearch
  #   env_file:
  #     - .env
  #   volumes:
  #     - .:/app:delegated
  #     - bundle_cache:/usr/local/bundle
  #     - /app/tmp
  #     - /app/node_modules

  meilisearch:
    image: getmeili/meilisearch:v1.7
    ports:
      - "7700:7700"
    environment:
      MEILI_MASTER_KEY: your_secret_key

volumes:
  bundle_cache:
```

---

### 🚩 7️⃣ Запусти Docker и установи гемы **в контейнере**

```bash
sudo docker compose build
sudo docker compose up -d
sudo docker compose exec web bundle install
```

Теперь гемы будут установлены **только внутри контейнера**, как ты и хотел.

---

### 🚩 8️⃣ Проверь `curl` и переменные внутри контейнера

```bash
curl http://localhost:7700/health

sudo docker compose exec web bash
echo $MEILISEARCH_URL
```

---

### ✅ 🎉 Всё! Теперь можно:

- писать модели с `include MeiliSearch::Rails`
- мигрировать БД
- запускать индексацию

---

Если хочешь — я могу сделать **готовый архив проекта с рабочими Dockerfile, docker-compose и примером модели User**, чтобы ты просто развернул его и проверил.
Скажи — подготовлю! 🚀✨

Да, всё верно! Ты сделал важную базу — теперь пора начать развивать приложение.

Вот что обычно делают дальше, чтобы запустить базовый рабочий Rails-проект с Meilisearch:

---

## Что делать после настройки Docker + Meilisearch и создания проекта

### 1️⃣ Создай миграции и базовые модели

Например, чтобы создать модель User с полями name и email:

```bash
sudo docker compose exec web rails generate model User name:string email:string
sudo docker compose exec web rails db:migrate
```

---

### 2️⃣ Добавь Meilisearch в модель

В `app/models/user.rb`:

```ruby
class User < ApplicationRecord
  include MeiliSearch::Rails

  meilisearch do
    attributes :name, :email
  end
end
```

---

### 3️⃣ Добавь контроллеры и вьюхи

Например, для регистрации пользователей можно сделать:

```bash
sudo docker compose exec web rails generate controller Users index show new create
```

Далее напиши в контроллере `UsersController` базовые действия (index, show, new, create), и создай формы в вьюхах.

---

### 4️⃣ Запусти сервер (если ещё не запущен)

```bash
sudo docker compose up
```

или

```bash
sudo docker compose exec web rails server -b 0.0.0.0
```

---

### 5️⃣ Проверяй работу Meilisearch

В Rails консоли внутри контейнера:

```bash
sudo docker compose exec web rails console
```

```ruby
# Создай запись
User.create(name: "Azamat", email: "azamat@example.com")

# Запусти индексирование
User.reindex

# Поиск
User.search("Azamat")
```

---

### 6️⃣ Сделай маршруты (routes.rb)

Пример для пользователей:

```ruby
resources :users
root "users#index"
```

---

## В итоге:

- Миграции создадут таблицы в БД
- Модель User сможет индексироваться и искать данные через Meilisearch
- Контроллеры и вьюхи позволят работать с пользователями через браузер

---

Если хочешь — могу помочь сделать пример базового User-контроллера с вьюхами и маршрутизацией.
Или помочь с другими частями проекта — скажи, что нужно!

# Часть I: создание нового компонента

на примере note

1. route
2. controller
3. views
4. models
5. meilisearch

## Глава I: Route

config/routes.rb:

```ruby
resources :notes do
  member do
    get :delete  # для страницы подтверждения удаления
  end
end
```

## Глава II: Controller

rails generate controller Notes index - ибо мы все равно изменим файл так как надо(копируем контроллер users и его меняем)

## Глава III: Views

на самом деле мы копируем папку users/ и ее меняем например переменные меняем имена и поля

## Глава IV: Models

rails generate model Note title:string content:text
rails db:migrate

app/models/note.rb:

```ruby
class Note < ApplicationRecord
  include MeiliSearch::Rails

  meilisearch do
    attribute :title, :content
  end
end
```

## Глава V: Meilisearch

rails c
Note.reindex!

# Часть II: дам надо search готовый сделать хороший

rails generate controller Search search

search controller:

```ruby
def search
  query = params[:q]

  @users = User.search(query)
  @notes = Note.search(query)

  # Если хочешь, можно объединить результаты, но лучше показывать отдельно
end
```

routes.rb:

```ruby
get '/search', to: 'search#search', as: 'search'
```

shared/nav:

```erb
<nav>
  <a href="<%= root_path %>">Home</a>
  <a href="<%= notes_path %>">Notes</a>
  <a href="<%= new_user_path %>">New User</a>
  <a href="<%= new_note_path %>">New Note</a>
  <form action="<%= search_path %>" method="get" class="no-form no-form-search">
    <input name="q" class="small-input" type="text" placeholder="Search..." value="<%= params[:q] %>">
    <button class="button" type="submit"><i class='bx bx-search'></i></button>
  </form>
</nav>
```

app/views/search/search.html.erb:

```erb<%= render 'shared/nav' %>

<h1>Результаты поиска для: "<%= params[:q].presence || "ничего не введено" %>"</h1>

<h2>Users</h2>
<% if @users.any? %>
  <% @users.each do |user| %>
    <div class="search-user-item">
      <%= user.name %>
      <%= link_to 'Open', user_path(user), class: "button-blue" %>
    </div>
  <% end %>
<% else %>
  <p>No users found.</p>
<% end %>


<h2>Notes</h2>
<% if @notes.any? %>
  <% @notes.each do |note| %>
    <div class="search-note-item">
      <span><%= note.title %></span>
      <%= link_to 'Open', note, class: "button-blue" %>
    </div>
  <% end %>
<% else %>
  <p>No notes found.</p>
<% end %>
```

application.css:

```css
/*
 * This is a manifest file that'll be compiled into application.css, which will include all the files
 * listed below.
 *
 * Any CSS (and SCSS, if configured) file within this directory, lib/assets/stylesheets, or any plugin's
 * vendor/assets/stylesheets directory can be referenced here using a relative path.
 *
 * You're free to add application-wide styles to this file and they'll appear at the bottom of the
 * compiled file so the styles you add here take precedence over styles defined in any other CSS
 * files in this directory. Styles in this file should be added after the last require_* statement.
 * It is generally better to create a new file per style scope.
 *
 *= require_tree .
 *= require_self
 */

* {
  outline: none;
  text-decoration: none;
  font-family: sans-serif;
  margin: 0px;
  padding: 0px;
  box-sizing: border-box;
  --border: 1px solid black;
}

html,
body {
  min-width: 100%;
  min-height: 100vh;
}

.light {
  background-color: white;
  color: black;
  --border: 1px solid black;
}

.dark {
  background-color: #111;
  color: white;
  --border: 1px solid white;
}

div {
  display: flex;
  flex-direction: column;
  row-gap: 10px;
  margin-top: 10px;
  margin-bottom: 10px;
}

.main-div {
  display: block;
  padding-left: 25px;
  margin-top: 0px;
  margin-bottom: 0px;
}

main {
  min-width: 100vw;
  min-height: calc(100vh - 121px);
  display: flex;
  justify-content: center;
  align-items: center;
  padding-top: 25px;
  padding-bottom: 25px;
}

a {
  color: rgb(0, 4, 230);
}

a:hover {
  color: rgb(14, 0, 139);
}

form {
  display: flex;
  flex-direction: column;
  row-gap: 15px;
  min-width: 400px;
  border-radius: 10px;
  border: var(--border);
  padding: 40px;
}

.no-form-a {
  color: rgb(0, 4, 230);
}

.no-form-a:hover {
  color: rgb(14, 0, 139);
}

input {
  padding: 10px;
  background-color: var(--border);
  border: var(--border);
  color: var(--border);
  min-width: 100%;
  width: 100%;
}

input:hover {
  border: 1px solid blue;
}

input[type="submit"] {
  background-color: rgb(0, 4, 230);
  color: white;
  padding: 15px;
  border: var(--border);
  border-radius: 3px;
  font-size: 1.275em;
}

input[type="submit"].button-red {
  background-color: red;
  color: white;
  padding: 15px;
  border: var(--border);
  border-radius: 3px;
  font-size: 1.275em;
}

.button {
  background-color: rgb(0, 4, 230);
  color: white;
  padding: 7.5px;
  border: none;
  border-radius: 2px;
  font-size: 1.275em;
}

.no-form-b {
  display: block;
  border-radius: 0px;
  border: none;
  color: white;
  padding: 0px;
  min-width: 0px;
  background-color: transparent;
}
.button-b {
  background-color: transparent;
  color: white;
  padding: 0px;
  border: none;
  border-radius: 0px;
}

.button-b:hover {
  color: red;
}

nav {
  display: flex;
  justify-content: space-around;
  align-items: center;
  margin: 0;
  padding: 30px;
  background-color: black;
}
nav > * {
  color: white;
  cursor: default;
}

nav > a:hover,
input.small-input:hover,
input.small-input:hover::placeholder {
  border: 1px solid red;
  color: red;
}

.no-form {
  display: block;
  border-radius: 0px;
  min-width: 0px;
  border: none;
  padding: 0px;
}

.no-form-search {
  display: flex;
  flex-direction: row;
  column-gap: 5px;
}

table {
  border-collapse: collapse;
  border: 1px solid black;
}
th,
td {
  padding: 20px;
  border: var(--border);
}

.search-wrapper {
  position: relative;
  display: inline-block; /* или flex, если нужно */
}

.small-input {
  border: 1px solid white;
  padding-right: 30px; /* отступ для иконки справа */
}

.search-wrapper i {
  position: absolute;
  right: 10px; /* или сколько нужно */
  top: 50%;
  transform: translateY(-50%);
  pointer-events: none; /* чтобы клик не мешал вводу */
  color: gray; /* цвет иконки */
}

/* Красивая синяя кнопка */
.button-blue {
  background-color: #007bff; /* Bootstrap blue */
  color: #fff;
  padding: 10px 20px;
  text-decoration: none;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.button-blue:hover {
  background-color: #0056b3; /* чуть темнее при наведении */
}

.search-user-item,
.search-note-item {
  display: inline-flex;
  justify-content: space-between;
  align-items: center;
  border: var(--border);
  padding: 10px 20px;
  margin-bottom: 10px;
  border-radius: 5px;
}
```

вместо этого:

```erb
<tr>
  <td><%= note.title %></td>
  <td><%= note.content %></td>
  <td><%= link_to 'Show', note %></td>
  <td><%= link_to '<i class='bxr bx-edit'></i>', edit_note_path(note) %></td>
  <td><%= link_to '<i class='bxr bx-trash'></i>', delete_note_path(note) %></td>
</tr>
```

для иконок нужно:

```erb
<tr>
  <td><%= note.title %></td>
  <td><%= note.content %></td>
  <td><%= link_to 'Show', note %></td>
  <td><%= link_to "<i class='bx bx-edit'></i>".html_safe, edit_note_path(note) %></td>
  <td><%= link_to "<i class='bx bx-trash'></i>".html_safe, delete_note_path(note) %></td>
</tr>
```

appliction.html.erb перед body:

```js
<script>
document.addEventListener('keydown', function (event) {
  const isCtrlOrCmd = event.ctrlKey || event.metaKey;

  if (isCtrlOrCmd && (event.key === '/' || event.key === 'k')) {
    event.preventDefault();
    const dialog = document.getElementById('search-dialog');
    if (dialog && typeof dialog.showModal === 'function') {
      dialog.showModal();
      const input = dialog.querySelector('input');
      if (input) input.focus();
    }
  }

  if (event.key === 'Escape') {
    const dialog = document.getElementById('search-dialog');
    if (dialog?.open) dialog.close();
  }
});
</script>
```

а в body:

```html
<dialog id="search-dialog">
  <form action="<%= search_path %>" method="get" class="no-form no-form-search">
    <button
      type="button"
      class="button-modal"
      onclick="document.getElementById('search-dialog').close()"
    >
      <i class="bxr bx-x"></i>
    </button>
    <input
      name="q"
      class="small-input-dialog"
      type="text"
      placeholder="Search..."
      value="<%= params[:q] %>"
    />
    <button class="button" type="submit"><i class="bx bx-search"></i></button>
  </form>
</dialog>
```

в css:

```css
dialog::backdrop {
  background: rgba(0, 0, 0, 0.6);
}

#search-dialog {
  row-gap: 5px;
  border-radius: 8px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
  border: var(--border);
  padding: 40px;

  /* Центрируем */
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.small-input-dialog {
  border: 1px solid black;
  background-color: white;
  padding-right: 30px; /* отступ для иконки справа */
  min-width: 0px;
}

.button-modal {
  position: absolute;
  background: none;
  border: none;
  color: black;
  padding: 0px;
  cursor: pointer;
  top: 10px;
  right: 10px;
}

.button-modal:hover {
  color: red;
}
```

ps факт: `box-shadow: <offset-x> <offset-y> <blur-radius> <spread-radius> <color>;`
