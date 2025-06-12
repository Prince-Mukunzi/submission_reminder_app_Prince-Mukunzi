#!/bin/bash

#prompt user for their name
read -p "Please enter your name: " user_name

#create directory structure for the user

if [ -d "submission_reminder_$user_name" ]; then
	echo "A directory under $user_name already exists"
	exit 1
else
	echo "Creating File directory structure..."
	mkdir -p submission_reminder_$user_name/{app,modules,assets,config}
	sleep 1
	echo "Creating File directory structure complete"

#function for inserting config.env file
config_file(){
	cat > submission_reminder_$user_name/config/config.env <<EOF
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2

EOF
}


#function for inserting reminder.sh file
reminder_file(){
        cat > submission_reminder_$user_name/app/reminder.sh <<'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "---------------------------------------------"

check_submissions $submissions_file
EOF

}

#function for inserting functions.sh file
functions_file(){
        cat > submission_reminder_$user_name/modules/functions.sh <<'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
local submissions_file=$1
echo "Checking submissions in $submissions_file"

# Skip the header and iterate through the lines
while IFS=, read -r student assignment status; do
# Remove leading and trailing whitespace
student=$(echo "$student" | xargs)
assignment=$(echo "$assignment" | xargs)
status=$(echo "$status" | xargs)

# Check if assignment matches and status is 'not submitted'
if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
fi
done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF
 
}

#function for inserting submission.txt file
submission_file(){
	cat > submission_reminder_$user_name/assets/submissions.txt <<EOF
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Prince, Shell Navigation, not submitted
Mukunzi, shell Basics, submitted
Optimus, Git, submitted
Prime, Shell Basics, not submitted
John Doe, Git, not submitted
EOF
} 

#function for starting the app
startup_file(){
	cat > submission_reminder_$user_name/startup.sh <<'EOF'
#!/bin/bash
	
cd "$(dirname "$0")"
./app/reminder.sh
EOF
}


#call functions to create and insert files and content respectively
config_file
reminder_file
functions_file
submission_file
startup_file

sleep 1
echo "FILE DIRECTORY STRUCTURE:"
ls submission_reminder_$user_name/*
sleep 1

#change all shell files permissions to executable
echo "Adding Executable permissions to file..."
find submission_reminder_$user_name -type f -name "*.sh" -exec chmod +x {} \;
sleep 2
echo "File permissions set to executable"
fi
