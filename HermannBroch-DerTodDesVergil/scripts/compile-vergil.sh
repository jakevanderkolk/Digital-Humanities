#!/bin/bash

# Usage: compile-vergil.sh [output file] [file0] {file1} ...

# Get name of output file
outfile="$1"

# Remove output file from list of input files
shift 1

# Read input files and merge them into a single stream.
# Make sure that you list them in the correct order!
cat "$@" | \

# Remove illegible characters
sed "s/\x9A//g" | \

# Remove line breaks with a “|”. 
tr '\n' '|' | \

# Merge subsequent words separated by “-|”, otherwise replace “|” with a space.
# Write completed to $outfile.

sed -e "s/-|//g" -e "s/|/ /g" > "$outfile"
