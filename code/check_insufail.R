#检查用于核查绝缘故障
rm(list = ls())

source("code\\library.r")
source("code\\fun_general.r")

#############

FILE_TEST <- "E:\\V\\DMZZ\\1data\\test\\ins\\2019-鼎城-直流数据.xlsx"

#############定义保存的文件夹
FILE_SAVE = c("calc\\ins_check\\")   #用于保存核查结果

raw <- xls_read(FILE_TEST,"直流绝缘故障检测")
data <- raw[1:10,1:31]
write.xlsx(data,paste(FILE_SAVE,"check_control.xls",sep=""))


