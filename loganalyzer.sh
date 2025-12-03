#!/bin/bash

# Default values
FILE=""
KEYWORD="ERROR"
SHOW_LINES=false

# Function to display help
usage() {
    echo "Usage: $0 -f <filename> [-k <keyword>] [-v]"
    echo "  -f : Path to the log file (Required)"
    echo "  -k : Keyword to search for (Default: ERROR)"
    echo "  -v : Verbose mode (Show the actual lines found)"
    exit 1
}

# Parse command line arguments using getopts
while getopts "f:k:v" opt; do
    case ${opt} in
        f) FILE="$OPTARG" ;;
        k) KEYWORD="$OPTARG" ;;
        v) SHOW_LINES=true ;;
        \?) usage ;;
    esac
done

# Validation
if [ -z "$FILE" ]; then
    echo "Error: File argument (-f) is mandatory."
    usage
fi

if [ ! -f "$FILE" ]; then
    echo "Error: File '$FILE' not found."
    exit 1
fi

# Processing
echo "Analyzing '$FILE' for keyword: '$KEYWORD'..."

COUNT=$(grep -c "$KEYWORD" "$FILE")

echo "---------------------------------"
echo "Found $COUNT occurrences."

if [ "$SHOW_LINES" = true ] && [ "$COUNT" -gt 0 ]; then
    echo "Lines containing '$KEYWORD'"
    grep -n "$KEYWORD" "$FILE" # -n prints line numbers
fi
echo "---------------------------------"
