# Lab Notebook Documentation

## File Download

I am beginning this project by downloading a single fasta file from the Sol Genomics Network. I transfered this file into my `data/fasta` directory via filezilla.

## Seqkit 

Now, I want to use `seqkit` to ensure that I am looking in the right spot for the deletion. I used the following command to ensure that my file contained chromosome 3.

```bash
apptainer exec oras://community.wave.seqera.io/library/seqkit:2.11.0--b6acc663486362a3 seqkit seq -n data/fasta/M82_MAS2.0.fasta.gz | head 
```

The output was:

```bash
INFO:    Using cached SIF image
INFO:    gocryptfs not found, will not be able to use gocryptfs
M82_MAS2.0ch01
M82_MAS2.0ch02
M82_MAS2.0ch03
M82_MAS2.0ch04
M82_MAS2.0ch05
M82_MAS2.0ch06
M82_MAS2.0ch07
M82_MAS2.0ch08
M82_MAS2.0ch09
M82_MAS2.0ch10

```
From this I can confirm that chromosome 3 is contained within this fasta file. I now want to see how long chromosome 3 is, so I used the following command

```bash


```


I am noticing a different from the GORKY paper and JL's dissertation. It appears that JL was useding ITAG 2.4 for GORKY-like-01 and GORKY-like-03 and ITAG 4.0 for GORKY and GORKY-like-02. I also am seeing that although the GORKY region may be around 69 MB on Heinz 1706 (I need to confirm this) the M82 sequence that I am looking at is not even 69MB in length. This is showing me that I should look to JBrowse for each sequence I download in order to make sure that I am capturing the right region for each reference genome.

The four gene I am looking for are 

|Gene Name      |Gene  ID               |
|---------------|-----------------------|
|GORKY          | Solyc03g120570        |
|GORKY-like-01  | Solyc03g120550        |
|GORKY-like-02  | Solyc03g120560        |
|GORKY-like-03  | Solyc03g120590        |


Now I am going to make a table specifying the exact region (including a 1.5kb buffer on each size) that contains GORKY and its homologs.

|Accession          | Genome Assembly Link | Region of Interest |
|---------------|-----------------------|----|
| Heinz 1706 SL2.5 |         |
| Heinz 1706 SL3.0  |         |
| Heinz 1706 SL4.0  | https://www.ncbi.nlm.nih.gov/datasets/genome/GCA_000188115.5/  |
| EA03058           |         |
| M82               | https://www.ncbi.nlm.nih.gov/datasets/genome/GCA_040143505.1/                      |
| OH8245            |                       |
| LA1416            |                       |
| Heinz 1706 SL5.0  |                       |

