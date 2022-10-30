# Alignments

[minimap2](https://github.com/lh3/minimap2) was used to make the alignments of the assemblies

## Within species alignments

#### Dchry2.2_Dchry2.Hap

```
minimap2 -x asm10 Dchry2.2.fa Dchry2.haplotigs.fasta | gzip > Dchry2.2_Dchry2.HAP_minimap2.asm10.paf.gz
```

## Alignments with Danaus plexippus:

#### Dchry2.2_DplexMex

```
minimap2 -x asm20 Dchry2.2.fa DplexMex.fa | gzip > Dchry2.2_DplexMex_minimap2.asm20.paf.gz
```

#### Dchry2.2_Dplex4

```

```

## Make the fai files for each fasta (this is required for asynt.R)

Use the samtools command `samtools faidx <fasta_file.fasta>`

Practically:

```
fastas=$(cat fasta_files.txt) #fasta_files.txt is a text file with all the fasta files to index

for fasta in $fastas
do
samtools faidx $fasta
done
```
