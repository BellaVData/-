install.packages ("magrittr")
library (magrittr)
x <- 12 ^ 2
result <- x %>%
sqrt ()  %>%
print (result)  


#как создать матрицу
bellam <- matrix(1:10, ncol = 5, nrow = 2, byrow = TRUE)
# добавляем столбцы со значениями в матрицу
cbind (bellam, c(TRUE, FALSE))
#как добавить строки в матрицу
g7 <- c(70:75)
bellam <- rbind(bellam,g7)
#посмотреть количество строк и столбцов матрице
dim(bellam)


#как создать фактор? категориальную переменную
# создаем обычный вектор с данными 
vector_eyes <- c("карие", "зеленые")
#проверям класс переменной
class(vector_eyes)
#преобразовываем переменную в фактор
vector_eyes <- factor(vector_eyes)

# Если у тебя есть фактор, например `factor_color_vector`, то команда

#levels(factor_color_vector)
```
#выведет все уникальные категории (уровни) этого фактора.

### Пункт 4: как задать или изменить метки уровней фактора
#Можно переназначить уровни (метки) команды `levels()`. Например:

# levels(factor_color_vector) <- c("красный", "синий", "зелёный")
```
# Это заменит внутренние уровни на удобные человеку названия.

### Пункт 5: создать упорядоченный фактор
#Для создания упорядоченного фактора, где уровни идут в конкретном порядке, например, 
#"низкий" < "средний" < "высокий", нужно добавить аргумент `ordered = TRUE` 

# levels_vec <- c("низкий", "средний", "высокий")
#factor_ordered <- factor(c("средний", "низкий", "высокий", "средний"), 
#levels = levels_vec, ordered = TRUE)

# Теперь можно сравнивать уровни:
#factor_ordered[1] > factor_ordered[2]  # TRUE, "средний" больше "низкого"
levels(vector_eyes)
satisfaction_v1 <- c("низкий", "средний", "высокий")
f1 <- factor(satisfaction_v1, ordered = TRUE, levels = c("низкий", "средний", "высокий"))
summary(f1)
levels(f1)
#уровни обозначают насколько часто встречаются элементы в факторе
f1 [1] == f1 [1]
# уровни можно сравнивать
dataset <- mtcars
class (dataset$mpg)
head(dataset$mpg, 10)
min(dataset$mpg)
max(dataset$mpg)
mean(dataset$mpg)
median(dataset$mpg)
#рассчитали минимальное и максимальное значение, среднее и медиану
# датафрейм отличается от матрицы тем что в нем могут быть переменные разного типа
# а в матрице одинаковый тип данных
#  как добавить значение в вектор
satisfaction_v1 <- c(satisfaction_v1, 5)
print(satisfaction_v1)
#как создать датафрейм
v1 <- c(TRUE, FALSE)
v2 <- c("мужчина", "женщина")
v3 <- c(23, 23)
v4 <- as.Date(c("2001-01-01", "2002-02-02"))
inventory <- data.frame(v1, v2, v3, v4)
names(inventory) <- c('логика', 'пол', 'возраст', 'дата')
str(inventory)
print(inventory)
save.image(file = "my_workspace.RData")

