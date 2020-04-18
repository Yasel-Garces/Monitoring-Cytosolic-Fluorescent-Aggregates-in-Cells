# Scrip to generate corrections in the set of files that contain the information about the lysosomes.

# Directory with the files.
dir<-"/home/yasel/Data Science/Projects/Monitoring-Cytosolic-Fluorescent-Aggregates-in-Cells/Data(csv)/GR quenching/"

# Files in the directory
files<-list.files(dir,pattern = ".csv")

for (i in 1:length(files)){
        datos<-read.csv(paste(dir,files[i],sep = ""))
        
        # Convert to factor the type variable.
        datos$Type<-factor(datos$Type,levels = c(1,2),labels = c("mCherry", "Venus"))
        
        # Re-writte the changes in the file
        write.csv(datos,paste(dir,files[i],sep = ""),row.names = FALSE)
}
