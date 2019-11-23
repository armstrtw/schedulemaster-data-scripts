library(data.table)

sdir <- "~/Downloads"
schedule.fname <- "AEC14214-C89E-4EF7-9B0F-0820202D6BC3.csv"
schedules.raw <- as.data.table(read.csv(paste(sdir,schedule.fname,sep="/"),
                            header=TRUE,stringsAsFactors=FALSE))

nnum.exclude <- c("017AV","15664")
setnames(schedules.raw,c("Sch_Key","ID_NO","User."),c("id","nnumber","user"))

schedules <- schedules.raw[!nnumber %in% nnum.exclude]
                 
members <- schedules[match(sort(unique(schedules$User.)),schedules$User.),c("user","Firstname","Lastname")]
write.table(members,"/tmp/members.tsv",col.names=FALSE,row.names=FALSE,quote=FALSE,sep="\t")

## easy view
##schedules[substring(Start,1,10)=="11/23/2019"]

schedules.for.db <- schedules[,c("id","nnumber","user","Made","Start","End","Canceled","maintenance","Destination")]
schedules.for.db[,nnumber:=paste0("N",nnumber)]
schedules.for.db[Canceled=="",Canceled:="\\N"]
schedules.for.db[Destination=="",Destination:="\\N"]
write.table(schedules.for.db,"/tmp/schedules.tsv",col.names=FALSE,row.names=FALSE,quote=FALSE,sep="\t")
