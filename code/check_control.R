#用于核查自检阶段
rm(list = ls())

source("code\\library.r")
source("code\\fun_general.r")

#############

FILE_TEST <- "E:\\V\\DMZZ\\1data\\test\\ins\\2019-鼎城-直流数据.xlsx"

#############定义保存的文件夹
FILE_SAVE = c("calc\\ins_check\\")   #用于保存核查结果


raw <- xls_read(FILE_TEST,"直流充电连接控制时")
names(raw)

data <- raw[1:10,c(2,13:31,6,7)]


#输出数据
write.xlsx(t(data),paste(FILE_SAVE,"check_control.xls",sep=""))

#输出图片
img_dic = FILE_SAVE
data$no <- 1:nrow(data)
##输出图片1
data$img_name <- paste("control","_",substr(data$image1_name,1,7),"_",data$no,".png",sep="")  #~~

img_url = as.character(data$image1_data)
img_name = data$img_name
img_num = length(img_url)
pic_down(img_url,img_dic,img_name,img_num)
