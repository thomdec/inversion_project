#!/usr/bin/env Rscript
library(lostruct)
library(tidyverse)
select=dplyr::select
select=dplyr::filter
select=dplyr::lag

#I thank you Kaichi Huang for their GitHub scripts (https://github.com/hkchi/LoStruct_RAD) without which I would never have been able to write this code. Large chunks are directly copied from their code 

#Input

myargs <- commandArgs(trailingOnly=TRUE) #Input indexed bcf file and the output file name

bcf.file <- myargs[1]
out <- myargs[2]

#Output
output <- paste0(out, "_local_pca.csv")

#parameters
window_size <- 1e3
window_type <- "snp" #either "snp" or "bp"
k_kept <- 5 #number of MDS dimension kept

#local pca
sites <- vcf_positions(bcf.file)
win.fn.snp <- vcf_windower(bcf.file, size=window_size, type=window_type, sites=sites) # creates the windows for the local pca
snp.pca <- eigen_windows(win.fn.snp, k=2) # conduct local pca for each windows
pcdist <- pc_dist(snp.pca) #computes the distance matrix between windows

print("About to prepare and filter the output file")

na.wins <- is.na(snp.pca[,1])
pcdist <- pcdist[!na.wins, !na.wins]
nan.wins <- pcdist[,1]=="NaN"
pcdist <- pcdist[!nan.wins, !nan.wins]
mds <- cmdscale(pcdist, eig=TRUE, k=k_kept) # Multi-dimensional scaling on the distance matrix between windows
mds.coords <- mds$points
colnames(mds.coords) <- paste("MDS coordinate", 1:ncol(mds.coords))
win.regions <- region(win.fn.snp)()
win.regions <- win.regions[!na.wins,][!nan.wins,]
win.regions %>% mutate(mid=(start+end)/2) -> win.regions
for (k in 1:k_kept){
  name = paste("mds", str_pad(k, 2, pad = "0"), sep="")
  win.regions$tmp <- "NA"
  win.regions <- win.regions %>% rename(!!name := tmp)
}
for (i in 1:k_kept){
  j = i + 4
  win.regions[,j] <- mds.coords[,i]
}
win.regions$n <- 1:nrow(win.regions)

print("About to write the output file")

write_csv(x = win.regions, file = output)

