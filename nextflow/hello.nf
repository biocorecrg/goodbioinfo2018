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
 * Creates a channel emitting some string values
 */
 
str = Channel.from('hello', 'hola', 'bonjour', 'ciao')

/*
 * Creates a process which declares the channel `str` as an input
 * Each value emitted by the channel triggers the execution 
 * of the process. The process stdout is caputured and send over 
 * the channel `result`  
 */
 
process printHello {
   tag { str }
   
   input:
   val str 

   output: 
   stdout into result
   
   """
   echo $str
   """
}	

/*
 * Subscribes the channel `result` and print the 
 * emitted value each time a value is available
 */ 
 
result.println()
