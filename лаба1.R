file.path <- file.choose()
airfrance_data <- file.path
airfrance_data <- read.csv("C:/Users/88/Desktop/univer/аналитика данных/Лаб1/var7.csv", sep = ";", 
                           stringsAsFactors = FALSE)
airfrance_data$Date <- as.Date(paste0(as.character(airfrance_data$Activity.Period), 
                                      "01"), format = "%Y%m%d")
airfrance_data$Activity.Period <- NULL
colnames(airfrance_data) <- c("Операционная авиакомпания", "Количество пассажиров"
                              , "Дата")
library(lubridate)
passengersoftheyears <- ts(airfrance_data$`Количество пассажиров`, 
         start = c(year(min(airfrance_data$Дата)), month(min(airfrance_data$Дата))),
         frequency = 12)
additive_model <- decompose(passengersoftheyears, type = "additive")
plot(additive_model)
multiplicative_model <- decompose(passengersoftheyears, type = "multiplicative")
plot(multiplicative_model)
rm(decomp_df, month_vals, time_vals, year_vals)
dates <- seq(as.Date("2005-07-01"), as.Date("2016-03-01"), by = "month")
library(xts)
ap_xts <- xts(as.numeric(airfrance_data$`Количество пассажиров`), 
              order.by = airfrance_data$Дата)
colnames(ap_xts) <- "passengers"
autoplot(ap_xts) +
  ggtitle("Число авиапассажиров (2005-2016)", 
          subtitle = "тип объекта xt") +
  ylab("Тыс. пассажиров") +
  xlab("Год")
acf(ap_xts)
pacf(ap_xts)
library(ggplot2)
install.packages("forecast")
library(forecast)
ggAcf(ap_xts, lag.max = 30) +
  ggtitle("Автокорреляционная функция (ACF)") +
  xlab("Лаг") +
  ylab("ACF")
ggPacf(ap_xts, lag.max = 30) +
  ggtitle("Частичная автокорреляционная функция (PACF)") +
  xlab("Лаг") +
  ylab("ACF") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title = element_text(size = 12),
    panel.grid.minor = element_blank()
  )
time_vals <- time(additive_model$x)
year_vals <- floor(time_vals)
month_vals <- round((time_vals - year_vals) * 12) + 1
dates <- as.Date(paste(year_vals, month_vals, "01", sep = "-"), format = "%Y-%m-%d")

decomp_df <- data.frame(
  Date = dates,
  Observed = as.numeric(additive_model$x),
  Trend = as.numeric(additive_model$trend),
  Seasonal = as.numeric(additive_model$seasonal),
  Random = as.numeric(additive_model$random)
)
ggplot(decomp_df, aes(x = Date)) +
  geom_line(aes(y = Observed, color = "Наблюдаемые данные")) +
  geom_line(aes(y = Trend, color = "Тренд")) +
  geom_line(aes(y = Seasonal + Trend, color = "Тренд + Сезонность")) +
  scale_color_manual(
    name = "Компоненты",
    values = c(
      "Наблюдаемые данные" = "gray25",
      "Тренд" = "cornflowerblue",
      "Тренд + Сезонность" = "darkred"
    )
  ) +
  labs(
    title = "Декомпозиция временного ряда AirFrance",
    subtitle = "Аддитивная модель",
    x = "Дата",
    y = "Количество пассажиров",
    color = "Компоненты"
  ) +
  # Тема оформления
  theme(legend.position = "bottom")

library(dplyr)
library(tidyverse)

# Преобразуем данные в "длинный" формат
df_long <- decomp_df %>%
  pivot_longer(cols = c(Observed, Trend, Seasonal, Random), 
               names_to = "component", 
               values_to = "value") %>%
  mutate(component = factor(component,levels = c("Observed", "Trend", "Seasonal", "Random"))
  )

# Построение
ggplot(df_long, aes(x = Date, y = value)) +
  geom_line(aes(color = component), linewidth = 0.7) +
  facet_wrap(~ component, scales = "free_y", ncol = 1) +
  scale_color_manual(values = c(
    "Observed" = "gray25",
    "Trend" = "cornflowerblue",
    "Seasonal" = "darkred",
    "Random" = "green4"
  )) +
  labs(title = "Аддитивная декомпозиция временного ряда", x = "Время", y = "Значение") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    legend.position = "none"
  )

library(dplyr)
library(lubridate)

df_ap <- decomp_df %>%
  mutate(time = 1:nrow(decomp_df),   
         month = factor(month(Date))) 
lm_model <- lm(Observed ~ time + month, data = df_ap)
summary(lm_model)

df_ap$fitted <- fitted(lm_model)

library(ggplot2)

ggplot(df_ap, aes(x = time)) +
  geom_line(aes(y = Observed), color = "navy") +
  geom_line(aes(y = fitted), color = "brown") +
  ggtitle("Регрессия с фиктивными переменными: факт vs модель") +
  ylab("Количество пассажиров") +
  xlab("Время")
acf(residuals(lm_model), main = "Автокорреляция остатков")
qqnorm(residuals(lm_model))
qqline(residuals(lm_model))
df_ap <- df_ap %>% mutate(t = time)

harmonic_model <- lm(Observed ~ t + sin(2 * pi * t / 12) + cos(2 * pi * t / 12), 
                     data = df_ap)
summary(harmonic_model)

df_ap$harmonic_fitted <- fitted(harmonic_model)

ggplot(df_ap, aes(x = time)) +
  geom_line(aes(y = Observed), color = "navy") +
  geom_line(aes(y = harmonic_fitted), color = "red4") +
  ggtitle("Гармоническая регрессия: факт vs модель") +
  ylab("Количество пассажиров") +
  xlab("Время")


