#自检阶段的四个检测结论的筛选
#judge_umax_l	judge_10v judge_umax_h judge_umin_l


source("code\\library.r")
source("code\\fun_general.r")



#############定义保存的文件夹
FILE_SAVE = c("doc\\7分析报告\\安全分析\\")   #里边包含若干相对目录

##
raw_ha <- xls_read("data\\test\\ins\\2019-鼎城-直流数据.xlsx","直流自检阶段")
#raw_ha <- raw_ha[,-1]

raw_zz <- xls_read("data\\test\\ins\\2019-中智-直流数据.xlsx","直流自检阶段")
#raw_zz <- raw_zz[,-1]

raw <- rbind(raw_zz,raw_ha)
names(raw)
head(raw)

raw <- raw %>>%
  rename(equ_station = station_name	) %>>%
  rename(equ_no = asset_code) %>>%
  rename(equ_fac = operator) 


##引入运营数据
equ_run <- xls_read("E:\\V\\DMZZ\\LX\\doc\\7分析报告\\电流控制误差.xls","Sheet1")
equ_run_fac <- ddply(equ_run,.(equ_fac_st),nrow)


##汇总数据
raw <- join(raw,equ_run,by="equ_no") %>>%
  subset( return_result != "null")
describe(raw$return_result)
############################################################################################
##########################1自检_大于10V##################################################
############################################################################################
#预定义部分
##定义相对目录
REL_DIC <- paste(FILE_SAVE,c("1自检_大于10V\\"),sep="")
PIC_TITLE <- "自检_大于10V"

#导入数据
data <- raw%>>%
  select(
    equ_no,
    equ_station,
    equ_fac,
    put_into_time,
    SUBMIT_TIME,
    judge_10v,
    image1_name,
    image1_data,
    equ_fac_st)%>>%
  rename(image_url = image1_data,
         image_title = image1_name)


#数据处理
data$image_name <- paste(PIC_TITLE,"_",substr(data$equ_fac,1,4),"_",data$equ_station,"_",data$equ_no,sep="")
#describe(data$judge_10v) 
#write.csv(data,"test.csv")
#数据筛选，此处需要根据项目确定筛选变量
data <- data%>>%                                     
  subset(judge_10v == "不合格" |
           judge_10v == "不合格1"|
           judge_10v == "--"
  ) %>>%
  subset( image_title == "电池大于10V.png")

#下载图片
NAME_ID = 0 
i = 1
if(NAME_ID){
  for(i in 1:nrow(data)) { 
    download(as.character(data$image_url[i]),paste(REL_DIC,
                                                   data$image_name[i],
                                                   ".jpg",
                                                   sep = ""), mode = "wb") 
  }
  
}

unlock_station <- raw %>>%
  ddply(.(equ_station),nrow)

unlock_station <- data %>>%
  ddply(.(equ_station),nrow,.progress = "text") %>>%
  rename(故障数量 = V1) %>>%
  inner_join(y=unlock_station) %>>%
  arrange(desc(V1)) %>>%
  rename(检测数量 = V1) %>>%
  arrange(desc(故障数量))

unlock_fac <- raw %>>%
  ddply(.(equ_fac_st),nrow)

unlock_fac <- data %>>%
  ddply(.(equ_fac_st),nrow,.progress = "text") %>>%
  rename(故障数量 = V1) %>>%
  inner_join(y=unlock_fac) %>>%
  arrange(desc(V1)) %>>%
  rename(检测数量 = V1) %>>%
  na.omit() %>>%
  arrange(desc(故障数量))

write.xlsx(unlock_station,paste(REL_DIC,"stat_station.xls",sep = ""))
write.xlsx(unlock_fac,paste(REL_DIC,"stat_fac.xls",sep = ""))
write.xlsx(data[,1:5],paste(REL_DIC,"detail.xls",sep = ""))



############################################################################################
##########################2自检_车电压低##################################################
############################################################################################
#预定义部分
##定义相对目录
REL_DIC <- paste(FILE_SAVE,c("2自检_车电压低\\"),sep="")
PIC_TITLE <- "BHM小于最低电压"

