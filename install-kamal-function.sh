#!/bin/bash

BASHRC_FILE="$HOME/.bashrc"
FUNCTION_MARKER="# === KAMAL FUNCTION ==="

# Функция для добавления в bashrc
KAMAL_FUNCTION='
# === KAMAL FUNCTION ===
kamal() {
    if [ -f ".env.kamal" ]; then
        # Читаем имя контейнера из .env.kamal
        local container_name=$(grep "^KAMAL_CONTAINER=" .env.kamal | cut -d'"'"'='"'"' -f2 | tr -d '"'"'""'"'"')
        
        # Проверяем, что переменная задана
        if [ -z "$container_name" ]; then
            echo "Ошибка: Переменная KAMAL_CONTAINER не найдена в .env.kamal"
            echo "Добавьте строку: KAMAL_CONTAINER=имя-вашего-контейнера"
            return 1
        fi
        
        docker run --rm -it \
            -v $(pwd):/app \
            -v ~/.ssh:/root/.ssh:ro \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -w /app \
            --network host \
            --env-file .env.kamal \
            "$container_name" "$@"
    else
        echo "Файл .env.kamal не найден"
        return 1
    fi
}
# === END KAMAL FUNCTION ===
'

# Функция установки
install_function() {
    # Проверяем, не установлена ли уже функция
    if grep -q "$FUNCTION_MARKER" "$BASHRC_FILE"; then
        echo "Функция kamal уже установлена в $BASHRC_FILE"
        read -p "Хотите обновить её? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Удаляем старую версию
            sed -i "/$FUNCTION_MARKER/,/# === END KAMAL FUNCTION ===/d" "$BASHRC_FILE"
        else
            echo "Установка отменена"
            exit 0
        fi
    fi

    # Добавляем функцию в bashrc
    echo "$KAMAL_FUNCTION" >> "$BASHRC_FILE"

    echo "✅ Функция kamal успешно добавлена в $BASHRC_FILE"
    echo "💡 Выполните: source ~/.bashrc  или перезапустите терминал"
}

# Функция удаления
uninstall_function() {
    if grep -q "$FUNCTION_MARKER" "$BASHRC_FILE"; then
        echo "🗑️  Удаляем функцию kamal из $BASHRC_FILE..."
        sed -i "/$FUNCTION_MARKER/,/# === END KAMAL FUNCTION ===/d" "$BASHRC_FILE"
        echo "✅ Функция kamal успешно удалена!"
        echo "💡 Выполните: source ~/.bashrc или перезапустите терминал"
    else
        echo "❌ Функция kamal не найдена в $BASHRC_FILE"
    fi
}

# Показать справку
show_help() {
    echo "Установщик функции kamal"
    echo ""
    echo "Использование:"
    echo "  $0              - Установить функцию"
    echo "  $0 install      - Установить функцию"
    echo "  $0 uninstall    - Удалить функцию"
    echo "  $0 --help       - Показать справку"
}

# Парсинг аргументов
case "${1:-install}" in
    "install")
        install_function
        ;;
    "uninstall")
        uninstall_function
        ;;
    "--help"|"-h"|"help")
        show_help
        ;;
    *)
        echo "❌ Неизвестная команда: $1"
        echo ""
        show_help
        exit 1
        ;;
esac