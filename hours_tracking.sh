#!/bin/bash


# path to your working directory
work_dir='/home/sam/Main_vault/work'
# file name format - "%B.%Y".md
this_month_file=$(date +"%B.%Y".md)
# date format for writing in file
date_format=$(date +"%d.%m.%Y")


echo "Welcome to the counting hours script"

main () {
    echo ""
    echo -e "[1] Write hours for today\n[2] Count total for this month\n[3] Read file for this month\n[0] Exit\n"
    
    while true; do
        read -p "Waiting for your choice: " choice
        if [ "$choice" = "1" ]; then
            read -p "Enter hours for today: " hours
            echo "$date_format - $hours" >> "$work_dir/$this_month_file"

        elif [ "$choice" = "2" ]; then
            total_hours=0
            while IFS= read -r line; do
                IFS=" - " read -r date hours <<< "$line"
                total_hours=$((total_hours + hours))
            done < "$work_dir/$this_month_file"
            echo "Total hours for this month - $total_hours"

        elif [ "$choice" = "3" ]; then
            echo "Reading..."
        elif [ "$choice" = "0" ]; then
            exit 0
        else
            echo "Unknown command"
        fi
    done
}

main