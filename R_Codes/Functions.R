#=======================================================================
# Function to load all files in one directory.
# INPUT: directory
# OUTPUT: dataframe with the the merged information of all the csv files
# Author: Yasel Garces (88yasel@gmail.com)
#-----------------------------------------
readFiles<-function(directory){
        # Get the names of the files in the directory
        files<-list.files(directory,pattern = ".csv")
        # Merge the files in an unique dataframe
        GlobalData<-read.csv(paste(directory,files[1],sep = ""))
        # Include a variable (Video) to  specifiy the name of the video
        GlobalData<-mutate(GlobalData,Video=as.numeric(
                substr(files[1],nchar(files[1])-5,nchar(files[1])-4))
        )
        # If we have more than one file in the directory, include the 
        # other information in GlobalData
        if (length(files)>1){
                # For the second file to the lenght the files
                for (i in 2:length(files)){
                        # Save in temporal the new data
                        temporal<-read.csv(paste(directory,files[i],sep = ""))
                        # Include in temporal the new variable "Video"
                        temporal<-mutate(temporal,Video=as.numeric(
                                substr(files[i],nchar(files[i])-5,nchar(files[i])-4))
                        )
                        # Concat the information with GlobalData
                        GlobalData<-rbind(GlobalData,temporal)
                }       
        }
        # Return Global data
        GlobalData
}
#=======================================================================
# Extract legend in a plot
g_legend<-function(a.gplot){
        tmp <- ggplot_gtable(ggplot_build(a.gplot))
        leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
        legend <- tmp$grobs[[leg]]
        return(legend)}
#=======================================================================
# Plot in two differents graphs
plotfunc <- function(Data, condition , ymin, ymax) {
        # Select a subset of the data in base of the condition
        data=subset(Data, Condition==condition)
        # Create the ggplot object
        p1<-ggplot(data,mapping = aes(x = as.numeric(as.character(Time.Img)),
                                      y = value,group=Channel,colour=Channel))+
                geom_point(size=0.5)+geom_line()+
                geom_ribbon(aes(ymax = value + sd_value, ymin= value - sd_value,fill = Channel),
                            linetype=0,alpha=0.2)+
                xlab('Time')+ylab('Mean Intensity per Lysosome')+
                facet_grid(.~ Condition, scales = "free")+coord_cartesian(ylim=c(ymin, ymax))+
                scale_y_continuous(breaks = seq(ymin, ymax, by = 150))
}
