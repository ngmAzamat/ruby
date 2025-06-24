# ruby

## Часть I: Создание Проэкта

### Глава I: Check versions

ruby -v
rails -v
node -v
yarn -v

### Глава II: Create Application

bundle config set --global path ~/.bundle
gem install rails -v 7.1.5.1
rails _8.0.2_ new my_app --skip-bundle
cd my_app

### Глава III: Installing and Configure

sudo apt update
sudo apt install libyaml-dev
bundle install
yarn install
rails generate controller Pages home about
config/routes.rb:

```ruby
Rails.application.routes.draw do
    root "pages#home"
    get "/about", to: "pages#about"
end
```

bin/rails server

## Часть II: Работа с Проэктом и Маршрутизиция

### Глава I: Где Настраивать

Javascript: app/javascript/application.js
CSS: app/assets/stylesheets/pages.css
HTML(HOME): app/views/pages/home.html.erb
HTML(ABOUT): app/views/pages/about.html.erb
RUBY(Маршрутизиция): config/routes.rb
КОНТРОЛЕРРЫ: app/controlers/

### Глава II: Что Настраивать

Первым Делом Проверка что у нас работает все:

Javascript: `console.log("Работает!")`
CSS: `color: darkblue`

Второе Дело Маршуртизация в HTML(HOME) и тоже самое в HTML(ABOUT):

```html
<nav class="navbar">
  <%= link_to "Home", root_path %> <%= link_to "About", about_path %>
</nav>

<h1>Welcome to the Home Page</h1>
<p>This is the home page content.</p>
```

Третие Дело Исправить CSS(удалить еще `color: darkblue` надо):

```css
.navbar {
  background-color: #333;
  padding: 1rem;
}

.navbar a {
  color: white;
  margin-right: 1rem;
  text-decoration: none;
}

.navbar a:hover {
  text-decoration: underline;
}
```

RUBY(Маршрутизиция):

```ruby
Rails.application.routes.draw do
    root "pages#home"
    get "/about", to: "pages#about"
end
```

Контролерры:

```ruby
class PagesController < ApplicationController
  # 1. Передача переменной во вьюху
  def home
    @greeting = "Добро пожаловать на сайт!"
    # мы сможем в html.erb вывести эту "переменную"
  end

  # 2. Редирект на другую страницу
  def about
    redirect_to root_path
    # фактически мы просто перенаправляем с /about на root URL
  end

  # 3. Работа с данными и переменными
  def courses
    @courses = ["Ruby", "Rails", "JavaScript"]
    # мы сможем в html.erb вывести этот "массив"
  end

  # 4. Рендер другого шаблона
  def show_alt_view
    render "about"
    # например URL: abouts но мы понимаем что это ошибка при вводе URL,  это наверное about и мы на странице abouts runderим about
  end

  # 5. Возврат JSON (для API)
  def api_data
    render json: { status: "ok", message: "Данные переданы", version: "1.0" }
  end

  # 6. Логирование в терминал
  def logger_test
    logger.info "Открыта страница logger_test"
  end

  # 7. Работа с моделью (если есть БД и модель)
  def all_users
    @users = User.all
  end
end
```

но только если в config/routes.rb:

```ruby
get "/courses", to: "pages#courses"
get "/alt", to: "pages#show_alt_view"
get "/api", to: "pages#api_data"
get "/log", to: "pages#logger_test"
get "/users", to: "pages#all_users"
```

форма для отпровления post запроса:

```html
<%= form_with url: "/data", method: :post do %>
<label>Введите текст:</label> <%= text_field_tag :user_input, nil, required:
true %> <%= submit_tag"Отправить"%> <% end %>
```

контроллер обрабатывающий запрос:

```ruby
def data
user_input = params[:user_input]
logger.info "Получен текст: #{user_input}"
render json: { status: "ok", message: "Вы ввели: #{user_input}", version: "1.0" }
end
```

Модель в Rails — это Ruby-класс, который обычно представляет таблицу в базе данных. Модель работает с таблицей, управляет валидациями, ассоциациями и бизнес-логикой. находятся они в app/models

## Часть III: Информация

action жто метод классов контролеров.
Миграция - позволяет не рушить базу данных при созаднии чего то например к name добавить password не полностью заменяя базу данных.

## Часть IV: Проэкт Базы Данных

---

### 🎯 Цель:

1. Пользователь вводит имя через форму.
2. Rails сохраняет его в базу (`users`).
3. В логи выводится `logger.info "Имя: Вася"`.

---

### 🔨 Шаг 1. Генерация модели `User`

```bash
rails generate model User name:string
rails db:migrate
```

> Это создаст таблицу `users` с колонкой `name`.

---

### 🧱 Шаг 2. Контроллер

Создай `UsersController`:

```bash
rails generate controller Users new create
```

И заполни `app/controllers/users_controller.rb`:

```ruby
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(name: params[:user][:name])

    if @user.save
      logger.info "Сохранено имя: #{@user.name}"
      redirect_to root_path, notice: "Имя сохранено!"
    else
      render :new
    end
  end
end
```

---

### 🧭 Шаг 3. Маршруты (`config/routes.rb`)

```ruby
Rails.application.routes.draw do
  root "users#new"
  resources :users, only: [:new, :create]
end
```

---

