#!/bin/bash

# The following script processes one file and outputs the word
# count of the given text.

# Read file
cat "$1" | \

# Replace line breaks with spaces
tr '\n' ' ' | \

# Delete non-letter special characters: ' " ; . , » ? ! « – - :
tr -d '";.,»?\!«–-' | tr -d "':" | \

# Reduce consecutive spaces into a single space
tr -s ' ' | \

# Output word count
wc -w
