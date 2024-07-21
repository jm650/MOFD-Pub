

How to use mk-vcard-from-tsv.pl

Goto the spread sheet on Google and export it as a tab separated value file.
Run the script.

ie. ./mk-vcard-from-tsv.pl -f /file/path/to/your-tsv-file -o master.vcf
ie. ./mk-vcard-from-tsv.pl -f /file/path/to/your-tsv-file -i

There are various command line arguments.

-f specify an input file in tsv format downloaded from Google sheets. Required for meaningful output.
-o specify an output file for a master record dump. One file, all records.
-i create individual files for each record.
-u download the sheet from Google sheets. Rrequires URL as an argument.
-h this handy message about how to use command line arguments.

Note that -i and -o cannot be used at the same time
Not supplying a source file will default to the bogon file in repo, if it is present.
