#!/usr/bin/env Rscript
#written by Lingbin

library(ggplot2)

dir="/net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/dovetail"
samplelist=list.files(dir,pattern="M$")

dat=data.frame()
for (i in 1:length(samplelist)){
sample=samplelist[i]
data=read.table(paste(dir,sample,"stats.txt",sep="/"),header=F)
datasub=data[c(38:43),]
colnames(datasub)=c("Type","Count")
datasub$Sample=rep(sample,nrow(datasub))
dat=rbind(dat,datasub)
}
write.csv(dat,"interaction_distance_count.csv",row.names=F)

dat$Class=sapply(strsplit(dat$Sample,split="_"),"[[",2)
classlist=c("2M","100M","200M","400M","800M")
dat$Type=sapply(strsplit(dat$Type,split="_"),"[[",2)

dat = dat %>% mutate( Type = factor(Type,levels = c("1kb+","2kb+","4kb+","10kb+","20kb+","40kb+")))

for (i in seq(1:length(classlist))){
classname=classlist[i]
dataplot=dat[which(dat$Class==classname),]
p=ggplot(dataplot,aes(x=Type,y=Count/1000000,group=Sample,color=Sample,shape=Sample))+
geom_point(size=4)+
geom_line(position = position_dodge(0.1),cex=1.3)+
theme_bw()+
theme(legend.position="none",panel.grid=element_blank(),axis.text.x=element_text(size=30,angle=45),axis.text.y=element_text(size=30),axis.title.x=element_text(size=30),axis.title.y=element_text(size=30))+
labs(x="",y="Ratio")
ggsave(paste("interaction_distance_count_",classname,".pdf",sep=""),p,width=20,height=10)

}
