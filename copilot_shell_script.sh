#!/bin/bash

#Prompt the user for name and assignment to check
read -p "Enter name: " user_name



#Declared variables
path="./submission_reminder_${user_name}"
found=false
possible_assignments=("Shell Navigation" "Git" "Shell Basics")

#checks if entered user name is not null and is an actual directory
if [[ -n $user_name && -d $path ]]; then
    #Getting Environment config variables
    source ./submission_reminder_${user_name}/config/config.env
    read -p "Enter Assignment to check: " user_assignment
    #check if entered assignment is in assignments
    for assignment in "${possible_assignments[@]}"; do
        if [ "${assignment}" == "${user_assignment}" ]; then
            found=true
            perl -pi -e "s/$ASSIGNMENT/$user_assignment/" $path/config/config.env
            #run the startup file
            $path/startup.sh
            #close the loop if it assignment is found
            break
            exit 0
        fi
    done
    #Error in case assignment is not found
    if [ "$found" == false ]; then
        echo "Error: Assignment not found; Please provide Valid Assignment">&2
        exit 1
    fi
else
echo "Error: Invalid Username">&2
exit 1
fi