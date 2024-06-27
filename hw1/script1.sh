#!/bin/bash
echo "HW 1 Task 1: Script timer"
read -p "How can I call you? " username
echo "Good day $username! Enter the integer please (0-9)"
read inputvalue
while [ "$inputvalue" -gt "0" ]; do
    echo "$inputvalue"
    inputvalue=$((inputvalue - 1))
    sleep 1
done
read -p "Done!"