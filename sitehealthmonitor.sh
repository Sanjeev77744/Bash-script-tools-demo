#!/bin/bash

#Colors for Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

#Variables
WEBSITES=(
    "https://www.google.com"
    "https://www.github.com"
    "https://www.nonexistentwebsiteexample.com"
    "https://httpstat.us/404"
    "https://httpstat.us/500"
)

echo "Starting Website Health Check...."
printf "%-40s %-10s %-10s\n" "URL" "STATUS" "CODE"
echo "--------------------------------------------------------------"

for site in "${WEBSITES[@]}"; do
    # curl flags: 
    # -o /dev/null: discard the response body
    # -s: silent mode (no progress bar)
    # -w "%{http_code}": write out only the HTTP status code
    http_code=$(curl -o /dev/null -s -w "%{http_code}" "$site")

    if [ "$http_code" -eq 200 ]; then
        printf "%-40s ${GREEN}%-10s${NC} %-10s\n" "$site" "UP" "$http_code"
    elif [ "$http_code" -eq 000 ]; then
        printf "%-40s ${RED}%-10s${NC} %-10s\n" "$site" "UNREACHABLE" "N/A"
    else
        printf "%-40s ${YELLOW}%-10s${NC} %-10s\n" "$site" "ISSUE" "$http_code"
    fi
done
echo "--------------------------------------------------------------"