### 📝 Шаг 4. Вьюха `app/views/users/new.html.erb`

```erb
<h1>Введите имя</h1>

<%= form_with model: @user, local: true do |form| %>
  <div>
    <%= form.label :name, "Имя:" %>
    <%= form.text_field :name %>
  </div>

  <div>
    <%= form.submit "Отправить" %>
  </div>
<% end %>
```

---

### 📦 Шаг 5. Проверка

1. Перейди на страницу `/`
2. Введи имя и нажми "Отправить"
3. Rails:

   - сохранит имя в базу `users`
   - выведет в терминал:

     ```
     Сохранено имя: Вася
     ```

---

### 📌 Где будет `logger.info`?

- В **терминале**, где ты запустил `rails server`
- А также в `log/development.log`

---

### ✅ Бонус: Посмотреть всех пользователей

Добавим в `UsersController` метод:

```ruby
def new
  @user = User.new
  @users = User.all
end

```

В `routes.rb`:

```ruby
resources :users, only: [:new, :create, :index]
```

Во вьюху `new.html.erb`:

```erb
<h2>Список пользователей:</h2>
<% @users.each do |user| %>
  <li><%= user.name %></li>
<% end %>
```

### Очистить Базу Данных

rails db:drop db:create db:migrate

## Миграции

### 💡 Что такое миграция в Rails?

**Миграция** — это способ **пошагово изменять структуру базы данных**, сохраняя код этих изменений в виде Ruby-файлов. Это как **история изменений схемы базы**, только в коде.

#### ✅ Пример:

Вот миграция, которая создаёт таблицу `users` с полем `name`:

```ruby
class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.timestamps
    end
  end
end
```

А вот миграция, которая потом добавляет `password`:

```ruby
class AddPasswordToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :password, :string
  end
end
```

---

### 📦 Зачем это нужно?

- Чтобы **не трогать существующие данные**
- Чтобы **изменения можно было отменить (rollback)**
- Чтобы **все разработчики имели одинаковую структуру БД**
- Чтобы **структура базы данных жила в коде проекта**

---

### 📂 Где хранятся миграции?

В папке:

```
db/migrate/
```

Каждый файл — это отдельная миграция, и в имени файла будет дата и время создания.

---

### 🔧 Как применить миграции?

```bash
rails db:migrate
```

#### Как отменить последнюю миграцию:

```bash
rails db:rollback
```

## Часть V: Меняю Базы Данных

rails generate migration AddPasswordToUsers password:string
rails db:migrate

модель users.rb:

```ruby
class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validates :password, presence: true, length: { minimum: 6 }
end
```

users_controller.rb:

```ruby
def create
  @user = User.new(name: params[:user][:name], password: params[:user][:password])

  if @user.save
    redirect_to root_path, notice: "Имя и пароль сохранены!"
  else
    render :new
  end
end
```

new.html.erb:

```erb
<%= form_with(model: @user, local: true) do |form| %>
  <div>
    <%= form.label :name %>
    <%= form.text_field :name %>
  </div>

  <div>
    <%= form.label :password %>
    <%= form.password_field :password %>
  </div>

  <%= form.submit "Сохранить" %>
<% end %>
```

## Кратко

Миграция - что у нас будет в базе данных например :password. Модель - основное применение Валидация, если не про валидированно то не записовается. Контроллер - Мозг Системы, Рендеринги, Редиректы, Получение Данных из формы и запись в Базу Данных. Views - Фронтедная часть, кажется что обычная HTML но на самом деле это HTML где можно вставлять переменные проходится по массивам и это похоже на то что есть в react.

## Часть VI: Веб-Приложение

Цель:

сделать новую базу данных с историческими личностями, там должны быть формы не только для отпровелния но и для редактирования.

Будет поля:

Имя
Фамилия
Цифра
Год Рождения
Год Смерти
Деятельность

Проблемы которые не дают с ходу сделать проэкт:

не способность сделать паральельную базу данных с сосуществованием двух баз данных. не способность сделать редактирование а не записование новых данных.

идеи:

нету

Решение от chatGPT:

### ✅ **1. Параллельная база (две модели/таблицы)**

Ты хочешь иметь **две модели**: `User` и `Figure`. У тебя уже есть `User`. Чтобы добавить `Figure` (историческую личность):

#### 🔧 Шаги:

```bash
rails generate model Figure first_name:string last_name:string number:string birth_year:integer death_year:integer occupation:string
rails db:migrate
rails generate controller Figures
mkdir -p app/views/figures
touch app/views/figures/new.html.erb
touch app/views/figures/index.html.erb
touch app/views/figures/edit.html.erb

```

---

### ✅ **2. Редактирование записей**

#### В `routes.rb`:

```ruby
Rails.application.routes.draw do
  root "users#new"
  resources :users, only: [:index, :new, :create, :edit, :update]
  resources :figures, only: [:index, :new, :create, :edit, :update]
  get "/about", to: "pages#about"
  get "/abouts", to: "pages#abouts"
  get "/data", to: "pages#data"
  post "/data", to: "pages#data"
  get "/courses", to: "pages#courses"
end
```

#### ✅ 4. Контроллер figures_controller.rb