#导入数据
data <- raw%>>%
  select(
    equ_no,
    equ_station,
    equ_fac,
    put_into_time,
    SUBMIT_TIME,
    judge_umin_l,
    image3_name,
    image3_data,
    equ_fac_st)%>>%
  rename(image_url = image3_data,
         image_title = image3_name)


#数据处理
data$image_name <- paste(PIC_TITLE,"_",substr(data$equ_fac,1,4),"_",data$equ_station,"_",data$equ_no,sep="")
describe(data$judge_umin_l) 
#write.csv(data,"test.csv")
#数据筛选，此处需要根据项目确定筛选变量
data <- data%>>%
  subset(judge_umin_l == "不合格1" |
           #           judge_10v == "不合格"|
           judge_umin_l == "--"
  ) %>>%
  subset( image_title == "电池小于10V(BHM小于最低电压).png")

#下载图片
NAME_ID = 0 
i = 1
if(NAME_ID){
  for(i in 1:nrow(data)) { 
    download(as.character(data$image_url[i]),paste(REL_DIC,
                                                   data$image_name[i],
                                                   ".jpg",
                                                   sep = ""), mode = "wb") 
  }
  
}

unlock_station <- raw %>>%
  ddply(.(equ_station),nrow)

unlock_station <- data %>>%
  ddply(.(equ_station),nrow,.progress = "text") %>>%
  rename(故障数量 = V1) %>>%
  inner_join(y=unlock_station) %>>%
  arrange(desc(V1)) %>>%
  rename(检测数量 = V1) %>>%
  arrange(desc(故障数量))

unlock_fac <- raw %>>%
  ddply(.(equ_fac_st),nrow)

unlock_fac <- data %>>%
  ddply(.(equ_fac_st),nrow,.progress = "text") %>>%
  rename(故障数量 = V1) %>>%
  inner_join(y=unlock_fac) %>>%
  arrange(desc(V1)) %>>%
  rename(检测数量 = V1) %>>%
  na.omit() %>>%
  arrange(desc(故障数量))

write.xlsx(unlock_station,paste(REL_DIC,"stat_station.xls",sep = ""))
write.xlsx(unlock_fac,paste(REL_DIC,"stat_fac.xls",sep = ""))
write.xlsx(data[,1:5],paste(REL_DIC,"detail.xls",sep = ""))






############################################################################################
##########################3自检_电池小于10V(BHM正常)##################################################
############################################################################################
#预定义部分
##定义相对目录
REL_DIC <- paste(FILE_SAVE,c("3自检_电池小于10V(BHM正常)\\"),sep="")
PIC_TITLE <- "电池小于10V(BHM正常)"

#导入数据
data <- raw%>>%
  select(
    equ_no,
    equ_station,
    equ_fac,
    put_into_time,
    SUBMIT_TIME,
    judge_umax_l,   ##~~
    uk1k2_umax_l,   ##~~
    image4_name,    ##~~
    image4_data,    ##~~
    equ_fac_st)%>>%
  rename(image_url = image4_data,
         image_title = image4_name)
data$uk1k2_umax_l <- as.numeric(as.character(data$uk1k2_umax_l))

#数据处理
data$image_name <- paste(PIC_TITLE,"_",substr(data$equ_fac,1,4),"_",data$equ_station,"_",data$equ_no,sep="")
describe(data$judge_umax_l) 
#write.csv(data,"test.csv")
#数据筛选，此处需要根据项目确定筛选变量
data <- data%>>%
  subset(judge_umax_l != "合格"  ) %>>%
  subset(uk1k2_umax_l > 370) %>>%
  subset( image_title == "电池小于10V(BHM正常).png")

#下载图片
NAME_ID = 0 
i = 1
if(NAME_ID){
  for(i in 1:nrow(data)) { 
    download(as.character(data$image_url[i]),paste(REL_DIC,
                                                   data$image_name[i],
                                                   ".jpg",
                                                   sep = ""), mode = "wb") 
  }
  
}

