#!/bin/bash

echo "Enter your name: "
read user_name

directory_name="submission_reminder_${user_name}"

mkdir -p "$directory_name/config"
mkdir -p "$directory_name/scripts"
mkdir -p "$directory_name/data"

touch "$directory_name/config/config.env"
touch "$directory_name/scripts/reminder.sh"
touch "$directory_name/scripts/functions.sh"
touch "$directory_name/startup.sh"
touch "$directory_name/data/submissons.txt"  # Ty

echo "ASSIGNMENT=\"Shell Navigation\"" > "$directory_name/config/config.env"
echo "DAYS_REMAINING=2" >> "$directory_name/config/config.env"

cat <<EOL > "$directory_name/scripts/reminder.sh"
#!/bin/bash

source "\$(dirname "\$0")/../config/config.env"
source "\$(dirname "\$0")/functions.sh"

submissions_file="\$(dirname "\$0")/../data/submissions.txt"

echo "Assignment: \$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING days"
echo "---------------------------------------------"  

check_submissions "\$submissions_file"
EOL

cat <<EOL > "$directory_name/scripts/functions.sh"
#!/bin/bash

function check_submissions {
    local submissions_file=\$1
    echo "Checking submissions in \$submissions_file"

    while IFS=, read -r student assignment status; do
        student=\$(echo "\$student" | xargs)
        assignment=\$(echo "\$assignment" | xargs)
        status=\$(echo "\$status" | xargs)

        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then
            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!!"  # Extra exclamation mark
        fi
    done < <(tail -n +2 "\$submissions_file")
}
EOL

cat <<EOL > "$directory_name/data/submissions.txt"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
EOL

cat <<EOL > "$directory_name/startup.sh"
#!/bin/bash

echo "Starting Submission Reminder App...."  
source "config/config.env"
source "scripts/functions.sh"
bash scripts/reminder.sh
EOL

chmod +x "$directory_name/scripts/reminder.sh"
chmod +x "$directory_name/scripts/functions.sh"
chmod +x "$directory_name/startup.sh"

echo "Environment setup complete! Navigate to $directory_name and run ./startup.sh to start the app"  # M