```ruby
class FiguresController < ApplicationController
  def index
    @figures = Figure.all
  end

  def new
    @figure = Figure.new
  end

  def create
    @figure = Figure.new(figure_params)
    if @figure.save
      redirect_to figures_path, notice: "Добавлено!"
    else
      render :new
    end
  end

  def edit
    @figure = Figure.find(params[:id])
  end

  def update
    @figure = Figure.find(params[:id])
    if @figure.update(figure_params)
      redirect_to figures_path, notice: "Личность обновлена"
    else
      render :edit
    end
  end

  private

  def figure_params
    params.require(:figure).permit(:first_name, :last_name, :number, :birth_year, :death_year, :occupation)
  end
end
```

#### figures/new

```erb
<h1>Добавить историческую личность</h1>

<%= form_with(model: @figure, local: true) do |form| %>
  <p>
    <%= form.label :first_name, "Имя" %><br>
    <%= form.text_field :first_name %>
  </p>

  <p>
    <%= form.label :last_name, "Фамилия" %><br>
    <%= form.text_field :last_name %>
  </p>

  <p>
    <%= form.label :number, "Цифра" %><br>
    <%= form.number_field :number %>
  </p>

  <p>
    <%= form.label :birth_year, "Год рождения" %><br>
    <%= form.number_field :birth_year %>
  </p>

  <p>
    <%= form.label :death_year, "Год смерти" %><br>
    <%= form.number_field :death_year %>
  </p>

  <p>
    <%= form.label :occupation, "Род деятельности" %><br>
    <%= form.text_field :occupation %>
  </p>

  <p>
    <%= form.submit "Сохранить" %>
  </p>
<% end %>
```

---

#### figures/edit

Создай файл:
touch app/views/figures/edit.html.erb

```erb
<h1>Редактировать личность</h1>

<%= form_with model: @figure, local: true do |form| %>
  <%= form.label :first_name, "Имя" %>
  <%= form.text_field :first_name %>

  <%= form.label :last_name, "Фамилия" %>
  <%= form.text_field :last_name %>

  <%= form.label :number, "Цифра" %>
  <%= form.text_field :number %>

  <%= form.label :birth_year, "Год рождения" %>
  <%= form.number_field :birth_year %>

  <%= form.label :death_year, "Год смерти" %>
  <%= form.number_field :death_year %>

  <%= form.label :occupation, "Род деятельности" %>
  <%= form.text_field :occupation %>

  <%= form.submit "Сохранить изменения" %>
<% end %>
```

#### figures/index

```erb
<h1>Список исторических личностей</h1>

<%= link_to "Добавить новую личность", new_figure_path %>

<% @figures.each do |figure| %>
  <div>
    <strong><%= [figure.first_name, figure.last_name].compact.join(" ") %></strong><br>
    <p>Годы жизни: <%= figure.birth_year %> – <%= figure.death_year %></p>
    <p>Занятие: <%= figure.occupation %></p>
    <p>Цифра: <%= figure.number %></p>
    <%= link_to "Редактировать", edit_figure_path(figure) %>
  </div>
  <hr>
<% end %>
```

#### users/create

тут надо просто этот файл сделать для галочки(все же хотят галочку)

#### users/edit

```erb
<h1>Редактировать пользователя</h1>

<%= form_with(model: @user, local: true) do |form| %>
  <div>
    <%= form.label :name %>
    <%= form.text_field :name %>
  </div>

  <div>
    <%= form.label :password %>
    <%= form.password_field :password %>
  </div>

  <%= form.submit "Обновить" %>
<% end %>

```

#### users/index

```erb
<h1>Список пользователей</h1>
<% @users.each do |user| %>
  <p><%= user.name %></p>
<% end %>
```

#### users/new

```erb
<h1>Новый пользователь</h1>

<%= form_with(model: @user, local: true) do |form| %>
  <div>
    <%= form.label :name %>
    <%= form.text_field :name %>
  </div>

  <div>
    <%= form.label :password %>
    <%= form.password_field :password %>
  </div>

  <%= form.submit "Создать" %>
<% end %>
```

#### В `users_controller.rb`:

```ruby
class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
    @figures = Figure.all
  end

  def update
    @user = User.find(params[:id])
    @figures = Figure.all

    if @user.update(user_params)
      redirect_to root_path, notice: "Пользователь обновлён"
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def new
    @user = User.new
    @figures = Figure.all
  end

  def create
    @user = User.new(user_params)
    @figures = Figure.all # иначе рендер new выдаст ошибку

    if @user.save
      redirect_to root_path, notice: "Пользователь создан"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end
end

```

### Выводы от Меня

Пробелма с Паралельностью вовсе даже не проблема ибо оказывается мы делаем все то что при обычной ситуации и делаем(генерации и так далее).

новый проэкт:

## Обновления версии до 8.0.2

по опыту говорю первом делом перед обновлением версии, надо убедится что версия не несет огромных изменений,
прежде всего тут надо помнить про то что если версия меняет какие то шаги в созаднии проэкта но это надо знать.

Версия 8:

