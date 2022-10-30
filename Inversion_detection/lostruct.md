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

Visualise the results in R

```
library(here)
library(ggplot2)
library(dplyr)
library(reshape2)

contigs <- read.csv(here("data/Dchry2.2_contigs.txt"), header = FALSE) #file with the name of each contigs

for(i in 1:nrow(contigs)){
  cont <- contigs$V1[i]

  mds.data <- read.csv(here(paste("data/lostruct_1k/", cont, "_local_pca.csv", sep = "")))

  print(ggplot(mds.data, aes(x = mid/1e6, y=mds01)) +
    geom_point(alpha=0.7, size=2) +
    theme_bw() +
    xlab("Position (Mb)") +
    theme(panel.grid = element_blank(),
          legend.position="none",
          strip.text = element_text(size=20)))
  
}
```
