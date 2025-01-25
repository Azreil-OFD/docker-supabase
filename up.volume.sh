#!/bin/bash

# Запрашиваем права администратора
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите этот скрипт с правами администратора."
  exit 1
fi


# Проверяем, передан ли аргумент
if [ "$#" -ne 1 ]; then
  echo "Использование: $0 <путь_к_zip_архиву>"
  exit 1
fi

ZIP_FILE="$1"

# Функция для установки unzip
install_unzip() {
  if [[ -n $(command -v apt) ]]; then
    echo "Установка unzip на Ubuntu..."
    apt update && apt install -y unzip
  elif [[ -n $(command -v pacman) ]]; then
    echo "Установка unzip на Arch..."
    pacman -Sy --noconfirm unzip
  else
    echo "Утилита unzip не найдена и автоматическая установка невозможна. Пожалуйста, установите zip вручную."
    exit 1
  fi
}

# Проверяем наличие утилиты unzip
if ! command -v unzip &> /dev/null; then
  install_unzip
fi


# Проверяем наличие папки и данных в ней
if [ -d "./volumes/db/data" ] && [ "$(ls -A ./volumes/db/data)" ]; then
  # Архивируем существующие файлы в data.old.zip
  (cd ./volumes/db/data && zip -r ../../../data.old.zip .)
  echo "Содержимое папки ./volumes/db/data успешно архивировано в data.old.zip."
  
  # Удаляем старые файлы
  rm -rf ./volumes/db/data/*
fi

# Проверяем наличие zip-архива
if [ -f "$ZIP_FILE" ]; then
  # Распаковываем содержимое zip-архива в папку ./volumes/db/data
  unzip -o "$ZIP_FILE" -d ./volumes/db/data
  echo "Содержимое $ZIP_FILE успешно распаковано в ./volumes/db/data."
else
  echo "Файл $ZIP_FILE не найден."
  exit 1
fi