| Область             | Изменения в Rails 8                                                 |
| ------------------- | ------------------------------------------------------------------- |
| ✅ Создание проекта | `rails new` больше не использует Webpacker.                         |
| 📦 JS-часть         | Переход на `jsbundling-rails` + ESBuild/Vite/Bun.                   |
| 🧵 CSS-часть        | Переход с Sprockets на Propshaft по умолчанию.                      |
| 🚫 Устаревшие API   | Многие методы удалены: `remote: true`, `alias_method_chain` и т.д.  |
| ⚙️ Конфигурация     | Изменены пути, Zeitwerk строже к неймингу.                          |
| 📦 Gemfile          | Старые гемы ломаются (например, devise или paperclip без апдейтов). |
| 💡 Defaults Rails 8 | Изменения в поведении, даже если ты не меняешь код.                 |

ну да ладно перед всем тем созданием проэкта надо обновить версию.

### Глава I

1. `ruby -v` ruby тоже важен, у меня версия 3.2.3. не самая новая но наверное пойдет
2. `rails -v` убедимся в нашей версии rails
3. `sudo apt update && sudo apt upgrade` это общее полезное обновление но не для rails я же только что делал это
4. `gem update --system`
5. `gem install bundler`

### Глава II

1. устонавливаем `gem install rails -v 8.0.2`, `rails -v`
2. `rails new myapp8 --skip-javascript`
3. `cd myapp8`
4. `bundle install`
5. `rails db:create`
6. `rails s`

### Глава III

куда делся старый знакомый `bin/rails server`? `rails s` и есть сокращение от того! но было ли это раньше еще в 7.1.5.1 или от меня что то скрывали?
нет получается и раньше было `rails s` но я просто не знал!

### Глава IV:

обновление ruby до 3.4.4:

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 3.4.4
rbenv global 3.4.4
rbenv rehash
ruby -v

### Как удолить git из my app?

пока нету

## Часть VII: Шаблон для country

### ✅ Генерация модели и миграция

```bash
rails generate model Country name:string first_year:integer last_year:integer army:integer area:integer population:integer
rails db:migrate
rails generate controller Countries
```

---

### ✅ Роуты (`routes.rb`)

```ruby
resources :countries, only: [:index, :new, :create, :edit, :update]
```

---

### ✅ Контроллер `countries_controller.rb`

```ruby
class CountriesController < ApplicationController
  def index
    @countries = Country.all
  end

  def new
    @country = Country.new
  end

  def create
    @country = Country.new(country_params)
    if @country.save
      redirect_to countries_path, notice: "Страна добавлена!"
    else
      render :new
    end
  end

  def edit
    @country = Country.find(params[:id])
  end

  def update
    @country = Country.find(params[:id])
    if @country.update(country_params)
      redirect_to countries_path, notice: "Страна обновлена"
    else
      render :edit
    end
  end

  private

  def country_params
    params.require(:country).permit(
    :name,
    :first_year,
    :last_year,
    :army,
    :area,
    :population
    )
  end
end

```

---

### ✅ Представления (`app/views/battles/`)

#### `new.html.erb`

```erb
<h1>Добавить страну</h1>

<%= form_with model: @country, local: true do |form| %>
  <p><%= form.label :name, "Название" %><br><%= form.text_field :name %></p>
  <p><%= form.label :army, "Численность армии" %><br><%= form.number_field :army %></p>
  <p><%= form.label :population, "Численность населения" %><br><%= form.number_field :population %></p>
  <p><%= form.label :area, "Площадь строны в квадратных километрах" %><br><%= form.number_field :area %></p>
  <p><%= form.label :first_year, "Год начало существования" %><br><%= form.number_field :first_year %></p>
  <p><%= form.label :last_year, "Год конца существования" %><br><%= form.number_field :last_year %></p>
  <%= form.submit "Сохранить изменения" %>
<% end %>
```

---

#### `edit.html.erb`

```erb
<h1>Редактировать страну</h1>

<%= form_with model: @country, local: true do |form| %>
  <p><%= form.label :name, "Название" %><br><%= form.text_field :name %></p>
  <p><%= form.label :army, "Численность армии" %><br><%= form.number_field :army %></p>
  <p><%= form.label :population, "Численность населения" %><br><%= form.number_field :population %></p>
  <p><%= form.label :area, "Площадь строны в квадратных километрах" %><br><%= form.number_field :area %></p>
  <p><%= form.label :first_year, "Год начало существования" %><br><%= form.number_field :first_year %></p>
  <p><%= form.label :last_year, "Год конца существования" %><br><%= form.number_field :last_year %></p>
  <%= form.submit "Сохранить изменения" %>
<% end %>
```

---

#### `index.html.erb`

```erb
<h1>Список стран</h1>

<%= link_to "Добавить новую страну", new_country_path %>

<% @countries.each do |country| %>
  <div>
    <strong><%= country.name %></strong><br>
    <p>Численность армии: <%= country.army %></p>
    <p>Численность населения: <%= country.population %></p>
    <p>Площадь строны в квадратных километрах: <%= country.area %></p>
    <p>Время сущствования: <%= country.first_year %> — <%= country.last_year %></p>
    <%= link_to "Редактировать", edit_country_path(country) %>
  </div>
  <hr>
<% end %>
```

## Часть VIII: Аутентификация

### Вариант I: device

1. bundle add devise
2. bundle install
3. rails generate devise:install
4. `config/environments/development.rb`: добавим `config.action_mailer.perform_caching = false; config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }`

### Вариант II: встроенная аутентификация

#### Глава I: Создание

