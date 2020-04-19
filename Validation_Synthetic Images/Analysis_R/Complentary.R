# Load packages
library(dplyr)
library(ggplot2)
library(reshape2)
library(gridExtra)
library(cowplot)

# Load directory
setwd('/home/yasel/Dropbox/VadimLisosomas/Generation_image_Micrsocopy/R Processing')

# Load data
my_data<-read.csv('Data.csv')
# Writte columns names in the data
colnames(my_data)<-c('Noise','SNR','PartialOclussion','A','B','CX','CY','Theta')
# Convert some variables to factor
my_data$Noise<-as.factor(my_data$Noise)
my_data$SNR<-as.factor(my_data$SNR)
my_data$PartialOclussion<-as.factor(my_data$PartialOclussion)

# Convert to microns the parameters of the ellipse.
my_data[,4:7]<-my_data[,4:7]/10

# Boxplot for all variables
# A
my_table<-table(my_data$A<=0.5)

p1<-ggplot(my_data,aes(x=SNR,y=A,color=PartialOclussion))+geom_boxplot(notch=TRUE)
p1+geom_hline(yintercept=0.5)+scale_y_continuous(breaks = seq(0, 7, by = 0.5))+
        scale_colour_discrete(breaks = levels(NoiseAngle$PartialOclussion), 
                              labels = c(expression(0),
                                         expression(pi/4),
                                         expression(pi/2),
                                         expression(3*pi/4),
                                         expression(pi),
                                         expression(5*pi/4)),name = "Partial Occlusion")+
        theme(legend.text.align = 0)

# B
p1<-ggplot(my_data,aes(x=SNR,y=B,color=PartialOclussion))
p1+geom_boxplot(notch=TRUE)
# CX
p1<-ggplot(my_data,aes(x=SNR,y=CX,color=PartialOclussion))
p1+geom_boxplot(notch=TRUE)
# CY
p1<-ggplot(my_data,aes(x=SNR,y=CY,color=PartialOclussion))
p1+geom_boxplot(notch=TRUE)
# Theta
p1<-ggplot(my_data,aes(x=SNR,y=Theta,color=PartialOclussion))+geom_boxplot(notch=FALSE)

# compute lower and upper whiskers
ylim1 = boxplot.stats(my_data$Theta)$stats[c(1, 5)]
p1 + coord_cartesian(ylim = ylim1*1.05)

# Plot the angle error in dependence of the noise
NoiseAngle <- summarise(group_by(my_data,SNR,PartialOclussion), 
                        meanA=mean(A),meanB=mean(B),meanCX=mean(CX),meanCY=mean(CY),
                        meanTheta=mean(Theta),sd_A=sd(A),sd_B=sd(B),sd_CX=sd(CX),
                        sd_CY=sd(CY),sd_Theta=sd(Theta))

pTheta<-ggplot(data = NoiseAngle,aes(x=SNR,y=meanTheta,group=PartialOclussion,color=PartialOclussion))+
geom_point(alpha=0.5,size=3)+geom_line()+ylim(0,12)+
        ylab(expression(paste(E[paste('abs, ',theta)],(paste('degrees',degree)))))+
        scale_colour_discrete(breaks = levels(NoiseAngle$PartialOclussion), 
                              labels = c(expression(0),
                                         expression(pi/4),
                                         expression(pi/2),
                                         expression(3*pi/4),
                                         expression(pi),
                                         expression(5*pi/4)),name = "Partial Occlusion")+
        theme(legend.text.align = 0)

pA<-ggplot(data = NoiseAngle,aes(x=SNR,y=meanA,group=PartialOclussion,color=PartialOclussion))+
geom_point(alpha=0.5,size=3)+geom_line()+theme(legend.position="none")+ylim(0,2.5)+
        ylab(expression(paste(E[paste('abs, ',A)],(paste(mu,m)))))

pB<-ggplot(data = NoiseAngle,aes(x=SNR,y=meanB,group=PartialOclussion,color=PartialOclussion))+
geom_point(alpha=1,size=3)+geom_line()+theme(legend.position="none")+ylim(0,2.5)+
        ylab(expression(paste(E[paste('abs, ',B)],(paste(mu,m)))))

pCX<-ggplot(data = NoiseAngle,aes(x=SNR,y=meanCX,group=PartialOclussion,color=PartialOclussion))+
geom_point(alpha=0.5,size=3)+geom_line()+theme(legend.position="none")+ylim(0,2.5)+
        ylab(expression(paste(E[paste('abs, ',CX)],(paste(mu,m)))))

pCY<-ggplot(data = NoiseAngle,aes(x=SNR,y=meanCY,group=PartialOclussion,color=PartialOclussion))+
geom_point(alpha=0.5,size=3)+geom_line()+theme(legend.position="none")+ylim(0,2.5)+
        ylab(expression(paste(E[paste('abs, ',CY)],(paste(mu,m)))))

lay=rbind(c(1,2),
          c(3,4),
          c(5,5))

plott<-grid.arrange(pA,pB,pCX,pCY,pTheta, layout_matrix = lay)
ggsave("Supplementary1.pdf",plott,scale = 1,width = 6,height=6.5,units = "in")
