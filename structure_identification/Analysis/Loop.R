#!/usr/bin/env Rscript
#written by Lingbin

library(ggplot2)

dir="/net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/structure_identification/Loop/HiCExplorer"
samplelist=list.files(dir,pattern="00M$")

dat=data.frame()
for (i in 1:length(samplelist)){
sample=samplelist[i]
data=read.table(paste(dir,sample,paste(sample,"max2000000_window10_peak6_pvaluepre0.05_pvalue0.05.bedgraph",sep="_"),sep="/"),header=F)
datsub=as.data.frame(table(data[,1]))
colnames(datsub)=c("Chr","Count")
datsub$Sample=rep(sample,nrow(datsub))
dat=rbind(dat,datsub)
}
write.csv(dat,"Loop.csv",row.names=F)

dat = dat %>% mutate( Sample = factor(Sample,levels = c("OmniC_2M","MicroC_2M","OmniC_100M","MicroC_100M","OmniC_200M","MicroC_200M","OmniC_400M","MicroC_400M","OmniC_800M","MicroC_800M")))

pdf("Loop.pdf",width=20,height=10)
ggplot(dat,aes(x=Sample,y=Count))+
stat_summary(fun=mean,geom = "bar",width=0.7,fill="#FF9999")+
stat_summary(fun.data=mean_se,geom="errorbar",width=0.2)+
geom_jitter(position=position_jitter(0.2),shape=21,size=2,alpha=0.9)+
theme_bw()+
theme(legend.position="none",panel.grid=element_blank(),axis.text.x=element_text(size=30,angle=45),axis.text.y=element_text(size=30),axis.title.x=element_text(size=30),axis.title.y=element_text(size=30))+
labs(x="",y="Number of loops")+
scale_y_continuous(expand=c(0,0),limits=c(0,700))
dev.off()
