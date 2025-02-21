#!/bin/bash

# Prompt user for their name
echo -n "Enter your name: "
read user_name

# Create main directory
dir_name="submission_reminder_${user_name}"
mkdir -p "$dir_name"/{config,modules,assets}

# Create and populate config.env
cat <<EOL > "$dir_name/config/config.env"
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOL

# Create and populate reminder.sh
cat <<EOL > "$dir_name/reminder.sh"
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions \$submissions_file
EOL
chmod +x "$dir_name/reminder.sh"

# Create and populate functions.sh
cat <<EOL > "$dir_name/modules/functions.sh"
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=\$1
    echo "Checking submissions in \$submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=\$(echo "\$student" | xargs)
        assignment=\$(echo "\$assignment" | xargs)
        status=\$(echo "\$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then
            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "\$submissions_file") # Skip the header
}
EOL
chmod +x "$dir_name/modules/functions.sh"

# Create and populate submissions.txt
cat <<EOL > "$dir_name/assets/submissions.txt"
student,assignment,submission status
Chinemerem,Shell Navigation,not submitted
Chiagoziem,Git,submitted
Divine,Shell Navigation,not submitted
Anissa,Shell Basics,submitted
John,Shell Scripting,not submitted
Aisha,Git,submitted
Michael,Shell Navigation,not submitted
Sarah,Shell Scripting,submitted
James,Shell Basics,not submitted
Linda,Git,submitted
EOL

# Create and populate startup.sh

cat <<EOL > "$app_dir/startup.sh"
#!/bin/bash

# Navigate to the app directory
cd "\$(dirname "\$0")"

# Run the reminder script
./reminder.sh
EOL

# Make startup.sh executable
chmod +x "$app_dir/startup.sh"

# Completion message
echo "Environment setup complete! Navigate to $dir_name and run ./startup.sh to test the application."

