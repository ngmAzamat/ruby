## Урок I:

Вопросы:

Вот перевод с пояснением по каждому вопросу:

---

### ✅ **1. Вопрос:**

**End users of an application need to know how to connect to MySQL. True or false?**
**Конечные пользователи приложения должны знать, как подключаться к MySQL. Верно или нет?**
**Ответ: False (Неверно)**

🔹 **Комментарий:**
Обычные пользователи приложения (например, посетители сайта) не работают напрямую с базой данных. Подключение к MySQL — это задача backend-разработчика или приложения (через код), а не пользователя.

---

### ✅ **2. Вопрос:**

**Which type of database engine is best suited to drawing relationships between objects?**
**Какой тип движка баз данных лучше всего подходит для отображения (связывания) отношений между объектами?**
**Ответ: Graph database (Графовая база данных)**

🔹 **Комментарий:**
Графовые БД (например, Neo4j) строятся на понятиях «узел» и «связь», что идеально подходит для отображения сложных взаимосвязей — например, друзья в соцсети, или связи между людьми, компаниями, событиями.

---

### ✅ **3. Вопрос:**

**Which type of relationship is used to show many users belong to the same country?**
**Какой тип связи используется, чтобы показать, что много пользователей принадлежат к одной стране?**
**Ответ: One-to-many (один-ко-многим)**

🔹 **Комментарий:**
Одна страна → много пользователей. Это классическая «один ко многим» связь: один объект (страна) связан с несколькими объектами (пользователями), но пользователь связан только с одной страной.

---

### ✅ **4. Вопрос:**

**MySQL can run on Windows, MacOS, and Linux. True or false?**
**MySQL может работать на Windows, MacOS и Linux. Верно или нет?**
**Ответ: True (Верно)**

🔹 **Комментарий:**
MySQL кроссплатформенен. Он официально поддерживается на всех этих операционных системах, что делает его удобным для широкого применения.

---

### ✅ **5. Вопрос:**

**Which of the following is NOT a valid tool to connect to MySQL database servers? pgsql.**
**Какой из следующих инструментов НЕ подходит для подключения к серверам MySQL? — pgsql**
**Ответ: pgsql (не подходит)**

🔹 **Комментарий:**
`pgsql` — это клиент для PostgreSQL, не для MySQL. Для MySQL используют `mysql`, `MySQL Workbench`, `DBeaver`, `Sqlectron` и другие.

---

### ✅ **6. Вопрос:**

**Which of the following database engines is NOT supported by Sqlectron? Amazon DynamoDB.**
**Какой из следующих движков баз данных НЕ поддерживается Sqlectron? — Amazon DynamoDB**
**Ответ: Amazon DynamoDB**

🔹 **Комментарий:**
Sqlectron — это GUI-клиент, предназначенный в основном для реляционных СУБД, таких как MySQL, PostgreSQL, MSSQL, SQLite. **DynamoDB** — это нереляционная NoSQL-база от Amazon и не поддерживается Sqlectron'ом.

---

Если хочешь, могу подготовить похожие вопросы для тренировки или краткие карточки по темам (типы связей, типы БД, инструменты).

## Урок II

Отлично! Вот **перевод и подробный комментарий** к вопросам из **урока II**:

---

### ✅ **1. Вопрос:**

**Which of the following is the maximum size of a VARCHAR column in MySQL?**
**Какой максимальный размер у колонки типа `VARCHAR` в MySQL?**
**Ответ: 65,535**

🔹 **Комментарий:**
Формально, максимальная длина `VARCHAR` — **65,535 байт** (не символов!). Но на практике есть ограничения, зависящие от:

- кодировки (например, UTF-8 может использовать до 4 байт на символ),
- других колонок в таблице (всё в сумме должно вмещаться в один строковый блок).

Поэтому фактическая длина строки `VARCHAR` может быть меньше, если таблица содержит другие колонки.

---

### ✅ **2. Вопрос:**

**If you tried inserting a new data row into a MySQL table and omitted a value from a column with the NOT NULL option enabled, which error message would you receive?**
**Если вы попытаетесь вставить строку в таблицу MySQL и не укажете значение для колонки с `NOT NULL`, какое сообщение об ошибке вы получите?**
**Ответ: `Field doesn't have a default value`**

