#!/bin/bash
# Usage: 50words.sh [Pattern] [Word Count File] [file0] {file1}...

# Provides list of words occurring within 50 words of [Search Pattern]
# in file(s)

# The following script takes a directory containing plaintext files
# (e.g. each a page of Der Tod des Vergil) and outputs a report on a
# given pattern, such as “Zwischenreich.” It also produces a
# spreadsheet that arranges the most common words that appear within
# 50 words of the given pattern according the proportion of those
# instances that versus their overall appearance in Tod des Vergil.
# For instance, if “Nacht” appears 50 times in the novel overall,
# and 21 (42%) of those instances are within 50 words of
# “Zwischenreich,” the pattern “nacht” will appear as follows in the
# spreadsheet (TSV format):
#
# 0.42	21	nacht
#
# Overall word counts are referenced from a TSV-format spreadsheet.
# Words that only appear once in the novel are excluded. To assist
# in pattern matching, capitalization is removed.

# Get current working directory
_pwd=$(pwd)

# Make variable $search equal to the provided search string
search="$1"

# Make variable $owcf equal to the provided overall word count file
owcf="$2"

# Remove search term and overall word count file from list of inputted
# files
shift 2

# Use epoch time (seconds since January 1 1970 00:00:00) as unique
# identifying number.
idn=$(date +%s)

## For each file, create a file where all lines have been collapsed into # one.

# Create directory /tmp/50words.$idn
mkdir -p /tmp/50words.$idn/1page-1line

# Singly select each individual file provided on the command line
for file in "$@"; do

  # Read individual file and remove illegible characters
  sed "s/\x9A//g" < "$file" | \

  # Replace each line break with a “|”
  tr '\n' '|' | \

  # Replace each “-|” with nothing, re-merging line-split words
  sed "s/-|//g" | \

  # Replace the remaining “|” with a space.
  # Write to a file of the same name under
  # /tmp/50words.$idn/1page-1line/
  sed "s/|/ /g" > /tmp/50words.$idn/1page-1line/"$file"

done

## Also create a single file where all files are merged into a single 
## line.

# Read and combine all files together
cat "$@" | \

 # Remove illegible characters
 sed "s/\x9A//g" | \

 # Replace each line break with a “|”
 tr '\n' '|' | \

 # Replace each “-|” with nothing, re-merging line-split words
 sed "s/-|//g" | \

 # Replace the remaining “|” with a space.
 # Write to /tmp/50words.$idn/1page-1line.txt.
 sed "s/|/ /g" > /tmp/50words.$idn/1page-1line.txt

## For each file, create a file where all words each have their
## own line.

# Change directory to /tmp/50words.$idn/1page-1line/
cd /tmp/50words.$idn/1page-1line

# Create directory /tmp/50words.$idn/1word-1line
mkdir /tmp/50words.$idn/1word-1line

# Select each file in /tmp/50words.$idn/1word-1line
for file in *.txt; do

 # Read individual file. Remove illegible characters.
 sed "s/\x9A//g" < "$file" | \

 # Read individual file. Delete all punctuation.
 tr -d '[:punct:]' | tr -d '»«—' | \

 # Remove excess spaces.
 tr -s ' ' | \

 # Replace each space with a line break. Write to a file of the same
 # name under /tmp/50words.$idn/1word-1line/
 tr ' ' '\n' > /tmp/50words.$idn/1word-1line/"$file"

done

## Also create a single file where all files are merged together with
## each word on its own line

 # Read /tmp/50words.$idn/1page-1line.txt. Delete illegible characters.
 sed "s/\x9A//g" < /tmp/50words.$idn/1page-1line.txt | \

 # Delete all punctuation.
 tr -d '[:punct:]' | tr -d '—»«' | \

 # Remove excess spaces.
 tr -s ' ' | \

 # Replace each space with a line break.
 # Write to file /tmp/50words.$idn/1word-1line.txt
 tr ' ' '\n' > /tmp/50words.$idn/1word-1line.txt

## Count instances of pattern and what surrounds it.
## Make a report with accompanying files.

# Read /tmp/50words.$idn/1word-1line.txt. Count how many times
# the pattern appears. Store in variable $count
count=$(grep -a -c "$_pwd"/"$search" /tmp/50words.$idn/1word-1line.txt)

# Go to directory /tmp/50words.$idn/1word-1line
cd /tmp/50words.$idn/1word-1line

# Search files under /tmp/50words.$idn/1word-1line for pattern.
# Save output to string variable $pages
pages=$(grep -a "$search" * | \

 # Strip all but page numbers
 sed "s/\.txt:.*$//g" | \

 # Add formatting
 sed "s/^/time(s) on pg /g" | \

 # Count instances, putting the number of occurrences in front of the
 # page number
 uniq -c)

# Read /tmp/50words.$idn/1word-1line.txt.
# Look for instances of search pattern. Output the matching line
# as well as the preceding 50 and the subsequent 50 lines.
grep -a -h -A50 -B50 "$search" /tmp/50words.$idn/1word-1line.txt | \

 # Exclude delimiter "--"
 grep -a -v -- "--" | \

 # Remove capitalization
 tr '[:upper:]' '[:lower:]' | tr 'Ä' 'ä' | tr 'Ö' 'ö' | tr 'Ü' 'ü' | \

 # Sort resulting lines according to dictionary order
 sort -d | \

 # Count repeat words, and output this count in front of each matched 
 # word
 uniq -c | \

 # Reduce excess whitespace in front of each line
 tr -s ' ' | sed "s/^ //g" | \

 # Calculate these occurrences as percentage of overall occurrences 
 # throughout the text.
 while read line; do

  # get variables: $num = number of occurrences near target pattern,
  # $word = target word, $denom = number of target words in all of
  # text
  num=$(echo "$line" | cut -d ' ' -f 1)
  word=$(echo "$line" | cut -d ' ' -f 2)
  denom=$(grep "	$word$" "$owcf" | cut -d '	' -f 1)

  # Calculate number of target word in this context as percentage of
  # its overall number of appearances in text
  percent=$(calc ${num}/${denom} | tr -s ' ' | sed -e "s/~//g" \
    -e "s/^[ \t]//g")

  # Reformat original entry to TSV (tab separated values)
  # spreadsheet format
  new_line=$(echo "$line" | tr -s ' ' | sed -e "s/^ //g" \
    -e "s/\([[:alnum:]]\) \([[:alnum:]]\)/\1\t\2/g")

  # Output each entry as line in a TSV spreadsheet, with the
  # percentage coming before the count and word name
  echo -e "${percent}	${new_line}"

 # Sort according to percentage, reversed so that high numbers come 
 # first. Write to file /tmp/50words.$idn/word-counts.tsv
 done | sort -gr | \
   grep -v "[0-9]	1	[[:alnum:]]" > /tmp/50words.$idn/word-counts.tsv

# Display report, but also output it to /tmp/50words.$idn.report.txt
cat << EOF | tee /tmp/50words.$idn/report.txt
Pattern $search found $count times

$pages

--------------Additional Files--------------

This report /tmp/50words.$idn/report.txt

Spreadsheet with counts of most common words within 50 words of $search
including percentage of the words compared to their overall number of
appearances throughout the text as well as their raw number
of occurrences:
/tmp/50words.$idn/word-counts.tsv (without capitalization)

Individual files, with content all on one line: 
/tmp/50words.$idn/1page-1line

One big file with all files combined into one line: 
/tmp/50words.$idn/1page-1line.txt

Individual files, with each word on its own line: 
/tmp/50words.$idn/1word-1line

One big file with each word on its own line: 
/tmp/50words.$idn/1word-1line.txt

EOF
