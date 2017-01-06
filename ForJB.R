rm(list = ls(all.names=TRUE))
unlink(".RData")

ukstats <- "https://www.ons.gov.uk"
bop <- "economy/nationalaccounts/balanceofpayments"
pb <- "datasets/pinkbook/current/pb.csv"
pbcsv <- read.csv(paste(ukstats,"file?uri=",bop,pb,sep="/"),stringsAsFactors=FALSE)

pbns <- grep("Korea", names(pbcsv))
length(pbns)
lapply(pbns,function(x) names(pbcsv[x]))

koreanpb <- pbcsv[grepl("Korea", names(pbcsv))]
exportspb <- koreanpb[grepl("Exports", names(koreanpb))]
names(exportspb)

pb <- data.frame(pbcsv[grepl("Title", names(pbcsv))],
                 exportspb[3])
colnames(pb) <- c("Title", "Exports")

pbExtract <- pb[60:76,]

for (i in 1:(dim(pbExtract)[1])) {
    i1 <- as.numeric(pbExtract$Exports[i+1])
    i0 <- as.numeric(pbExtract$Exports[i])
    print(100.0 * (i1 - i0) / i0)
}

totExports <- "BoP..Current.Account..Goods...Services..Exports..Total"
allContinents <- pbcsv[grep(totExports,names(pbcsv))]
alldf <- data.frame(pbcsv[grepl("Title", names(pbcsv))], allContinents[,1:5])

allalldf <- alldf[60:76,2:6]
colnames(alldf) <- c("Year", "Asia", "Africa", "Oceania", "Europe", "America")
allalldf$Overall <- rowSums(sapply(alldf[60:76,2:6],as.numeric))
allalldf$Year <- alldf[60:76,1]

for (i in 1:(dim(allalldf)[1])) {
    i1 <- as.numeric(allalldf$Overall[i+1])
    i0 <- as.numeric(allalldf$Overall[i])
    print(100.0 * (i1 - i0) / i0)
}
