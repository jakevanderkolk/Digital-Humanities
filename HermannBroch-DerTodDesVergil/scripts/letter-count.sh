#!/bin/bash

# The following script processes one file and outputs the
# letter count of the given text.

# Read file
cat "$1" | \

# Replace line breaks with spaces
tr '\n' ' ' | \

# Delete non-letter special characters: ' " ; . , » ? ! « – - :
tr -d '";.,»?\!«–-' | tr -d "':" | \

# Delete all spaces
tr -d ' ' | \

# Output character count
wc -m
