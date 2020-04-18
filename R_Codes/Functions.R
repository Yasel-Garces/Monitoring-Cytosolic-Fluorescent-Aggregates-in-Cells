# Functions
# Function to load all files in one directory.
readFiles<-function(directory){
        files<-list.files(directory,pattern = ".csv")
        # Merge the files of the same test (all in the directory)
        GlobalData<-read.csv(paste(directory,files[1],sep = ""))
        GlobalData<-mutate(GlobalData,Video=as.numeric(
                substr(files[1],nchar(files[1])-6,nchar(files[1])-4))
        )
        if (length(files)>1){
                for (i in 2:length(files)){
                        temporal<-read.csv(paste(directory,files[i],sep = ""))
                        temporal<-mutate(temporal,Video=as.numeric(
                                substr(files[i],nchar(files[i])-6,nchar(files[i])-4))
                        )
                        
                        GlobalData<-rbind(GlobalData,temporal)
                }       
        }
        GlobalData
}
# -----------------------------------------------------------------------
#extract legend
#https://github.com/hadley/ggplot2/wiki/Share-a-legend-between-two-ggplot2-graphs
g_legend<-function(a.gplot){
        tmp <- ggplot_gtable(ggplot_build(a.gplot))
        leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
        legend <- tmp$grobs[[leg]]
        return(legend)}

# -----------------------------------------------------------------------
# Plot in two differents graphs
plotfunc <- function(Data, xxx , ymin, ymax) {
        # Select a subset of the data in base of the condition
        data=subset(Data, Condition==xxx)
        # Create the ggplot object
        p1<-ggplot(data,mapping = aes(x = as.numeric(as.character(Time.Img)),
                                      y = value,group=Channel,colour=Channel))+
                geom_point()+geom_line()+
                geom_ribbon(aes(ymax = value + sd_value, ymin= value - sd_value,fill = Channel),
                            linetype=0,alpha=0.2)+
                xlab('Time')+ylab('Mean Intensity per Lysosome')+
                facet_grid(.~ Condition, scales = "free")+coord_cartesian(ylim=c(ymin, ymax))+
                scale_y_continuous(breaks = seq(ymin, ymax, by = 150))
}
# -----------------------------------------------------------------------