args <- commandArgs(trailingOnly = TRUE)
www         = args[1]
output_file = args[2]
title       = args[3] 

data = read.table(www, head=T, sep=",")
reversed = data[order(nrow(data):1),]

png(output_file, width=800, height=600)
frame()
plot(reversed$line_count, type="l", main=paste(title), ylab="Number of lines", xlab="Commits")
dev.off()