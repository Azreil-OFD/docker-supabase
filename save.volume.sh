#!/bin/bash

# Запрашиваем права администратора
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите этот скрипт с правами администратора."
  exit 1
fi

# Функция для установки zip
install_zip() {
  if [[ -n $(command -v apt) ]]; then
    echo "Установка zip на Ubuntu..."
    apt update && apt install -y zip
  elif [[ -n $(command -v pacman) ]]; then
    echo "Установка zip на Arch..."
    pacman -Sy --noconfirm zip
  else
    echo "Утилита zip не найдена и автоматическая установка невозможна. Пожалуйста, установите zip вручную."
    exit 1
  fi
}

# Проверяем наличие утилиты zip
if ! command -v zip &> /dev/null; then
  install_zip
fi

# Проверяем наличие папки и данных в ней
if [ -d "./volumes/db/data" ] && [ "$(ls -A ./volumes/db/data)" ]; then
  # Создаем архив с доступом 777
  (cd ./volumes/db/data && zip -r ../../../data.zip .)
  chmod 777 data.zip
  echo "Архив data.zip успешно создан с доступом 777."
  git reset
  git add data.zip
  git commit -m "Создана резервная копия базы данных"
else
  echo "Папка ./volumes/db/data отсутствует или пуста."
fi
