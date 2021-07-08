# B-FUN-400-RUN-4-1-compressor
A nice application to parallel k-means

A pretty basic way to compress image consists in reducing the number of colors it contains.3 steps are needed to do so:
1. readthe image andextractthe colors of each pixel
2. clusterthese colors, andreplaceeach color of a given cluster by the mean color of this cluster
3. indexthe means of the cluster, andcreatethe compressed image.

## Usage

### Makefile
Command | Description
--- | ---
**make re** | create binary
**make fcleam** | remove binary

### ./imageCompressor -n *N* -l *L* -f *F*
Flag | Description
--- | ---
N | number of colors in the final image
L | convergence limit
F | path to the file containing the colors of the pixels

## Input
The program read the list of pixels from a file passed as argument, according to the following grammar:

>IN       ::= POINT ' ' COLOR ( '\n' POINT ' ' COLOR)*
>
>POINT    ::= '(' int ',' int ')'
>
>COLOR    ::= '(' SHORT ',' SHORT ',' SHORT ')'
>
>SHORT    ::= '0' .. '255'

## Output

The program print the list of clustered colors on the standard output, according to the following grammar:

>OUT      ::=  CLUSTER*
>
>CLUSTER  ::= '--\n' COLOR '\n-\n' (POINT''COLOR'\n')*
>
>POINT    ::= '(' int ',' int ')'
>
>COLOR    ::= '(' SHORT ',' SHORT ',' SHORT ')'
>
>SHORT    ::= '0' .. '255'