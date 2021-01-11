# Quantitative Affinities Between Words

These spreadsheets detail how quantitative associative affinities between words were calculated. In general, the first term (string *S*) was entered as a regular expression into the `50words.sh` script (see the `scripts` directory), which produces a spreadsheet containing all of the words occurring within 50 words before or after the searched term (list variable *F*, where *Fn* denotes the nth entry in list *F*) sorted according to the percentage of all occurrences of each *Fn* compared to its total number of occurrences in the whole text (e.g. *F1* would be occur the most disproportionately, with say 100% of its appearances taking place within 50 words of *S*, *F2* would occur next disproportionately, with say 99%, etc.) The spreadsheet also lists the count of occurrences of each *Fn*, their sum *Ts* comprising the total number of words coming in proximity to *S*. Based on the second term *M* to be compared with *S*, all *Fn* that contain *M* are selected, e.g. if *M* = "[Ss]chön," then *Fx* = "Schönheit," *Fy* = "schön," *Fz* = "schöner," etc., are included. The total number of these entries as they appear in list *F* make the sum *Tf*, while their total number of appearances in the whole text are *Tm* as fetched from [this spreadsheet](https://goo.gl/Z8sw4t). The total percentage of variations of *M* as a proportion of the overall text becomes *Pm = ( Tm / 145,243 ) x 100%* (where 145,243 is the total number of words in *Tod des Vergil*) and the percentage of variations of *M* as a proportion of the words appearing in the vicinity of S becomes *Ps = ( Tf / Ts ) x 100%*. Measurements of how more frequently term *M* occurs near *S* comes through comparing *Ps* to *Pm*. For instance, if *Ps* = 1% and *Pm* = 0.5%, then *M* occurs twice or 200% more often near *S* than in the book at large.

## Formatting

The original Microsoft Excel versions of these files are located in the `Old Files` folder. The other folders correspond to an original file (e.g. `Zwischenreich` to `Zwischenreich.xlsx`), and contain within them each sheet of the original corresponding spreadsheet in CSV form (which GitHub can directly render without the user downloading the file).

The `Overall Word Counts in H. Broch _Tod des Vergil_.csv` file contains word counts of every single word in *Tod des Vergil*, while each of the other folders detail associations of a certain pattern vis-a-vis various other patterns. For instance, the folder `Plotia` contains the following files:

- `Report.csv`, a summary of the results of contained files.
- `Plotia.csv`, a list of all the words occurring within 50 words of "Plotia" in the whole text.
- `schön in Plotia.csv`, a list of all instances of the pattern "schön" appearing within 50 words of "Plotia".
- `All schön in Whole Text.csv`, a list of all instances of the pattern "schön" in the whole text.