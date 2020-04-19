# Statistical analysis of the 3 conditions: R no Quenching, 
# GR no Quenching y GR Quenching.
#============================================================================
# Load Libraries
library(dplyr)
library(ggplot2)
library(reshape2)
library(gridExtra)
library(cowplot)
library(scales)
#----------------------------------------------------------------------------
# Set work directory
setwd('/home/yasel/Data Science/Projects/Monitoring-Cytosolic-Fluorescent-Aggregates-in-Cells/')
# Load utility functions 
source("R_Codes/Functions.R")
#----------------------------------------------------------------------------
## Load the files for the 3 conditions
# Directory with the data
dir_GR_Quenching<-'Data(csv)/GR quenching/'
dir_R_no_Quenching<-'Data(csv)/R_no_quenching/'
dir_GR_no_Quenching<-'Data(csv)/GR_no_quenching/'
# Load data
GR_Quenching<-readFiles(dir_GR_Quenching)
R_no_Quenching<-readFiles(dir_R_no_Quenching)
GR_no_Quenching<-readFiles(dir_GR_no_Quenching)
# Transform the Time.Img variable to Factor
GR_Quenching$Time.Img<-as.factor(GR_Quenching$Time.Img*5)
R_no_Quenching$Time.Img<-as.factor(R_no_Quenching$Time.Img*5)
GR_no_Quenching$Time.Img<-as.factor(GR_no_Quenching$Time.Img*5)
#----------------------------------------------------------------------------
# Include the condition ("GR Quenching","GR no Quenching","R no Quenching") 
# in the data and merge all conditions.
GR_Quenching<-mutate(GR_Quenching,Condition='GR Quenching')
R_no_Quenching<-mutate(R_no_Quenching,Condition='R no Quenching')
GR_no_Quenching<-mutate(GR_no_Quenching,Condition='GR no Quenching')
# Merge the data
GlobalData<-rbind(GR_Quenching,R_no_Quenching,GR_no_Quenching)
# -------------------------------------------------------------------
# Create a new variable (Venus_over_mCherry) with the ratio between 
# the mean fluorescence intensity in Venus and mCherry
GlobalData1<-mutate(GlobalData,Venus_over_mCherry=Venus_Mean/mCherry_Mean.)
GlobalData1<-select(GlobalData1,Time.Img,Condition,Venus_over_mCherry)
# -------------------------------------------------------------------
# Now, we want to see if exist statistically significant differences 
# between our 3 conditions considering the two by two combinations and
# each adquisition time (frame in the video).
# Compute the number of frames (times that are in the video)
size<-length(levels(GlobalData1$Time.Img))
# Create an empty vector for each of the three possible combinations.
GRQvsGRnQ<-vector(mode="numeric",length = size)
GRQvsRnQ<-vector(mode="numeric",length = size)
RnQvsGRnQ<-vector(mode="numeric",length = size)
# Create an empty vector for each condition to save the 
# p-value of the Shapiro test
GRQ<-vector(mode="numeric",length = size)
GRnQ<-vector(mode="numeric",length = size)
RnQ<-vector(mode="numeric",length = size)

Condition<-rep(c("GR Quenching","GR no Quenching","R no Quenching"),size*3)

# For each time
for (i in 1:size){
  # Exract the time value
  this_time<-levels(GlobalData1$Time.Img)[i]
  # Subset the data to only take into account the current time (this_time)
  this_timeData<-subset(GlobalData1,Time.Img==this_time)
  # Subset by condition
  # GR Quenching
  GR_QuenchingTime<-subset(this_timeData,Condition=="GR Quenching")
  # GR no Quenching
  GR_No_QuenchingTime<-subset(this_timeData,Condition=="GR no Quenching")
  # GR Quenching
  R_No_QuenchingTime<-subset(this_timeData,Condition=="R no Quenching")
  
  # Wilcox test between each pair of condition combination
  GRQvsGRnQ[i]<-wilcox.test(GR_QuenchingTime$Venus_over_mCherry,
                            GR_No_QuenchingTime$Venus_over_mCherry)$p.value
  GRQvsRnQ[i]<-wilcox.test(GR_QuenchingTime$Venus_over_mCherry,
                           R_No_QuenchingTime$Venus_over_mCherry)$p.value
  RnQvsGRnQ[i]<-wilcox.test(GR_No_QuenchingTime$Venus_over_mCherry,
                            R_No_QuenchingTime$Venus_over_mCherry)$p.value
  # Test if the sample follow a normal distribution with a 
  # Shapiro test
  GRQ[i]<-shapiro.test(GR_QuenchingTime$Venus_over_mCherry)$p.value
  GRnQ[i]<-shapiro.test(GR_No_QuenchingTime$Venus_over_mCherry)$p.value
  RnQ[i]<-shapiro.test(R_No_QuenchingTime$Venus_over_mCherry)$p.value
  
}
# -------------------------------------------------------------------
# Putting together the information about the statistical analysis
# Store the p-values of the Mann-Whitney test and the 
# p-values of the Shapiro test
P_Value<-c(GRQvsGRnQ,GRQvsRnQ,RnQvsGRnQ)
Shapiro<-c(GRQ,GRnQ,RnQ)