🔹 **Комментарий:**
Если столбец требует `NOT NULL`, и вы не укажете значение **и** не определите `DEFAULT`, то MySQL не сможет вставить `NULL` и выбросит ошибку.

---

### ✅ **3. Вопрос:**

**If the PRIMARY KEY option is set on a MySQL column, two rows can share the same value in that column. True or false?**
**Если на колонку в MySQL установлена опция `PRIMARY KEY`, могут ли две строки иметь одинаковое значение в этой колонке?**
**Ответ: False (Неверно)**

🔹 **Комментарий:**
`PRIMARY KEY` означает уникальность **и** запрет на `NULL`. Значение в этой колонке должно быть уникальным в каждой строке. Нарушение — ошибка.

---

### ✅ **4. Вопрос:**

**If auto-increment is enabled on a MySQL table column, a value doesn't need to be explicitly inserted into that column. True or false?**
**Если на колонке таблицы включен `AUTO_INCREMENT`, нужно ли явно вставлять значение в неё?**
**Ответ: True (Верно)**

🔹 **Комментарий:**
Когда столбец `AUTO_INCREMENT`, он сам генерирует следующее значение (обычно для ID). Значение вставляется автоматически, если вы его не укажете.

---

### ✅ **5. Вопрос:**

**Which options are supported for `GENERATED ALWAYS AS` column definitions in MySQL? (Choose two)**
**Какие опции поддерживаются для определения колонок `GENERATED ALWAYS AS` в MySQL? (Выберите два)**
**Ответ: `STORED`, `VIRTUAL`**

🔹 **Комментарий:**
В MySQL вычисляемые колонки (`GENERATED ALWAYS AS (...)`) могут быть:

- `VIRTUAL` — значение вычисляется **на лету**, не хранится.
- `STORED` — значение сохраняется на диске, как обычное поле.

`COMPUTED`, `ONDEMAND`, `OPTIONAL` — несуществующие или устаревшие термины для MySQL.

---

### ✅ **6. Вопрос:**

**You can specify two digits for a year and the MySQL database engine will determine which century to associate it with. True or false?**
**Вы можете указать год двумя цифрами, и MySQL определит, к какому веку он относится. Верно или нет?**
**Ответ: True (Верно)**

🔹 **Комментарий:**
Да, при использовании типа `YEAR(2)` MySQL интерпретирует `00–69` как `2000–2069`, а `70–99` как `1970–1999`.
**Но**: `YEAR(2)` устарел и больше не поддерживается в новых версиях — сейчас используется `YEAR(4)`.

---

Хочешь, чтобы я сделал из этих уроков карточки для запоминания или сгенерировал тест с перемешанными вариантами ответов?

## 🚀 **Как начать работать с MySQL (быстро и кроссплатформенно)**

### ✅ **Шаг 1: Установи Docker**

- Docker работает на **Windows, MacOS, Linux**
- Это самый простой и универсальный способ развернуть сервер MySQL без лишней возни

