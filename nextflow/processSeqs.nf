#!/usr/bin/env nextflow

/*
 * Copyright (c) 2013-2018, Centre for Genomic Regulation (CRG).
 *
 *   This file is part of 'C4LWG-2018'.
 *
 *   C4LWG-2018 is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   C4LWG-2018 is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with C4LWG-2018.  If not, see <http://www.gnu.org/licenses/>.
 */

/* 
 * HERE YOU HAVE THE COMMMENTS
 * NextFlow example from their website 
 */
 
params.inputFile = "$baseDir/../testdata/test.fa"	// this can be overridden by using --inputFile OTHERFILENAME

sequencesFile = file(params.inputFile)				// the "file method" returns a file system object given a file path string  

if( !sequencesFile.exists() ) exit 1, "Missing genome file: ${genome_file}" // check if the file exists


/*
 * split a fasta file in multiple files
 */
 
process splitSequences {

    input:
    file 'input.fa' from sequencesFile // nextflow creates a link to the original file called "input.fa" in a folder
 
    output:
    file ('seq_*') into records    // send output files to a new channel (in this case is a collection)
 
    // simple command

    """
    awk '/^>/{f="seq_"++d} {print > f}' < input.fa
    """ 
}


/*
 * Simple reverse the sequences
 */
 
process reverse {
    tag "$seq"  					// during the execution prints the indicated variable for follow-up
    publishDir "output"

    input:
    file seq from records.flatten()  // flatten operator emits each item separately as a new channel

    output:
    file "*.rev" into reverted_seqs
 
    """
    cat $seq | awk '{if (\$1~">") {print \$0} else system("echo " \$0 " |rev")}' > $seq".rev"
    """
}