unlock_station <- raw %>>%
  ddply(.(equ_station),nrow)

unlock_station <- data %>>%
  ddply(.(equ_station),nrow,.progress = "text") %>>%
  rename(故障数量 = V1) %>>%
  inner_join(y=unlock_station) %>>%
  arrange(desc(V1)) %>>%
  rename(检测数量 = V1) %>>%
  arrange(desc(故障数量))

unlock_fac <- raw %>>%
  ddply(.(equ_fac_st),nrow)

unlock_fac <- data %>>%
  ddply(.(equ_fac_st),nrow,.progress = "text") %>>%
  rename(故障数量 = V1) %>>%
  inner_join(y=unlock_fac) %>>%
  arrange(desc(V1)) %>>%
  rename(检测数量 = V1) %>>%
  na.omit() %>>%
  arrange(desc(故障数量))

write.xlsx(unlock_station,paste(REL_DIC,"stat_station.xls",sep = ""))
write.xlsx(unlock_fac,paste(REL_DIC,"stat_fac.xls",sep = ""))
write.xlsx(data[,1:5],paste(REL_DIC,"detail.xls",sep = ""))




############################################################################################
##########################4自检_电池小于10V(BHM大于最高电压)##################################################
############################################################################################
#预定义部分
##定义相对目录
REL_DIC <- paste(FILE_SAVE,c("4自检_电池小于10V(BHM大于最高电压)\\"),sep="")
PIC_TITLE <- "电池小于10V(BHM大于最高电压)"

#导入数据
data <- raw%>>%
  select(
    equ_no,
    equ_station,
    equ_fac,
    put_into_time,
    SUBMIT_TIME,
    judge_umax_h,   ##~~
    uk1k2_umax_h,   ##~~
    image2_name,    ##~~
    image2_data,    ##~~
    equ_fac_st)%>>%
  rename(image_url = image2_data,
         image_title = image2_name)
data$uk1k2_umax_h <- as.numeric(as.character(data$uk1k2_umax_h))

#数据处理
data$image_name <- paste(PIC_TITLE,"_",substr(data$equ_fac,1,4),"_",data$equ_station,"_",data$equ_no,sep="")
describe(data$judge_umax_h) 
#write.csv(data,"test.csv")
#数据筛选，此处需要根据项目确定筛选变量
data <- data%>>%
  subset(judge_umax_h != "合格"  ) %>>%      
  subset(uk1k2_umax_h < 450 & 
           uk1k2_umax_h >50) %>>%                                ##~~
  subset( image_title == "电池小于10V(BHM大于最高电压).png")             ##~~

#下载图片
NAME_ID = 0 
i = 1
if(NAME_ID){
  for(i in 1:nrow(data)) { 
    download(as.character(data$image_url[i]),paste(REL_DIC,
                                                   data$image_name[i],
                                                   ".jpg",
                                                   sep = ""), mode = "wb") 
  }
  
}

unlock_station <- raw %>>%
  ddply(.(equ_station),nrow)

unlock_station <- data %>>%
  ddply(.(equ_station),nrow,.progress = "text") %>>%
  rename(故障数量 = V1) %>>%
  inner_join(y=unlock_station) %>>%
  arrange(desc(V1)) %>>%
  rename(检测数量 = V1) %>>%
  arrange(desc(故障数量))

unlock_fac <- raw %>>%
  ddply(.(equ_fac_st),nrow)

unlock_fac <- data %>>%
  ddply(.(equ_fac_st),nrow,.progress = "text") %>>%
  rename(故障数量 = V1) %>>%
  inner_join(y=unlock_fac) %>>%
  arrange(desc(V1)) %>>%
  rename(检测数量 = V1) %>>%
  na.omit() %>>%
  arrange(desc(故障数量))

write.xlsx(unlock_station,paste(REL_DIC,"stat_station.xls",sep = ""))
write.xlsx(unlock_fac,paste(REL_DIC,"stat_fac.xls",sep = ""))
write.xlsx(data[,1:5],paste(REL_DIC,"detail.xls",sep = ""))