📥 [Скачать Docker Desktop](https://www.docker.com/products/docker-desktop/)

---

### ✅ **Шаг 2: Скачай образ MySQL**

```bash
docker pull mysql
```

или конкретную версию (рекомендуется):

```bash
docker pull mysql:8.0.42
```

---

### ✅ **Шаг 3: Запусти контейнер MySQL**

#### 📌 Вариант 1: без пароля (для теста)

```bash
docker run --rm -d -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -p 3306:3306 mysql
```

#### 📌 Вариант 2: с паролем (лучше для учебной среды)

```bash
docker run --rm -d -e MYSQL_ROOT_PASSWORD=12345 -p 40001:3306 mysql
```

но то было в первый тестовый раз а потом надо:

```bash
sudo docker run -d --name my-mysql -e MYSQL_ROOT_PASSWORD=12345 -p 40001:3306 -v mysql-data:/var/lib/mysql mysql
```

- `--rm` — удалить контейнер после остановки
- `-d` — фоновой запуск
- `-e` — задаём переменные окружения
- `-p` — проброс порта

---

### ✅ **Шаг 4: Подключись через GUI (например, Sqlectron)**

📥 [Sqlectron GUI](https://sqlectron.github.io/) и там скачавоем и так как линукс убунту файл sqlectron_1.38.0_amd64.deb

`azamat@ubuntu:~/Downloads$ sudo dpkg -i sqlectron_1.38.0_amd64.deb`
`azamat@ubuntu:~/Downloads$ sqlectron`

далее на кнопку add
🔧 Настройки подключения:

| Поле                      | Значение    |
| ------------------------- | ----------- |
| Name                      | local-mysql |
| Database Type             | MySQL       |
| Server Address            | 127.0.0.1   |
| Port                      | 40001       |
| User                      | root        |
| Password                  | 12345       |
| Initial Database/Keyspace | ничего      |

а потом на кнопки test, save, а потом на connect

а потом в undefined #1:

```sql
-- так мы создаем базу
CREATE DATABASE testdb;
-- применяем базу
USE testdb;

-- создаем таблицу
CREATE TABLE users (
  -- это для того что бы не повторялось что то, тут id с типом int и с номером и уникальном идентификатором строки
  id INT AUTO_INCREMENT PRIMARY KEY,
  -- имя с типом varchar и до 100 символов(обычных varchar 65 535 а char 255)
  name VARCHAR(100),
  -- email с типом varcharи до 100 символов(обычных varchar 65 535 а char 255)
  email VARCHAR(100)
);

-- созданием пользователя в таблице users с параметрами указаннами
INSERT INTO users (name, email)
-- он будет Azamat
VALUES ('Azamat', 'azamat@example.com');
-- хочю увидеть всех пользователей
SELECT * FROM users;

/* почему именно varchar?
он потенициально больше(65 535) но экономит место, например между char(100) и varchar(100) лучше varchar,
если дело не про жёстко фиксированное поле (например MD5-хеш длиной ровно 32 символа) */
```

а потом CTRL + ENTER

---

### ✅ **Шаг 5: Освой базовые SQL-команды**

| Команда          | Назначение                           |
| ---------------- | ------------------------------------ |
| `CREATE TABLE`   | Создать новую таблицу                |
| `DROP TABLE`     | Удалить таблицу и все её данные      |
| `ALTER TABLE`    | Изменить структуру таблицы           |
| `TRUNCATE TABLE` | Быстро очистить все строки в таблице |
| `INSERT INTO`    | Добавить данные                      |
| `SELECT * FROM`  | Получить данные                      |

---

### Пишем код

```sql
-- Это создаёт новую базу данных
CREATE DATABASE testdb;
-- Переключаемся на неё
USE testdb;

/*
Создаём таблицу пользователей.
Каждый пользователь имеет:
- name (строка до 100 символов),
- email (строка до 100 символов)
*/
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100)
);
```

### ✅ **Дополнительно: понимай, что MySQL кроссплатформен**

- Он может работать на **Windows**, **MacOS**, **Linux**
- Клиенты тоже есть разные: терминал, GUI (Sqlectron, DBeaver, HeidiSQL), даже Web-интерфейсы

---

Хочешь — сделаю PDF или шпаргалку из этого, или можем перейти к практике: например, создать таблицу с продуктами и добавить туда данные.

## Развитие Работы

```sql
-- Это создаёт новую базу данных
CREATE DATABASE testdb;
-- Переключаемся на неё
USE testdb;

/*
Создаём таблицу пользователей.
Каждый пользователь имеет:
- name (строка до 100 символов),
- email (строка до 100 символов)
*/
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100)
);
-- DROP - опасная команда безвозратно удаляет Таблицы и Базы Данных: DROP [DATABASE или TABLE] [таблица или база данных]
-- DELETE - удаляет строки такие как Azamat
-- DELETE FROM users WHERE id = 3;
-- INSERT INTO [таблица] (поле, поле) VALUES (значение для поля, значение для поля) - добавить элемент в таблице
-- SELECT * FROM [таблица] WHERE [поле] = [значение] - выделеть элемент в таблице
-- TRUNCATE TABLE [таблица] - удаляет все строки таблицы то есть очищяет ее
```