# Extract the time and replicate the vector 3 times (one for combination)
Time=as.numeric(levels(GlobalData1$Time.Img))
Time=rep(Time,3)
# Replicate the condition combination name
Test<-c(rep("GR Quenching - GR no Quenching",size),
        rep("GR Quenching - R no Quenching",size),
        rep("GR no Quenching - R no Quenching",size))
# Replicate the condition name
Names<-c(rep("GR Quenching",size),
         rep("GR no Quenching",size),
         rep("R no Quenching",size))
# Create two data frames with the the results of the Mann-Whitney test 
# (Wilcoxon) and Shapiro test
Wilcoxon_p_Values<-data.frame(Time,Test,P_Value)
Shapiro_P_Values<-data.frame(Time,Names,Shapiro)
# =============================================================
# Plots #
# P-values of the Mann-Whitney test by time and condition
p_values<-ggplot(Wilcoxon_p_Values,aes(x=Time,log10="y",y = P_Value,group=Test,color=Test))+
  geom_point()+geom_line()+geom_hline(yintercept = 0.05)+
  theme(legend.direction = "vertical",legend.position="bottom")+
  scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x)))+
  scale_x_continuous(limits = c(0, 605),breaks = seq(0, 600, by = 100))+
  xlab("Time, sec")+ylab("P Value")+annotation_logticks(sides = "l")
p_values
# Uncomment if you want to save the graph as a pdf
#ggsave("P_Values_Wilcox_Test.pdf",p_values,scale = 1,width = 94,height=70,
 #      units = "mm")
#--------------------------------------------------------------
Shapiro<-ggplot(Shapiro_P_Values,aes(x=Time,log10="y",y = Shapiro,group=Names,color=Names))+
  geom_point()+geom_line()+geom_hline(yintercept = 0.05)+
  theme(legend.position="bottom")+
  scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x)))+
  scale_x_continuous(limits = c(0, 605),breaks = seq(0, 600, by = 50))+
  xlab("Time, sec")+ylab("P Value")+annotation_logticks(sides = "l")
Shapiro
# Uncomment if you want to save the graph as a pdf
#ggsave("P_Values_Shapiro_Normality_Test.pdf",Shapiro,scale = 1,width = 94,height=70,
 #      units = "mm")

# --------------------------------------------------------------------------
# Now, we want to know what happen with individuals lysosomes by time and 
# Conditions. For this, some variables will be converted to factors.
GlobalData$No..Cell<-as.factor(GlobalData$No..Cell)
GlobalData$Condition<-as.factor(GlobalData$Condition)
GlobalData$Video<-as.factor(GlobalData$Video)
# Plot
# Number of lysosomes by time and Condition.
LysosomesNumber<- summarise(group_by(GlobalData, Time.Img,Condition), 
                             No.Lyso=max(No..Lys.))
lysosomes_time_plot<-ggplot(LysosomesNumber,aes(x=as.numeric(as.character(Time.Img)),y=No.Lyso,
                               color=Condition))

lysosomes_time_plot<-lysosomes_time_plot+geom_point()+geom_line()+xlab('Time')+
  ylab('Number of Lysosomes')+theme(legend.position="bottom")+
  scale_y_continuous(breaks = seq(0, 300, by = 20))+
  scale_x_continuous(limits = c(0, 605),breaks = seq(0, 600, by = 50))
lysosomes_time_plot
# Uncomment if you want to save the graph as a pdf
#ggsave("Number_of_Lysosomes.pdf",lysosomes_time_plot,scale = 1,width = 94,height=70,
 #      units = "mm")
#----------------------------------------------------------------------------
# Resume all the information by cells, this is, for each cell compute 
# the number of lysosomes, the time, mean of the area, mean of the perimeter, 
# mean intensity, mean of the integral intensity.
GlobalData <- summarise(group_by(GlobalData, Time.Img,Condition), mCherry = mean(mCherry_Mean.), 
                        Sd_mCherry=sd(mCherry_Mean.), Venus=mean(Venus_Mean), 
                        Sd_Venus=sd(Venus_Mean), Area=mean(Area.Lys.)*0.21,
                        Sd_Area=sd(Area.Lys.),
                        mCherry_over_Area=mean(mCherry_Mean./Area.Lys.), 
                        Sd_mCherry_over_Area=sd(mCherry_Mean./Area.Lys.),
                        Venus_over_Area=mean(Venus_Mean/Area.Lys.),
                        Sd_Venus_over_Area=sd(Venus_Mean/Area.Lys.),
                        Venus_over_mCherry=mean(Venus_Mean/mCherry_Mean.),
                        Sd_Venus_over_mCherry=sd(Venus_Mean/mCherry_Mean.))

