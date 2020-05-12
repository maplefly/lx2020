#用于核查充电阶段和电性能的关键参数
rm(list = ls())

source("code\\library.r")
source("code\\fun_general.r")

#############

FILE_TEST <- "E:\\V\\DMZZ\\1data\\test\\ins\\2019-鼎城-直流数据.xlsx"

#############定义保存的文件夹
FILE_SAVE = c("calc\\ins_check\\")   #用于保存核查结果

############################################################################################
##########################导入数据##########################################################
############################################################################################

##############################导入电性能数据################################################


raw <- xls_read(FILE_TEST,"直流输出电压电量误差")

raw <- raw %>>%
  rename(return_result_elec = return_result,
         deltaumax_elec = deltaumax,
         deltaumed_elec = deltaumed,
         iz_50imax_cc_elec = iz_50imax_cc,
         iz_100imax_cc_elec = iz_100imax_cc,
         iz_20imax_cc_elec = iz_20imax_cc)

data <- raw

##############################读入充电阶段数据################################################
##
raw <- xls_read(FILE_TEST,"直流充电阶段")

raw <- raw %>>%
  rename(return_result_charge = return_result,
         deltaumax_charge = deltaumax,
         deltaumed_charge = deltaumed,
         iz_50imax_cc_charge = iz_50imax_cc,
         iz_100imax_cc_charge = iz_100imax_cc,
         iz_20imax_cc_charge = iz_20imax_cc)


names(raw)

###################################
##两个检测项目全部变量合成
data <- data %>>%
  join(y=raw)
#  join(y=raw,by="asset_code")

names(data)
data <- t(data)

write.xlsx(data[,1:10],paste(FILE_SAVE,"check_chargeAelec.xls",sep=""))