1. `rails generate authentication User`
2. `rails db:migrate`
3. `rm db/migrate/20250529122225_create_users.rb`

а есле уже существует user? то к счастью а может и не к счасьтью он не перезаписывает user, он добавляет нужные поля. что дальше?

1. Модель user:

```ruby
class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
end
```

2. `rails generate migration AddPasswordDigestToUsers password_digest:string`
3. `rails db:migrate`
4. `rails generate controller Registrations`
5. `mkdir -p app/views/registrations`
6. `touch app/views/registrations/new.html.erb`

#### Глава II: Много Букв

##### Проверка Маршрутов в config/routes.rb:

```ruby
get "sign_up", to: "registrations#new"
post "sign_up", to: "registrations#create"
get "sign_in", to: "sessions#new"
post "sign_in", to: "sessions#create"
delete "logout", to: "sessions#destroy"
```

#### Контроллер app/controllers/registrations_controller.rb:

```ruby
class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Регистрация успешна!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
```

#### Контроллер app/controllers/sessions_controller.rb:

```ruby
class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Вы вошли!"
    else
      flash.now[:alert] = "Неверный email или пароль"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Вы вышли!"
  end
end
```

#### Вьюха app/views/registrations/new.html.erb:

```erb
<h1>Регистрация</h1>

<%= form_with model: @user, url: sign_up_path do |f| %>
  <div>
    <%= f.label :email %>
    <%= f.email_field :email %>
  </div>

  <div>
    <%= f.label :password %>
    <%= f.password_field :password %>
  </div>

  <div>
    <%= f.label :password_confirmation %>
    <%= f.password_field :password_confirmation %>
  </div>

  <%= f.submit "Зарегистрироваться" %>
<% end %>
```

#### Вьюха app/views/sessions/new.html.erb:

```erb
<h1>Вход</h1>

<%= form_with url: sign_in_path do |f| %>
  <div>
    <%= f.label :email %>
    <%= f.email_field :email %>
  </div>

  <div>
    <%= f.label :password %>
    <%= f.password_field :password %>
  </div>

  <%= f.submit "Войти" %>
<% end %>
```

#### Контроллер ApplicationController:

```ruby
class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
```

#### Вьюха app/views/layouts/application.html.erb:

```erb
<!DOCTYPE html>
<html>
  <head>
    <title>MyApp</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
  </head>

  <body>
    <header>
      <% if current_user %>
        Привет, <%= current_user.email %> |
        <%= button_to "Выйти", logout_path, method: :delete, form: { style: "display: inline;" } %>
      <% else %>
        <%= link_to "Вход", sign_in_path %> |
        <%= link_to "Регистрация", sign_up_path %>
      <% end %>
    </header>

    <footer>
      <%= yield %>
    </footer>
  </body>
</html>
```

#### далее:

1. `rails generate migration RenameEmailAddressToEmailInUsers`
2. В сгенерированном файле db/migrate/...rename_email_address_to_email_in_users.rb напиши:

```ruby
class RenameEmailAddressToEmailInUsers < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :email_address, :email
  end
end
```

3. `rails db:migrate`
4. `rails generate migration AddEmailToUsers email:string`
5. `rails db:migrate`
6. `rm db/migrate/20250530052155_rename_email_address_to_email_in_users.rb`
7. `rails db:migrate`
8. `rails console`
9. `User.column_names`

#### config/routes.rb

```ruby
Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  root "home#index"
  resources :users, only: [:index, :new, :create, :edit, :update]
  resources :figures, only: [:index, :new, :create, :edit, :update]
  resources :battles, only: [:index, :new, :create, :edit, :update]
  resources :countries, only: [:index, :new, :create, :edit, :update]
  resources :wars
  get "/about", to: "pages#about"
  get "/abouts", to: "pages#abouts"
  get "/data", to: "pages#data"
  post "/data", to: "pages#data"
  get "/courses", to: "pages#courses"
  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
end
```

#### app/views/registrations/new.html.erb

```erb
<h1>Регистрация</h1>

<% if @user.errors.any? %>
  <ul>
    <% @user.errors.full_messages.each do |msg| %>
      <li><%= msg %></li>
    <% end %>
  </ul>
<% end %>

<%= form_with model: @user, url: sign_up_path, local: true do |f| %>
  <div>
    <%= f.label :name %>
    <%= f.text_field :name %>
  </div>

  <div>
    <%= f.label :email %>
    <%= f.email_field :email %>
  </div>

  <div>
    <%= f.label :password %>
    <%= f.password_field :password %>
  </div>

  <div>
    <%= f.label :password_confirmation %>
    <%= f.password_field :password_confirmation %>
  </div>

  <%= f.submit "Зарегистрироваться" %>
<% end %>

```

#### app/views/layouts/application.html.erb

```erb
<!DOCTYPE html>
<html>
  <head>
    <title>MyApp</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
  </head>

  <body>
    <header>
      <% if current_user %>
        Привет, <%= current_user.email %> |
       <%= form_with url: logout_path, method: :delete, class: "no-form" do %>
         <button class="no-form-a" type="submit">Выйти</button>
        <% end %>
      <% else %>
        <%= link_to "Вход", sign_in_path %> |
        <%= link_to "Регистрация", sign_up_path %>
      <% end %>
    </header>

    <footer>
      <%= yield %>
    </footer>
  </body>
</html>
```

