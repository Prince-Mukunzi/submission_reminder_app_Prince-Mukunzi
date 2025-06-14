#!/bin/bash

read -p "Enter name: " user_name

#Getting variable sources
#source create_environment.sh
source ./submission_reminder_$user_name/config/config.env

#variable to store directory path
path=./submission_reminder_$user_name

read -p "Enter Assignment to check: " user_assignment
sed -i '' "s/$ASSIGNMENT/$user_assignment/" ./submission_reminder_$user_name/config/config.env

#run the startup file
./submission_reminder_$user_name/startup.sh
