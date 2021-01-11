#!/bin/bash

# The following script processes one file and outputs the
# sentence count of the given text.

# Read file
cat "$1" | \

# Replace line breaks with spaces
tr '\n' ' ' | \

# Delete non-letter special characters: ' " ; , » « – - :
tr -d '";,»«–-' | tr -d "':" | \

# Reduce consecutive spaces into a single space
tr -s ' ' | \

# Reintroduce line breaks at the end of sentences, i.e. whenever we
# encounter a period, question mark, or exclamation point followed by a # space.
sed -e "s/\. /.\n/g" -e "s/\? /\?\n/g" -e "s/\! /\!\n/g" | \

# Remove any remaining non-letter special characters: . ! ?
tr -d '.?\!' | \

# Output line count, aka sentence count.
wc -l
