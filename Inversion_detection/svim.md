# Inversion detection using svim

## Installing [swim](https://github.com/eldariont/svim-asm)

```
conda create -n svim_env --channel bioconda svim
```

## Create the alignment for svim

```
minimap2 -a -x asm10 assemblies/Dchry2.2.fa assemblies/Dchry2.haplotigs.fasta -o alignements/Dchry2.2_Dchry2.hap_asm10.sam

samtools sort -m4G -o alignements/Dchry2.2_Dchry2.hap_asm10.sorted.bam alignements/Dchry2.2_Dchry2.hap_asm10.sam

samtools index alignements/Dchry2.2_Dchry2.hap_asm10.sorted.bam
```

## Running svim

```
svim-asm haploid --min_sv_size 10000 <output_folder> <alignment> <reference.fasta>
svim-asm haploid --min_sv_size 10000 svim_asm5_10k alignements/Dchry2.2_Dchry2.hap_asm5.sorted.bam assemblies/Dchry2.2.fa
```

## Create a text file containing only the inversions from the variant.vcf output from svim

```
grep svim_asm.INV variants.vcf | cut -f1,2,3,6- > inversions.txt
```