############################################################################
# Study of the mean intensity by channel and conditions "R no Quenching" and "GR 
# no Quenching" conditions.
# Consider only 4 variables ("Time.Img", "mCherry", "Venus", "Condition")
mean_intensity<-select(GlobalData,Time.Img,mCherry,Venus,Condition)
mean_intensity <- melt(mean_intensity,id=c("Time.Img","Condition")) # convert to long format
# Extract the information about the standard deviation
mean_intensity_SD<-select(GlobalData,Time.Img,Sd_mCherry,Sd_Venus,Condition)
mean_intensity_SD<-melt(mean_intensity_SD,id=c("Time.Img","Condition")) # convert to long format
colnames(mean_intensity_SD)<-c("Time.Img","Condition","variable1","sd_value")
# Merge both data frames
mean_intensity <- merge(mean_intensity, mean_intensity_SD)
colnames(mean_intensity)<-c('Time.Img','Condition','Channel','value','variable1','sd_value')
# Plot
# Channel mCherry
update_geom_defaults("point", list(size=0.1))
theme_set(theme_cowplot(font_size = 6))
# Generate the plots with different axis limits
occuplot <- plotfunc(mean_intensity, "GR no Quenching", -150, 1950)+
  theme(plot.margin=unit(c(0.1,0.3,0,-.5), "cm"))+
  scale_x_continuous(limits = c(0, 605),breaks = seq(0, 600, by = 100))
qualplot <- plotfunc(mean_intensity, "R no Quenching", -150, 1950)+
  theme(plot.margin=unit(c(0.1,0.3,0,-.5), "cm"))+
  scale_x_continuous(limits = c(0, 605),breaks = seq(0, 600, by = 100))
p3 <- plotfunc(mean_intensity, "GR Quenching", -150, 1950)+
  theme(plot.margin=unit(c(0.1,0.1,0,0), "cm"))+
  scale_x_continuous(limits = c(0, 605),breaks = seq(0, 600, by = 100))
p3
# Extract the legend
mylegend<-g_legend(occuplot)

# Plot the mean intensity per Lysosome in the two channels and for each condition
plotG<-grid.arrange(arrangeGrob(p3+theme(legend.position="none"),occuplot+
                                  theme(legend.position="none")+ylab(""),
                                qualplot+theme(legend.justification=c(0,1),
                                               legend.position=c(0.2,1))+
                                  ylab(""),nrow = 1))
plotG
# Uncomment if you want to save the graph as a pdf
#ggsave("Mean_Intensity_per_Lysosome.pdf",plotG,scale = 1,width = 94,height=70,
 #      units = "mm")
############################################################################
update_geom_defaults("point", list(size=0.5))
theme_set(theme_cowplot(font_size = 6))
# Study the Venus/mCherry values for all conditions
mean_quotient<-select(GlobalData,Time.Img,Venus_over_mCherry,Condition)
mean_quotient <- melt(mean_quotient,id=c("Time.Img","Condition")) # convert to long format

mean_quotient_SD<-select(GlobalData,Time.Img,Sd_Venus_over_mCherry,Condition)
mean_quotient_SD<-melt(mean_quotient_SD,id=c("Time.Img","Condition")) # convert to long format
colnames(mean_quotient_SD)<-c("Time.Img","Condition","variable1","sd_value")

mean_quotient <- merge(mean_quotient, mean_quotient_SD)
colnames(mean_quotient)<-c('Time.Img','Condition','Channel','value','variable1','sd_value')

# The plot
# Generate the plots with different axis limits
p1<-ggplot(mean_quotient,aes(x=as.numeric(as.character(Time.Img)),y=value,color=Condition))+
  geom_ribbon(aes(ymax = value + sd_value, ymin= value - sd_value,fill = Condition),
              linetype=0,alpha=0.2)+coord_cartesian(ylim=c(0.1, 1))+
  scale_y_continuous(breaks = seq(0, 1, by = 0.1))
p1<-p1+geom_point()+geom_line()+xlab('Time')+ylab('Venus/mCherry')+theme(legend.position="bottom")+
  scale_x_continuous(limits = c(0, 605),breaks = seq(0, 600, by = 50))
p1
# Uncomment if you want to save the graph as a pdf
#ggsave("Venus_over_mCherry.pdf",p1,scale = 1,width = 94,height=70,units = "mm")
