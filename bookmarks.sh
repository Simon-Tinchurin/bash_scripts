#!/bin/bash

# TODO: create README 


echo "BOOKMARKS"


read -p "Enter name of .txt file with bookmarks: " filename

create_new_file() {

    read -p "Enter new file name: " new_file_name

    local SCRIPT_DIR="$1"  # Получаем первый параметр

    # Получаем текущую дату в формате DD.MM.YY HH:MM
    creation_date=$(date +"Creation date: %d.%m.%y %H:%M")

    # Создаем строку с датой обновления (пока она пустая)
    update_date="Update date: "

    # Записываем данные в файл 
    printf "%s\n%s\n" "$creation_date" "$update_date" > "$new_file_name.txt"
    echo "File [$new_file_name] was created in script directory."
    ls

}

add_bookmark() {

    read -p "Enter filename with bookmarks: " file
    read -p "Enter the name of the book: " book_name
    read -p "Enter page number: " page

    # Using 'grep' for searching substring in file, '-i' for case-insensitive 
    result=$(grep -in "$book_name" $file.txt)

    if [[ -n "$result" ]]; then
        # if there is book name in file, then return line number
        line_number=$(echo "$result" | awk -F ':' '{print $1}')
        echo "The book $book_name is in line $line_number"
    else
        # Если подстрока не найдена, выводим сообщение
        echo "There is no book in this file"
    fi

    updated=$(date +"%d.%m.%y %H:%M")
    # Writing new bookmark
    echo "$book_name: page - $page, updated: $updated" >> $file.txt
    # Writing updation date
    sed -i '2s/.*/'"Update date: $updated"'/' $file.txt

    echo "Bookmark added"
}

add_bookmark

check_bookmarks_flie() {
    # Getting script directory
    SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

    # choice = ''

    # Using 'find' command for searching 'filename' in script directory
    # '-type f' means that we are only looking for files
    # '-name "$filename"' specifies the name of the file to be found
    # '-print' returns the path to the found file
    bookmarks_file=$(find "$SCRIPT_DIR" -type f -name "$filename.txt" -print)

    # Check if the file was found
    if [ -n "$bookmarks_file" ]; then
        echo "File $filename was found."
    else
        echo "File [$filename] does not exist in this directory."
        echo -e "[1] Create new file\n[0] Exit\n/Or type filename again if misspelled/"
        read -p "Waiting for your choice: " choice
        if [ "$choice" = "1" ]; then
            create_new_file "$SCRIPT_DIR"
        elif [ "$choice" = "0" ]; then
            exit 0
        else
            filename=$choice
            check_bookmarks_flie
        fi
    fi
}

# check_bookmarks_flie

