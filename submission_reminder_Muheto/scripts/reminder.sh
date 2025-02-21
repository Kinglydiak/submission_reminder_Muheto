#!/bin/bash

source "$(dirname "$0")/../config/config.env"
source "$(dirname "$0")/functions.sh"

submissions_file="$(dirname "$0")/../data/submissions.txt"

echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "---------------------------------------------"  

check_submissions "$submissions_file"
