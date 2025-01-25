# Используем базовый образ
FROM alpine:latest

# Устанавливаем необходимые пакеты
RUN apk add --no-cache curl

# Загружаем и устанавливаем Tuna
RUN curl -sSLf https://get.tuna.am | sh

# Сохраняем токен конфигурации
RUN tuna config save-token tt_ubx4yk96ygl7n8lt0uh2npkk703aow1x

# Команда по умолчанию при запуске контейнера
CMD ["tuna", "http", "http://kong:8000"]
