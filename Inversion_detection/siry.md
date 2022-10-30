# Inversion detection using [syri](https://github.com/schneebergerlab/syri)

Most of the code below were originally written by [Claire Mérot](https://github.com/clairemerot)

## Using [ragtag](https://github.com/malonge/RagTag) for homology-based scaffolding

Syri requires alignment with assemblies having the same contigs names. Thus, the contigs must first be "scaffolded" (in this case because some chromosomes are broken up in two contigs and the broken contigs differ between the chrysippus and the plexippus assemblies).

```
ragtag.py scaffold assemblies/Dchry2.2.fa assemblies/DplexMex.fa -o DplexMex
# Dchry2.2.fa is the reference assembly
# DplexMex is the query assembly
```

The ragtag scaffold must be renamed so that the reference and query contigs have the same name (as required by Syri)
I use a script from Eric Normandeau (https://github.com/enormandeau/Scripts/blob/master/rename_scaffolds.py)

```
INPUT_GENOME=DplexMex/ragtag.scaffold.fasta
OUTPUT_GENOME=DplexMex/DplexMex.ragtag.fasta
MIN_SIZE=100000
RENAME=ragtag_conversion.txt #A tab-delimited file containing the names of the contigs and their new name in two separated columns

python rename_scaffolds.py $INPUT_GENOME $RENAME $MIN_SIZE $OUTPUT_GENOME
```

XXXXXXXXX

Rscript to write the RENAME file


## Creation of the alignment

```
minimap2 -ax asm20 --eqx assemblies/Dchry2.2.fa DplexMex/DplexMex.ragtag.fasta | samtools sort -O BAM - > Dchry2.2_DplexMex.asm20.bam
samtools index Dchry2.2_DplexMex.asm20.bam
```

## Running syri

```
syri -c Dchry2.2_DplexMex.asm20.bam -r assemblies/Dchry2.2.fa -q DplexMex/DplexMex.ragtag.fasta -F B --prefix Dchry2.2_DplexMex --no-chrmatch --dir Dchry2.2_DplexMex
```

## Running plotsr to visualise the sv variant call from syri

```
plotsr --sr Dchry2.2_DplexMex/Dchry2.2_DplexMexsyri.out --genomes genomes_DplexMex.txt -o Dchry2.2_DplexMex.png

plotsr --sr Dchry2.2_DplexMex/Dchry2.2_DplexMexsyri.out --genomes genomes_DplexMex.txt --chr contig1.1 -o Dchry2.2_DplexMex_contig1.1.png
```

## Retrieve a list of inversion from the output vcf file.

```
grep "<INV>" Dchry2.2_DplexMexsyri.vcf > inversions.txt
```
