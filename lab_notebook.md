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
From this I can confirm 