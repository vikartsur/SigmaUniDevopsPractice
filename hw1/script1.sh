#!/bin/bash
echo "HW 1 Task 1: Script timer"
read -p "How can I call you? " username
echo "Good day $username!"
while true; do
    echo "Enter the integer please: "
    read inputvalue
    if [[ $inputvalue =~ ^[0-9]+$ ]]; then
        while [ $inputvalue != 0 ]; do
            echo "$inputvalue"
            inputvalue=$((inputvalue - 1))
            sleep 1
        done
    else
        echo "Enter the number. Chao bambino!"
        break
    fi
done
read -p "Done!"