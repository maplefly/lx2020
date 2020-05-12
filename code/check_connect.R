#检查用于核查充电连接
rm(list = ls())

source("code\\library.r")
source("code\\fun_general.r")

#############

FILE_TEST <- "E:\\V\\DMZZ\\1data\\test\\ins\\2019-鼎城-直流数据.xlsx"

#############定义保存的文件夹
FILE_SAVE = c("calc\\ins_check\\")   #用于保存核查结果

raw <- xls_read(FILE_TEST,"直流连接确认")
data <- raw[1:10,c(2,13:33)]
write.xlsx(t(data),paste(FILE_SAVE,"check_connect.xls",sep=""))


