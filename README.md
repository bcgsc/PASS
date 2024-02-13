[![Release](https://img.shields.io/github/release/warrenlr/PASS.svg)](https://github.com/warrenlr/PASS/releases)
[![Downloads](https://img.shields.io/github/downloads/warrenlr/PASS/total?logo=github)](https://github.com/warrenlr/PASS/releases/download/untagged-637f9b09d287997b1fe6/pass_v0-3.tar.gz)
[![Conda](https://img.shields.io/conda/dn/bioconda/pass?label=Conda)](https://anaconda.org/bioconda/PASS)
[![Issues](https://img.shields.io/github/issues/warrenlr/PASS.svg)](https://github.com/warrenlr/PASS/issues)
[![link](https://img.shields.io/badge/PASS-preprint-brightgreen)](https://doi.org/10.48550/arXiv.2208.05598)

![Logo](https://github.com/warrenlr/pass/blob/master/pass-logo.png)

# PASS
## Protein Assembler with Short Sequences (PASS)
## PASS v0.3.1 Rene L. Warren, 2015-present

### Contents
--------
1. [Description](#des)
2. [What's new](#new)
3. [Implementation and requirements](#imp)
4. [Installation](#install)
5. [Documentation](#doc)
6. [Citing PASS](#citing)
7. [Running PASS](#run)
8. [Test data](#test)
9. [Algorithm](#algo)
10. [Input](#input)
11. [Output](#output)
12. [License](#license)
--------


### Description <a name=des></a>
-----------

PASS is a proteomics application for de novo assembly of millions of very short (6 aa) to longer (100 aa) peptide sequences and beyond.
It is derived from the de novo genome assembler [SSAKE](https://github.com/bcgsc/SSAKE), a tractable sequence assembly algorithm for very short nucleic acid sequencing reads. 

TRY IT OUT BY SIMPLY RUNNING:
<pre>
./test/runme.sh
</pre>


### What's new in v0.3.1 ? <a name=new></a>
-----------

Support MS DOS/Windows FASTA-formatted files (see general points under Input Sequences below)


### What's new in v0.3 ?
-----------

Implements targeted de novo assembly. Sequence targets supplied with (-s) are used to recruit peptide sequences for de novo assembly when -i is set.


### What's new in v0.2 ?
-----------

Bug fix (peptide sequences were not input in the reverse order, which resulted in short contigs)


### Implementation and requirements <a name=imp></a>
-----------

PASS is implemented in PERL and runs on any OS where PERL is installed.


### Installation <a name=install></a>
-----------

Download the tar ball, gunzip and extract the files on your system using:
<pre>
gunzip pass_v0-3-1.tar.gz
tar -xvf pass_v0-3-1.tar
</pre>
Change the shebang line of PASS to point to the version of perl installed on your system and you're good to go.


### Documentation <a name=doc></a>
-----------

Refer to the PASS.readme file on how to run PASS.
Also please refer to the preprint [![link](https://img.shields.io/badge/PASS-preprint-brightgreen)](https://doi.org/10.48550/arXiv.2208.05598)
Questions or comments?  We would love to hear from you!


### Citing PASS <a name=citing></a>
-----------

Thank you for your [![Stars](https://img.shields.io/github/stars/warrenlr/PASS.svg)](https://github.com/warrenlr/PASS/stargazers) and for using, developing and promoting this free software!

If you use PASS for you research, please cite:

<pre>
Warren RL, Sutton GG, Jones SJM, Holt RA.  2007.  Assembling millions of short DNA sequences using SSAKE.  Bioinformatics. 23(4):500-501

Warren RL. 2022. PASS: De novo assembler for short peptide sequences. arXiv. https://doi.org/10.48550/arXiv.2208.05598
</pre>


### Running PASS <a name=run></a>
-----------

<pre>
e.g. ../PASS -f AAreadsLEN6-COV30.fa -m 4 -w 1 -o 1 -r 0.51 

Usage: ./PASS [v0.3.1 peptide assembly]
-f  File containing all the peptide reads (required)
-w  Minimum depth of coverage allowed for contigs (e.g. -w 1 = process all reads, required)
    *The assembly will stop when 50+ contigs with coverage < -w have been seen.*
-s  Fasta file containing sequences to use as seeds exclusively (specify only if different from read set, optional)
	-i Independent (de novo) assembly  i.e Targets used to recruit reads for de novo assembly, not guide/seed reference-based assemblies (-i 1 = yes (default), 0 = no, optional)
	-j Target sequence word size to hash (default -j 5)
	-u Apply read space restriction to seeds while -s option in use (-u 1 = yes, default = no, optional)
-m  Minimum number of overlapping amino acids with the seed/contig during overhang consensus build up (default -m 10)
-o  Minimum number of peptide reads needed to call a amino acid during an extension (default -o 2)
-r  Minimum ratio used to accept a overhang consensus amino acid (default -r 0.7)
-t  Trim up to -t amino acid(s) on the contig end when all possibilities have been exhausted for an extension (default -t 0, optional)
-c  Track amino acid coverage and read position for each contig (default -c 0, optional)
-y  Ignore read mapping to consensus (-y 1 = yes, default = no, optional)
-h  Ignore read name/header *will use less RAM if set to -h 1* (-h 1 = yes, default = no, optional)
-b  Basename for your output files (optional)
-z  Minimum contig size to track amino acid coverage and read position (default -z 20, optional)
-q  Break tie when no consensus amino acid at position, pick random amino acid (-q 1 = yes, default = no, optional)
-v  Runs in verbose mode (-v 1 = yes, default = no, optional)
</pre>


### Test data <a name=test></a>
-----------

Go to the test directory and execute the runme.sh bash script

<pre>
cd ./test
./runme.sh
</pre>

Additionally, users may test PASS with experimental data (refer to ALPS study : https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4999880/)
Data : https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4999880/bin/srep31730-s2.zip)
A fair comparison of PASS to the ALPS system requires an additional MSA step (eg. T-Coffee, clustal, MUSCLE) to merge resulting contigs 


### Algorithm <a name=algo></a>
-----------

A. Sequence Overlap

Short peptide sequences of length l in a single multi fasta file -f are read in memory, populating a hash table keyed by unique sequence reads with pairing values representing the number of sequence occurrence in the input read set.  The normalized sequence reads are sorted by decreasing abundance (number of times the sequence is repeated) to reflect coverage and minimize extension of reads containing sequencing errors.  Reads having sequencing errors are more likely to be unique in the entire read set when compared to their error-free counterparts.  Sequence assembly is initiated by generating the longest COOH-most word (k-mer) from the unassembled read u that is shorter than the sequence read length l.  Every possible COOH-terminal most k-mers will be generated from u and used in turn for the search until the word length is smaller than a user-defined minimum, m.  Meanwhile, all perfectly overlapping reads will be collected in an array and further considered for COOH-termini extension once the k-mer search is done.  At the same time, a hash table c will store every amino acid along with a coverage count for every position of the overhang (or stretches of amino acids hanging off the seed sequence u).   

Once the search complete, a consensus sequence is derived from the hash table c, taking the most represented amino acid at each position of the overhang.  To be considered for the consensus, each amino acid has to be covered by user-defined -o (set to 2 by default).  If there's a tie (two amino acids at a specific position have the same coverage count), the prominent amino acid is below a user-defined ratio r, the coverage -o is too low or the end of the overhang is reached, the consensus extension terminates and the consensus overhang joined to the seed sequence/contig.  All reads overlapping are searched against the newly formed sequence and, if found, are removed from the hash table and prefix tree.  If they are not part of the consensus, they will be used to seed/extend other contigs, if applicable.  If no overlapping reads match the newly formed contig, the extension is terminated from that end and PASS resumes with a new seed.  That prevents infinite looping through low-complexity amino acid sequences.  In the former case, the extension resumes using the new [l-m] space to search for joining k-mers. 

The process of progressively cycling through longer to shorter COOH-most k-mer is repeated after every sequence extension until nothing else can be done on that end.  Since only left-most searches are possible with a prefix tree, when all possibilities have been exhausted for the COOH-terminal extension, the complementary strand of the contiguous sequence generated is used to extend the contig on the NH2-end.  The prefix tree is used to limit the search space by segregating sequence reads and their reverse counterparts (if applicable) by their first 5 amino acid at the NH2-termini.  

There are three ways to control the stringency in PASS:
1. Disallow read/contig extension if the coverage is too low (-o).  Higher -o values lead to shorter contigs, but minimizes sequence misassemblies.
2. Adjust the minimum overlap -m allowed between the seed/contig and short sequence reads.  Higher m values lead to more accurate contigs at the cost of decreased contiguity.  
3. Set the minimum amino acid ratio -r to higher values


B. Using a seed sequence file

If the -s option is set and points to a valid fasta file, the protein sequences comprised in that file will populate the hash table and be used exclusively as seeds to nucleate contig extensions (they will not be utilized to build the prefix tree).  In that scheme, every unique seed will be used in turn to nucleate an extension, using short reads found in the tree (specified in -f).  This feature might be useful if you already have characterized sequences & want to increase their length using short reads.  That said, since the short reads are not used as seeds when -s is set, they will not cluster to one another WITHOUT a seed sequence file.  Also, to speed up the assembly, no embedded reads (i.e. those aligning to the seed in their entirety) are considered.  Only reads that contribute to extending a seed sequence are noted.

When -s is set, the .contigs file lists all extended seeds, even if it's by a single amino acid.  The .singlets will ONLY list seeds that could not be extended.  Unassembled microreads will NOT be outputted. 

Support for sequence target-independent de novo assemblies:

The -i option instructs PASS to use target sequences for the sole purpose of recruiting sequence reads.  If set (-i 1) the target sequences will not seed de novo assemblies and this task will be achieved by recruited reads in a target-independent fashion instead. This has the advantage of allowing the user to provide, as a target, a large reference sequence (-s) without a priori knowledge of variant amino acids.

PASS doesn't not constrain the k-mer length derived from a target sequence for interrogating candidate reads.  User-defined target word length values are now passed to the algorithm using the -j option.  Using larger -j values should help speed up the search when using long sequence reads, since it will restrict the sequence space accordingly.  Note: whereas specificity, speed and RAM usage may increase with -j, it may yield more sparse/fragmented assemblies.  Proper experimentation with various -j values are warranted.

*Refer to the "Test data" section below for a concrete example


### Input <a name=input></a>
-----------

amino acid sequences can be in lower caps as well
<pre>
>cnt1
TEYKLV
>cnt2
LVVVGA
>cnt3
AGGVGK
>cnt4
AGGVGK
>cnt5
GVGKSA
>cnt6
VGKSAL
>cnt7
KSALTI
>cnt8
ALTIQL
>cnt9
LTIQLI
...
</pre>

General points:
1. To be considered, sequences have to be longer than 6 amino acids or -m (but can be of different lengths).  If they are shorter, the program will simply omit them from the assembly and will be placed in the .shorts file 
2. Short sequences that have not been extended are placed in the .singlets file
3. As before, the length of individual sequence is used to determine the size of the right-most subsequence to look for initially
4. Reads containing ambiguous amino acids "X" and characters other than ARNDCQEGHILKMFPSTWYV will be ignored entirely
5. Spaces in fasta file are NOT permitted and will either not be considered or result in execution failure
6. Ensure that your input FASTA is devoid of MS DOS/Windows new line characters (only unix newline characters are accepted). PASS will ignore peptide sequences that are not formatted properly. This unix command may be used for the conversion: tr -d '\r' < test.fasta > testconverted.fasta


### Output <a name=output></a>
-----------

Output file | Description
---|---
.contigs   | fasta file; All sequence contigs
.log       | text file; Logs execution time / errors 
.short     | text file; Lists sequence reads shorter than a set, acceptable, minimum
.singlets  | fasta file; All unassembled sequence reads

Output file (-c 1*) | Description
---|---
.readposition             | this is a text file listing all whole (fully embedded) reads, start and end coordinate onto the contig (in this order).  For reads aligning on the minus strand, end coordinate is < start coordinate
.coverage.csv             | this is a comma-separated values file showing the amino acid coverage at every position for any given contig   >  -z

*WARNING: ASSOCIATED FILES CAN BECOME VERY LARGE!


#### Understanding the .contigs fasta header
-----------

e.g.
<pre>
>contig27|size52|read193|cov92.79
</pre>

contig id# = 27
size (G) = 52 aa 
number of reads (N) = 193
cov [coverage] (C) = 92.79

the coverage (C) is calculated using the total number (T) of consensus amino acid [sum(L)] provided by the assembled sequences divided by the contig size:

C = T / G


#### Understanding the .coverage.csv file
-----------

e.g.
<pre>
>contig1|size60000|read74001|cov37.00
12,12,13,13,13,14,14,15,16,16,20,21,22,23,25,26,27,28,27 ...
</pre>
Each number represents the number of reads covering that amino acid at that position.


#### Understanding the .readposition file
-----------

e.g.
<pre>
>contig1|size60000|read74001|cov37.00
READ_85952,3,32
READ_92647,6,35
READ_72602,8,37
READ_29659,9,38
READ_74582,11,40
READ_97793,11,40
READ_85742,11,40
READ_95375,12,41
READ_9721,15,44
READ_49141,16,45
READ_43328,18,1
READ_94449,18,1
</pre>
In this order: read name [template th -p 1 :: name followed with 1 or 2, corresponds to the order in the sequence input (1:2)], start coordinate, end coordinate.  end < start indicates read is on minus strand


#### PASS does not
-----------

1. Take into consideration quality scores.  It is up to the user to process the sequence data before assembly.
2. Consider sequence read having any character other than A,R,N,D,C,Q,E,G,H,I,L,K,M,F,P,S,T,W,Y,V and will skip these reads entirely while reading the fasta file. 


### License <a name=license></a>
-----------

PASS Copyright (c) 2015-present Rene Warren.  All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 3
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

