

How to use mk-vcard-from-tsv.pl

Goto the spread sheet on Google and export it as a tab separated value file.
Run the script.

ie. ./mk-vcard-from-tsv.pl -f /file/path/to/your-tsv-file -o master.vcf<br>
ie. ./mk-vcard-from-tsv.pl -f /file/path/to/your-tsv-file -i<br>
<br>

There are various command line arguments.<br>
<br>

-f specify an input file in tsv format downloaded from Google sheets. Required for meaningful output.<br>
-o specify an output file for a master record dump. One file, all records.<br>
-i create individual files for each record. File names are First.Last.vcf<br>
-u download the sheet from Google sheets. Rrequires URL as an argument.<br>
-h this handy message about how to use command line arguments.<br>
<br>
Note that -i and -o cannot be used at the same time<br>
Not supplying a source file will default to the bogon file in repo, if it is present.<br>
