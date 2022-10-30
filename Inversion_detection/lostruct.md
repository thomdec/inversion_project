# Local PCA analysis using lostruct

[lostruct](https://github.com/petrelharp/local_pca)

## Creation of the bcf file (which are the recommended input for lostruct):

Samples from StHelena, North Africa and Europe were removed to prevent population structure biases

The command:

```
bcftools view -S ^<samples_to_remove.txt> -O b <vcf_input.vcf> -o <output.bcf>

# <samples_to_remove.txt> is a text file with a list of the samples to remove from the vcf
```

Since there is a vcf for each contig:

```
contigs=$(cat Dchry2.2_contigs.txt)
for contig in $contigs
do
bcftools view -S ^samples_to_remove.txt -O b $contig.repeat_masked_variant.vcf.gz -o $contig.swe.bcf.gz
done
```

Or

```
while read contigs
do
bcftools view -S ^samples_to_remove.txt -O b $contig.repeat_masked_variant.vcf.gz -o $contig.swe.bcf.gz
done < Dchry2.2_contigs.txt
```

The files need to be indexed

```
contigs=$(cat Dchry2.2_contigs.txt)
for contig in $contigs
do
bcftools index $contig.swe.bcf.gz
done < Dchry2.2_contigs.txt
```

## Running lostruct

```
Rscript lostruct_1k_5mds.R $indexed_bcf_input $output
```

Visualise the results

```
XXXXXXXXX
```
