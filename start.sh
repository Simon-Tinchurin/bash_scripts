#!/bin/bash

# asking for password and creating active session for a short period
sudo -v

echo " ______                              _______      __                                     ______                                __   "
echo "|   __ \.----.-----.-----.-----.    |    ___|    |  |_.-----.    .-----.---.-.--.--.    |   __ \.-----.-----.-----.-----.----.|  |_ "
echo "|    __/|   _|  -__|__ --|__ --|    |    ___|    |   _|  _  |    |  _  |  _  |  |  |    |      <|  -__|__ --|  _  |  -__|  __||   _|"
echo "|___|   |__| |_____|_____|_____|    |___|        |____|_____|    |   __|___._|___  |    |___|__||_____|_____|   __|_____|____||____|"
echo "                                                                 |__|        |_____|                        |__|                    "
echo "____________________________________________________________________________________________________________________________________"


# cheсking if postgres is running
check_and_kill_postgres() {

  # searching for port and PID of postgres process 
  netstat_output=$(sudo netstat -tulnep | awk '/postgres/ {print $4, $9}')

  if [ -z "$netstat_output" ]; then
    echo "PostgreSQL server is not running."
  else
    # Extract port number and PID from netstat output
    port=$(echo "$netstat_output" | awk '{print $1}' | awk -F ':' '{print $NF}')
    pid=$(echo "$netstat_output" | awk '{print $2}' | awk -F '/' '{print $1}')

    echo "PostgreSQL is running on port $port, PID $pid."
    sudo kill "$pid"
    echo "Process with PID $pid killed."

    # Complete the PostgreSQL process with sudo kill if the user agrees
    # read -p "Do you want to complete the PostgreSQL process with PID $pid? (y/n): " choice
    # if [ "$choice" = "y" ]; then
    #   sudo kill "$pid"
    #   echo "Process with PID $pid killed."
    # else
    #   echo "Cancelled."
    # fi
  fi

}

# cheсking docker containers status
check_containers() {
    
    # Running 'docker ps -a' and process each string output
    docker ps -a | tail -n +2 | while IFS= read -r line; do
        # Extract the fields from the string
        container_id=$(echo "$line" | awk '{print $1}')
        name=$(echo "$line" | awk '{print $NF}')
        status=""

        # Checking if "Exited" and "Up" are in the string
        if echo "$line" | grep -q "Exited"; then
            status="stopped"
        elif echo "$line" | grep -q "Up"; then
            status="running"
        fi

        # Display information line by line
        echo "$name: $status, $container_id"
    done
}


restart_containers() {
    # Create an empty array to store container IDs
    container_ids=()
    # Read the output of the command 'docker ps -a' in container_ids array
    mapfile -t container_ids < <(docker ps -a --format "{{.ID}}")

    # Return an array of container IDs
    # echo "${container_ids[@]}"

    docker restart "${container_ids[@]}"
}

# container_ids_list=$(restart_containers)
# echo "Список ID контейнеров: ${container_ids_list[@]}"

daily_routine() {
    check_and_kill_postgres
    restart_containers
}


main() {
    
    echo "Utility for automating routine tasks"
    echo "++++++++++++++++++++++++++++++++++++"
    echo -e "|[1] Check if Postgres is running  |\n|[2] Get Docker containers status  |\n|[3] Restart all Docker containers |"
    echo -e "|[4] Daily routine                 |\n|[0] Exit, or type 'exit'          |"
    echo "++++++++++++++++++++++++++++++++++++"
    choice=''

    while [ "$choice" != "0" ]; do

        read -p "Select an option: " choice

        if [ "$choice" = "1" ]; then
            echo "Checking postgres..."
            check_and_kill_postgres

        elif [ "$choice" = "2" ]; then
            echo "Getting containsers status..."
            check_containers

        elif [ "$choice" = "3" ]; then
            echo "Restarting all containers..."
            restart_containers
        

        elif [ "$choice" = "4" ]; then
            echo "Starting daily routine process..."
            daily_routine

        elif [ "$choice" = "0" ] || [ "$choice" = "exit" ]; then
            echo "Exiting..."
            exit 0

        else
            echo "Unknown command..."
        fi
    done
}

main

# Reset the active sudo session
sudo -k