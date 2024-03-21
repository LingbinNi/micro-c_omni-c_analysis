#!/usr/bin/env Rscript
#written by Lingbin

library(ggplot2)
library(dplyr)

dir="/net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/dovetail"
samplelist=list.files(dir,pattern="M$")

dat=data.frame()
for (i in 1:length(samplelist)){
sample=samplelist[i]
data=read.table(paste(dir,sample,"stats.txt",sep="/"),header=F)
datasub=data[c(7,8),]
colnames(datasub)=c("Type","Count")
datasub$Sample=rep(sample,nrow(datasub))
dat=rbind(dat,datasub)
}
write.csv(dat,"cis_trans_analysis.csv",row.names=F)

dat = dat %>% mutate( Sample = factor(Sample,levels = C(OmniC_2M,OmniC_100M,OmniC_200M,OmniC_400M,OmniC_800M, MicroC_2M,MicroC_100M,MicroC_200M,MicroC_400M,MicroC_800M)))
dat = dat %>% mutate( Type = factor(Type,levels = C(cis,trans)))

pdf("cis_trans_analysis.pdf",width=20,height=10)
ggplot(dat,aes(x=Sample,y=Count,fill=Type))+
geom_bar(stat="identity",width=0.5,position='fill')+
scale_fill_manual(values=c('#999999','#E69F00'))+
theme_bw()+
theme(legend.position="none",panel.grid=element_blank(),axis.text.x=element_text(size=30,angle=45),axis.text.y=element_text(size=30),axis.title.x=element_text(size=30),axis.title.y=element_text(size=30))+
labs(x="",y="Ratio")+
scale_y_continuous(expand=c(0,0))
dev.off()
