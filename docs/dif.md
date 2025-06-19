Очень хороший вопрос!
Я тебе сейчас объясню по шагам, **как реализовать простой поиск «как в Википедии» в Rails 8.0.2** — то есть когда ты вводишь слово, а тебе показываются все статьи, где оно встречается в заголовке или тексте.

---

## ✅ 1️⃣ Добавь поле ввода и контроллер поиска

Предположим, у тебя есть модель `Article`:

```ruby
rails generate model Article title:string content:text
rails db:migrate
```

---

## ✅ 2️⃣ Добавь форму поиска в `app/views/layouts/application.html.erb`

(чтобы она была на всех страницах)

Например, прямо в шапке сайта:

```erb
<%= form_with url: search_articles_path, method: :get, local: true do |form| %>
  <%= form.text_field :query, placeholder: "Поиск по статьям..." %>
  <%= form.submit "Найти" %>
<% end %>
```

---

## ✅ 3️⃣ Добавь маршрут для поиска в `config/routes.rb`:

```ruby
resources :articles do
  collection do
    get :search
  end
end
```

---

## ✅ 4️⃣ Реализуй экшен `search` в `ArticlesController`:

```ruby
class ArticlesController < ApplicationController
  def search
    @query = params[:query]

    if @query.present?
      @articles = Article.where("title ILIKE ? OR content ILIKE ?", "%#{@query}%", "%#{@query}%")
    else
      @articles = Article.none
    end
  end
end
```

- `ILIKE` — работает в PostgreSQL для поиска без учёта регистра.
- Если используешь SQLite или MySQL — замени на `LIKE`.

---

## ✅ 5️⃣ Создай шаблон `app/views/articles/search.html.erb`:

```erb
<h1>Результаты поиска: <%= @query %></h1>

<% if @articles.any? %>
  <ul>
    <% @articles.each do |article| %>
      <li>
        <strong><%= link_to article.title, article %></strong><br>
        <%= truncate(article.content, length: 150) %>
      </li>
    <% end %>
  </ul>
<% else %>
  <p>Ничего не найдено.</p>
<% end %>
```

---

## ✅ 6️⃣ Готово!

Теперь:

- Вводишь запрос в поле — `GET /articles/search?query=твое_слово`
- Рельсы ищут по заголовку и тексту.

---

## 🚀 Если хочешь «умный» поиск

Для реального проекта можно подключить:

- **pg_search** — быстрый полнотекстовый поиск в PostgreSQL.
- **Elasticsearch** — если нужна быстрая индексация.

---

Если хочешь, я могу подготовить пример с `pg_search` или помочь настроить авто-подсказки, как в Википедии. Скажи! 🔍✨
