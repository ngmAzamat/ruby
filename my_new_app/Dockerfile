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
