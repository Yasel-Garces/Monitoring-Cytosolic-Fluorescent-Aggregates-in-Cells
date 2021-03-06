# Analysis and visualization of the results obtained through 
# the simulation (see README).

# Load Libraries
library(dplyr)
library(ggplot2)
library(cowplot)
library(reshape2)
############# Functions ###############
statisticBYcolumns<-function(data){
  dataMean<-c()
  dataVar<-c()
  dataSD<-c()
  for(i in 1:dim(data)[2]){
    dataMean[i]<-mean(data[,i])
    dataVar[i]<-var(data[,i])
    dataSD[i]<-sd(data[,i])
  }
  return(list(Mean=dataMean,Var=dataVar,Sd=dataSD))
}
############################################
# Set the work directory
dir<-'/home/yasel/Data Science/Projects/Monitoring-Cytosolic-Fluorescent-Aggregates-in-Cells/Validation_Synthetic Images/Validation Results'
setwd(dir)
# Load the data relative to the Jaccard, Recall, Precision and the
# area and center estimation error.
Area<-read.csv('Area.csv',header = FALSE)
Displacement<-read.csv('Displacement.csv',header = FALSE)
Jaccard<-read.csv('Jaccard.csv',header = FALSE)
Precision<-read.csv('Precision.csv',header = FALSE)
Recall<-read.csv('Recall.csv',header = FALSE)
SNR<-read.csv('SNR.csv',header = FALSE)

# Find the rows different to zero
index<-rowSums(SNR)!=0
# Erase the rows == 0 in all dataset
Area1<-Area[index,]
Displacement1<-Displacement[index,]
Jaccard1<-Jaccard[index,]
Precision1<-Precision[index,]
Recall1<-Recall[index,]
SNR1<-SNR[index,]

############# Tidy data ###############
# Summarise data by mean, variance and standard deviance 
Area<-statisticBYcolumns(Area1)
Displacement<-statisticBYcolumns(Displacement1)
Jaccard<-statisticBYcolumns(Jaccard1)
Precision<-statisticBYcolumns(Precision1)
Recall<-statisticBYcolumns(Recall1)
SNR<-statisticBYcolumns(SNR1)
# Merge data in a data frame
Resume<-data.frame(SNR_Mean=SNR$Mean,SNR_Var=SNR$Var,SNR_SD=SNR$Sd,
           Jaccard_Mean=Jaccard$Mean,Jaccard_Var=Jaccard$Var,Jaccard_SD=Jaccard$Sd,
           Precision_Mean=Precision$Mean,Precision_Var=Precision$Var,Precision_SD=Precision$Sd,
           Recall_Mean=Recall$Mean,Recall_Var=Recall$Var,Recall_SD=Recall$Sd,
           Area_Mean=Area$Mean,Area_Var=Area$Var,Area_SD=Area$Sd,
           Displacement_Mean=Displacement$Mean,Displacement_Var=Displacement$Var,
           Displacement_SD=Displacement$Sd)

############# Data visualization ###############
# Error in the estimation of the area in relationship with the signal noise ratio
# Uncomment to save the figure as a pdf
#pdf("AreaBoxplot.pdf",width = 4.5,height=4.5)
colnames(Area1)<-format(Resume$SNR_Mean, digits=2, nsmall=2)
Area1<-Area1[c(20:1)]
boxplot(Area1,notch = TRUE,outline = FALSE,col = "cyan",xlab="SNR (dB)",las=2,
        ylab=expression("Error of the area "(mu~m^2)),yaxt="n")
axis(side=2,labels=seq(0.01,0.09,0.01),at=seq(0.01,0.09,0.01),las=2)
#dev.off()
#--------------------------------------------------------------------------------
# Error in the center displacement in relationship with the signal noise ratio
# Uncomment to save the figure as a pdf
#pdf("Displacement_Boxplot.pdf",width = 4.5,height=4.5)
colnames(Displacement1)<-format(Resume$SNR_Mean, digits=2, nsmall=2)
Displacement1<-Displacement1[c(20:1)]
boxplot(Displacement1,notch = TRUE,outline = FALSE,col = "purple",
        xlab="SNR (dB)",las=2,
        ylab=expression("Error in the displacement "(mu~m)))
#dev.off()
#--------------------------------------------------------------------------------
# Area mean absolute error in relationship with the signal noise ratio
# Uncomment to save the figure as a pdf
#pdf("Area_Mean.pdf",width = 4.5,height=3.5)
ggplot(data = Resume,aes(x=SNR_Mean,y = Area_Mean))+
  geom_line(size=1.5,colour="cyan")+
  geom_ribbon(aes(ymax = Area_Mean+Area_SD, 
                  ymin= Area_Mean -Area_SD), fill="cyan",
              linetype=0,alpha=0.2)+
  scale_x_continuous("SNR (dB)",breaks = seq(from = -8, to = 4, by = 1))+
  scale_y_continuous(expression("Area mean absolute error "(mu~m^2)),
                     breaks = seq(0,0.08,by = 0.005),labels = seq(0,0.08,by = 0.005))
#dev.off()
#--------------------------------------------------------------------------------
# Displacement mean error in relationship with the signal noise ratio
# Uncomment to save the figure as a pdf
#pdf("Displacement_Mean.pdf",width = 4.5,height=3.5)
ggplot(data = Resume,aes(x=SNR_Mean,y = Displacement_Mean))+
  geom_line(size=1.5,colour="purple")+
  geom_ribbon(aes(ymax = Displacement_Mean+Displacement_SD, 
                  ymin= Displacement_Mean -Displacement_SD), fill="purple",
              linetype=0,alpha=0.2)+
  scale_x_continuous("SNR (dB)",breaks = seq(from = -8, to = 4, by = 1))+
  scale_y_continuous(expression("Displacement mean error "(mu~m)),
                     breaks = seq(0,0.04,by = 0.005),labels = seq(0,0.04,by = 0.005))
#dev.off()
#--------------------------------------------------------------------------------
# Plot the Jaccard, Precision and Recall index in relationship with the SNR
# Uncomment to save the figure as a pdf
Indexs<-select(Resume,c(SNR_Mean,Jaccard_Mean,Precision_Mean,Recall_Mean))
Indexs<-melt(Indexs,id=c("SNR_Mean"))
Indexs$variable<-factor(Indexs$variable,levels = levels(Indexs$variable),
                        labels = c("Jaccard","Precision","Recall"))

#pdf("IndexValues.pdf",width = 4.5,height=3.5)
ggplot(Indexs,aes(x = SNR_Mean,y = value,color=variable))+geom_line(size=1.5)+
  theme(legend.justification=c(1,0), legend.position=c(1,0),
        legend.text = element_text(size = 16),
        legend.title = element_text(size=16))+xlab("SNR (dB)")+
  scale_y_continuous("Index Values",breaks = seq(0.7,1,by = 0.05),
                     labels = seq(0.7,1,by = 0.05))+
  scale_x_continuous(breaks = seq(-8,4,by=1))
#dev.off()
