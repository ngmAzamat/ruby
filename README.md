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
rails _7.1.5.1_ new my_app --skip-bundle
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

### Как удолить git из my app?