#### registration_controller.rb

```ruby
class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

def create
  @user = User.new(user_params)

  if @user.save
    session[:user_id] = @user.id
    redirect_to root_path, notice: "Регистрация успешна!"
  else
    render :new, status: :unprocessable_entity # ВАЖНО: render, а не redirect
  end
end


  private

def user_params
  params.require(:user).permit(:name, :email, :password, :password_confirmation)
end
end
end
```

#### app/assets/stylesheets/application.css

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
}

html,
body {
  min-width: 100%;
  min-height: 100vh;
}

div {
  display: flex;
  flex-direction: column;
  row-gap: 10px;
  margin-top: 10px;
  margin-bottom: 10px;
}

main {
  min-width: 100%;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

nav {
  display: flex;
  justify-content: space-around;
  align-items: center;
  margin: 0;
  padding: 30px;
  background-color: #222;
}

a {
  color: rgb(0, 4, 230);
}

a:hover {
  color: rgb(14, 0, 139);
}

nav > a {
  color: white;
}

nav > a:hover {
  color: red;
}

form {
  display: flex;
  flex-direction: column;
  row-gap: 20px;
  border-radius: 10px;
  border: 1px solid black;
  padding: 50px;
}

.no-form {
  display: inline;
  border-radius: 0px;
  border: none;
  padding: 0px;
}

.no-form-a {
  color: rgb(0, 4, 230);
}

.no-form-a:hover {
  color: rgb(14, 0, 139);
}

input {
  padding: 10px;
  border: 1px solid black;
  color: black;
  width: 100%;
}

input:hover {
  border: 1px solid blue;
}

input[type="submit"] {
  background-color: rgb(0, 4, 230);
  color: white;
  padding: 15px;
  border: 1px solid black;
  border-radius: 3px;
}
```

## Часть IX: Куки

однажды я задумался о куки, ведь их пихают везде, для того что бы запомнить пользователя, но почему для того нелья изпользовать Аутентификацию?

В Ruby on Rails работа с куками (cookies) — это стандартная часть системы контроллеров.
Куки позволяют сохранять данные на стороне клиента, и Rails предоставляет простой API для чтения и записи этих данных.
иными словами те данные проще обровабывать и они на стороне клиента.

---

### 📦 Основы работы с куками в Rails

#### ✅ Запись куки:

```ruby
cookies[:user_name] = "Henry"
```

#### ✅ Чтение куки:

lilimalai2021

```ruby
user_name = cookies[:user_name]
```

#### ✅ Удаление куки:

```ruby
cookies.delete(:user_name)
```

---

### ⏳ Установка срока действия куки

По умолчанию куки живёт до конца сессии (пока не закрыт браузер).

Чтобы задать срок:

```ruby
cookies[:user_name] = {
  value: "Henry",
  expires: 1.week.from_now
}
```

---

### 🔐 `cookies.signed` — **Подписанные** куки

#### Что делает?

Rails **подписывает куку**, то есть добавляет **криптографическую подпись**.

Это защищает от **подделки**. То есть **значение видно в браузере, но при том оно сериализованно то есть его можно прочитать только если заморочится**, его нельзя подделать без секрета (ключа Rails).

---

#### Пример:

```ruby
cookies.signed[:user_id] = 42
```

📤 На клиенте кука будет выглядеть примерно так:

```
user_id=Что--Что
```

📥 Когда Rails читает `cookies.signed[:user_id]`, он:

1. шифрует значение(но его в отличии от encrypted можно расшифровать)
2. Проверяет подпись (через HMAC и `secret_key_base`)
3. Если подпись не совпадает → `nil` (Rails молча отвергает её)

---

### 🔒 `cookies.encrypted` — **Зашифрованные** куки

#### Что делает?

Rails **шифрует** значение куки. То есть:

- **Содержимое полностью скрыто** от клиента
- **Подпись тоже присутствует** (внутри шифра)

---

#### Пример:

```ruby
cookies.encrypted[:auth_token] = {
  value: "secret-token",
  expires: 1.hour.from_now
}
```

📤 На клиенте кука будет выглядеть как непонятный набор символов:

```
auth_token=Что
```

📥 При чтении:

```ruby
token = cookies.encrypted[:auth_token]
```

Rails:

1. Расшифровывает содержимое
2. Проверяет подпись (встроена)
3. Если всё верно → возвращает `"secret-token"`
4. Если подделано → `nil`

---

### 🤔 Когда что использовать?

| Тип куки                | Видна в браузере?                         | Защищена от подделки? | Использовать для…                         |
| ----------------------- | ----------------------------------------- | --------------------- | ----------------------------------------- |
| `cookies[:x]`           | ✅ Да                                     | ❌ Нет                | Всякая мелочь безопасная (темы, фильтры)  |
| `cookies.signed[:x]`    | ❌ Нет(но при желании можно расшифровать) | ✅ Да                 | `user_id`, флаги, ID-шники и прочее       |
| `cookies.encrypted[:x]` | ❌ Нет                                    | ✅ Да                 | Токены, email, имена, чувствительные вещи |

---

### 🔐 Ключи безопасности

Rails использует `secret_key_base` из `config/credentials.yml.enc` или `secrets.yml`. Он используется для:

- HMAC (подписи)
- AES (шифрование)

📌 Никогда не храни этот ключ в открытом виде в публичных репозиториях.

---

### 🔐 Пример — Rails устанавливает куку:

```ruby
cookies.encrypted[:auth_token] = {
  value: "super-token",
  expires: 1.hour.from_now
}
```

И в DevTools ты увидишь:

| Name         | Value                                   |
| ------------ | --------------------------------------- |
| `auth_token` | `eyJfcmFpbHMiOnsibWVzc2FnZSI6IkV4QU...` |

А если использовать `cookies[:auth_token]`, то:

| Name         | Value         |
| ------------ | ------------- |
| `auth_token` | `super-token` |

И это легко читается в браузере → не защищено.

---

### 💡 Где использовать

Работа с куками обычно происходит в контроллерах. Например:

```ruby
class ApplicationController < ActionController::Base
  def set_cookie
    cookies[:theme] = "dark"
  end

  def get_cookie
    @theme = cookies[:theme]
  end
end
```

---

### ⚠️ Важные замечания

- Куки ограничены в размере (около 4 КБ).
- Никогда не храни в куках конфиденциальные данные без шифрования.
- Лучше использовать `session[:key]`, если тебе нужно сохранить данные между запросами, но не на долгое время — сессии хранятся на сервере (или в зашифрованных куках, если ты используешь cookie store).

### ✅ Где увидеть куки в браузере?

Вот **2 способа**, как ты можешь увидеть свои куки в браузере:

---

#### 🔍 1. **DevTools → Application → Cookies**

1. Открой сайт, на котором ты установил куку (например, в Rails `localhost:3000`)
2. Нажми `F12` или `Ctrl+Shift+I` (откроется **DevTools**)
3. Перейди во вкладку **Application** (или Storage → Cookies в Firefox)
4. Слева — выбери свой домен (`localhost`, например)
5. Справа ты увидишь **таблицу с куками**:

| Name         | Value                                   | Expires | ... |
| ------------ | --------------------------------------- | ------- | --- |
| `auth_token` | `eyJfcmFpbHMiOnsibWVzc2FnZSI6IkV4QU...` | 1 час   |     |

---

#### 🧾 2. **В консоли DevTools (Console)**

Если ты хочешь посмотреть куки прямо в JS-консоли:

```js
document.cookie;
```

Но ⚠️ **тут есть ограничения**:

- Покажутся **только куки без флага `HttpOnly`**
- Rails по умолчанию НЕ ставит `HttpOnly: true` — значит, ты их увидишь

---

### Глава I: Ценная Информация

1. на самом деле можно зайти в dev tools --> network --> нажать на что то --> раскрыть запрос и ответ.
2. в том сулчаи мы увидем set cookies и cookies. появляется аналогия с брастелом.

ананлогия с брастелом:
приходя в отель нам дают браслет(set cookies на стороне сервера), мы когда хотим поесть показываем браслет который когда то нам отдали(cookies).
а если мы выбрасываем браслет(очищение cookie), то нам выдадут еще и новый(set cookies).

также информация про http запрос(полезно знать): он состоит из:

1. кода - например 404
2. заголовка(в них находятся и куки) - состоящими из ключ - значение, также это то что НЕ является html или данными из формы.
3. тело запроса или ответа - например данные пормы при post-запросе или html при get-ответе. при get-запросе нету тела.
4. а что такое аутентификация? а что когда ты показываешь пасспорт, но что бы каждый раз при входе не показывать пасспорт вам дуют браслет.
5. session, сессия это как война - понятие абстрактное в отличии от сражения. сессия обьединение http запросов(сражений).
6. также сессия наинается с того как произходит аутентификация(обьявление войны) и до входа из учетки.

### Глава II: как добавить http only?

просто в обьект добавляем `httponly: true`

```ruby
cookies[:user_name] = {
  value: "Henry",
  httponly: true,
  expires: 1.day.from_now
}
```

### Глава III: session

тут имеем дело не с сессией(та которая как война), а имеется ввиду session который как cookie.

отличия:

| Свойство                          | `session` в Rails                | `cookies` в Rails                                              |
| --------------------------------- | -------------------------------- | -------------------------------------------------------------- |
| Формат                            | Хэш с символами в ключах         | Хэш с строками в ключах                                        |
| Где хранятся                      | По умолчанию — в cookie          | В cookie                                                       |
| Доступ из JS                      | ❌ Нет (`HttpOnly` по умолчанию) | ✅ Да, если `HttpOnly: false`                                  |
| Безопасность                      | Шифруется и подписывается        | Обычно в открытом виде                                         |
| Подходит для                      | Идентификации, user_id и сессий  | Промокодов, настроек и т.п.                                    |
| что происходит после конца сессии | уничтожаются                     | уничтожаются только те куки которые работали с аутентификацией |

также еще есть аналогия с браслетом:
аутентификация это когда ты прихошь с пасспортом и говоришь "Мое имя такое то, и я люблю творог",
после чего бычно тебе дают браслет с цветом серым(озночаюшим творог) - этоset cookie
cookie это когда ты приходишь не с браслетом "я люблю творог".
session этоо когда ты приходишь с номером 42, после чего сервер смотрит в книжку и говорит "ага! 42 - любит творог".

иными словами, это:

```ruby
session[:auth_token] = "super-token"
```

тоже самое что и это:

```ruby
cookies.encrypted[:auth_token] = {
  value: "super-token",
  httponly: true,
}
```

## Часть X: Проэкт "Темы"

куки изпольщуются для аутентификации, в данный момент это не важно ибо аутентификация встроенная в rails 8.0.2.
но также появилось идея со светлой и темной темой.

### Глава I: как сделать

будет кук, значение light = светлая тема, значение dark = темная тема. будет переключатель(две кнопки).
если нажать на кнопку темная тема то кук это запомнит, а класс будет не light, а dark.

Проблемы: я знал как сделать это в js, ибо там можно ментяьь классы HTML через js, но не знаю как делать через ruby. chatGPT сказал так:

### Глава II: Реализация

#### Контроллер app/controllers/application_controller.rb

```ruby
class ApplicationController < ActionController::Base
  helper_method :current_user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  before_action :set_theme
  private
  def set_theme
    @theme = cookies[:theme] || "light"  # по умолчанию "light"
  end
end
```

#### Вьюха application.html.erb

```erb
<%= form_with url: set_theme_path(theme: "light"), method: :post, class: "no-form" do %>
  <button type="submit" class="light-button no-form-a">Светлая тема</button>
<% end %>

<%= form_with url: set_theme_path(theme: "dark"), method: :post, class: "no-form" do %>
  <button type="submit" class="dark-button no-form-a">Тёмная тема</button>
<% end %>
```

#### Роуты routes.rb

```ruby
post 'set_theme', to: 'themes#set'
```

#### Контроллер app/controllers/themes_controller.rb

генерируем контроллер: `rails generate controller Themes`

```ruby
class ThemesController < ApplicationController
  def set
    cookies[:theme] = params[:theme]
    redirect_back fallback_location: root_path
  end
end
```

#### css app/assets/stylesheets/application.css

### Глава III: что я узнал от проэкта

1. оказывается можно кукам задавать базывае значения `@переменная = cookies[:переменная] || "значение"`
2. можно регулировать через руби и куки `классы для erb`

## Часть XI: РАБОТАЮ БЕЗ CHATGPT

это довольно странно, но как минимум в css я разбираюсь. но дольнейшое развитие прожкта делал я сам.

## Часть XII: Удаление

допустим у нас было:

```erb
<%= render 'shared/nav' %>

<div class="main-div">
<h1>Список пользователей</h1>
<table>
<thead>
<tr>
<th>Имя</th>
<th>Email</th>
<th>Действия</th>
<tr>
</thead>
<tbody>
<% @users.each do |user| %>
<tr>
  <td><%= user.name %></td>
  <td><%= user.email %></td>
  <td><%= link_to "Редактировать", edit_user_path(user) %> | <%= link_to "Удалить", edit_user_path(user) %></td>
</tr>
<% end %>
</tbody>
</table>
</div>
```

надо сделать из того это:

```erb
<%= render 'shared/nav' %>

<div class="main-div">
<h1>Список пользователей</h1>
<table>
<thead>
<tr>
<th>Имя</th>
<th>Email</th>
<th>Действия</th>
<tr>
</thead>
<tbody>
<% @users.each do |user| %>
<tr>
  <td><%= user.name %></td>
  <td><%= user.email %></td>
  <td>
    <%= link_to "Редактировать", edit_user_path(user) %> |
    <%= button_to "Удалить", user_path(user), method: :delete, data: { confirm: "Вы уверены, что хотите удалить пользователя #{user.name}?" } %></td>
</tr>
<% end %>
</tbody>
</table>
</div>
```

config/routes.rb:

```ruby
Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  root "users#index"
  post 'set_theme', to: 'themes#set'
  get '/users/:id', to: 'users#destroy'
  resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :figures, only: [:index, :new, :create, :edit, :update]
  resources :battles, only: [:index, :new, :create, :edit, :update]
  resources :countries, only: [:index, :new, :create, :edit, :update]
  resources :wars
  delete "/logout", to: "sessions#destroy"
  get "/logout_via_get", to: "sessions#destroy" # <- временный костыль
  get "/about", to: "pages#about"
  get "/abouts", to: "pages#abouts"
  get "/data", to: "pages#data"
  post "/data", to: "pages#data"
  get "/courses", to: "pages#courses"
  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
end
```

Контроллер userscontroller:

```ruby
class UsersController < ApplicationController
  before_action :require_login

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to root_path, notice: "Пользователь обновлён"
    else
      render :edit, status: :unprocessable_entity
    end
  end



  def new
    @user = User.new
    @figures = Figure.all
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path, notice: 'Пользователь был успешно удалён.'
  end

  def create
    @user = User.new(user_params)
    @figures = Figure.all # иначе рендер new выдаст ошибку

    if @user.save
      redirect_to root_path, notice: "Пользователь создан"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :email)
  end

  def require_login
    unless current_user
      redirect_to '/sign_in'
    end
  end
end
```

#### замечание

вместо того что бы в каждом action писать:

```ruby
if current_user
else
  redirect_to '/sign_in'
end
```

можно в начале контроллера писать:

```ruby
before_action :require_login
```

а в private:

```ruby
def require_login
  unless current_user
    redirect_to '/sign_in'
  end
end
```
