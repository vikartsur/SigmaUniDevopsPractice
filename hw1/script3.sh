#!/bin/bash
echo "HW 1 Task 3: Creating new users in interactive mode"

read -p "Enter username " login

sudo useradd -m -s /bin/bash "$login"
sudo passwd $login

echo "user $login was created"