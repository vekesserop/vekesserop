!/bin/bash

# Проверяем, что передано два аргумента - входная и выходная директории
if [ $# -ne 2 ]; then
    echo "Использование: $0 <входная_директория> <выходная_директория>"
    exit 1
fi

# Сохраняем входную и выходную директории в переменные
input_dir="$1"
output_dir="$2"

# Проверяем существование входной директории
if [ ! -d "$input_dir" ]; then
    echo "Ошибка: Входная директория не существует или не является директорией."
    exit 1
fi

# Создаем выходную директорию, если она не существует
mkdir -p "$output_dir"

# Функция для переименования файлов, чтобы избежать конфликтов
rename_file() {
    local file="$1"
    local output_dir="$2"
    local filename="${file##*/}"
    local base="${filename%.*}"
    local extension="${filename##*.}"
    local count=1
    while [ -e "$output_dir/$base.$count.$extension" ]; do
        ((count++))
    done
    echo "$output_dir/$base.$count.$extension"
}

# Копируем все файлы из входной директории в выходную директорию
find "$input_dir" -type f | while read -r file; do
    new_file="$(rename_file "$file" "$output_dir")"
    cp "$file" "$new_file"
done

echo "Копирование завершено."
