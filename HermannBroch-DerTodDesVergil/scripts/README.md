# Scripts for Parsing and Processing Texts
To process texts available as parsable (i.e. capable of being analyzed by word- and character-reading utilities) digital copies, this dissertation used the following scripts written in the [Bash scripting language](https://www.gnu.org/software/bash/). Individual steps are explained through in-text comments delineated by the “#” symbol. One can execute all scripts via a terminal on Unix-like operating systems such as Linux and macOS with up-to-date installations of [Bash](https://www.gnu.org/software/bash/bash.html), [GNU coreutils](https://www.gnu.org/software/coreutils/coreutils.html), [GNU sed](https://www.gnu.org/software/sed/), and [GNU grep](http://www.gnu.org/software/grep/grep.html) or their equivalents typically built into most Unix-like operating systems. All scripts are only capable of parsing plaintext files (files lacking all formatting such as underlining, italics, special font colors or sizes, etc.), which are commonly produced by using notepad and typically use the ".txt" file extension. While this allows the scripts to process all common characters encodings such as UTF-8 and ASCII (and thus all known letters in all known languages past and present), they cannot process non-text elements such as pictures or graphs.

## word-count.sh
The `word-count.sh` script processes one file and outputs the word count of the given text.

## letter-count.sh
The `letter-count.sh` script processes one file and outputs the letter count of the given text.

## sentence-count.sh
The `sentence-count.sh` script processes one file and outputs the sentence count of the given text.

## compile-vergil.sh
The `compile-vergil.sh` script processes one or more files containing text (e.g. individual pages of a text) that may have line-split words and outputs a signal file containing all of the merged files as one single line. This is only useful for subsequent scripts that discern word and letter counts or searching for individual words.

## 50words.sh
The `50words.sh` script takes a directory containing plaintext files (e.g. each a page of *Der Tod des Vergil*) and outputs a report on a given pattern, such as “Zwischenreich.” It also produces a spreadsheet that arranges the most common words that appear within 50 words of the given pattern according the proportion of those instances that versus their overall appearance in Tod des Vergil. For instance, if “Nacht” appears 50 times in the novel overall, and 21 (42%) of those instances are within 50 words of “Zwischenreich,” the pattern “nacht” will appear as follows in the spreadsheet (TSV format):
| 0.42 | 21 | nacht |

Overall word counts are referenced from a TSV-format spreadsheet. Words that only appear once in the novel are excluded. To assist in pattern matching, capitalization is removed.
