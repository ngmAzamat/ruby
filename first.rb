print "Людовик Беррийский\n"
print ("Людовик Беррийский\n")
age = 18
puts age
puts (age)
one = 1
two = "1"
three = true
four = 0.99
five = nil

words = "\" Священная Римская Империя \""
word = "!"
puts (words.downcase() + word)

someText = "    Много Пробелов    "

puts(someText.strip())
puts(someText.length())

x = 2.3
y = 2.2
num = x ** y
# num = x ^ y
num2 = -14.45
puts ("Результат: " + num.to_s())
puts (num2)
puts (num2.abs())
puts (num2.round())
puts Math.sqrt(144)
puts Math.log(1)


# puts ("Введите Свое Имя: ")
# name = gets.chomp()
# puts ("Ваше Имя: " + name)

print("Введите первое число: ")
x = gets.chomp().to_f()
print("Введите второе число: ")
y = gets.chomp().to_f()
num = x + y
puts("Ответ: " + num.to_s())

num = 4
arr = Array[4,6,8,12,true,"Привет",5.67]
puts(arr)

names = Array["George","Robert","Alexander"]
names[0] = "George IV"
puts(names[-3])
puts(names)


list = Array.new
list[0] = 29
list[7] = 90
puts list
puts list.length()
puts list.reverse()

countries = {
    "RU" => "Russia",
    1 => 1.01,
    :UA => "Ukraine"
}
puts countries[:UA]

# функции

def sayHello(word="Ничего", num=0)
    puts "Привет Мир!"
    puts ("Ваше Слово: " + word + " и ваше число: " + num.to_s)
end

def summa(a,b)
    return a + b, 70
end

sayHello

res = summa(54,6)
puts res[0]

a = 1

if a == 1
    puts "a = 1"
elsif a == 2
    puts "a = 2"
else
    puts "a не равен 1 и 2"
end

def getDayWeek(day)
    nameOfDay = ""
    case day
    when "1"
        nameOfDay = "Понедельник"
    when "2"
        nameOfDay = "Вторник"
    when "3"
        nameOfDay = "Среда"
    when "4"
        nameOfDay = "Четверг"
    when "5"
        nameOfDay = "Пятница"
    when "6"
        nameOfDay = "Суббота"
    when "7"
        nameOfDay = "Воскресенье"
    else
        nameOfDay = "Не возможное Значение"
    end
    return nameOfDay
end

puts getDayWeek("1")

# циклы

i = 0
while i <= 5
    puts i
    i += 1
end

secret = "Blue"
guess = ""

while guess != secret
    puts "Введите Слово: "
    guess = gets.chomp()
end

puts "Вы выйграли!"

x = 1
y = 6
for el in 1..6
    puts el
end

names = ["Robert","Eddard"]
names.each do |name|
    puts name
end


File.open("text.txt","r") do |file|
    puts file.read()
end

file = File.open("text.txt","r") 
puts file.read()
file.close()

File.open("text.txt","w") do |file|
    puts file.write("Священная Римская Империя Германской Нации\n")
end

File.open("text.txt","a") do |file|
    puts file.write("Священная Римская Империя Германской Нации")
end

list = [1,2,3,4,5,6]
begin
    list["dog"]
    num = 10 / 0
rescue TypeError => e
    puts e
rescue ZeroDivisionError
    puts "Деление на 0"
end

puts "Привет"