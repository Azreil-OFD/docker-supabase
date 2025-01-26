# Используем базовый образ
FROM alpine:latest

# Устанавливаем необходимые пакеты и Tuna
RUN apk add --no-cache curl bash socat && \
    curl -sSLf https://get.tuna.am | sh && \
    tuna config save-token tt_ubx4yk96ygl7n8lt0uh2npkk703aow1x

# Устанавливаем рабочую директорию
WORKDIR /tuna/

# Копируем скрипт и конфигурацию
COPY start.sh /tuna/
COPY .tuna.yml /tuna/

# Даем разрешение на выполнение скрипта
RUN chmod +x /tuna/start.sh

# Команда по умолчанию при запуске контейнера
CMD ["bash", "-c", "/tuna/start.sh"]
