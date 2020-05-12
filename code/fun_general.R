source("E:\\V\\DMZZ\\LX\\code\\library.r")

#读取xls文件
xls_read <- function(filename,sheetname){
  fun_file <- odbcConnectExcel2007(filename)
  fun_data <- sqlFetch(fun_file,sheetname)
  return(fun_data)
}

##把某个变量取消科学计数法
no_sci <- function(var_name){
  var_name <- as.factor(format(var_name, scientific = FALSE))
}


##factor to num
factor2num <- function(var_name){
  var_name <- as.numeric(as.character(var_name))
}




##根据给定的数据集，对母数据集增加一个通用标签变量
data_lable <- function(sub_data,total_data,data_ID,data_lable){
  sub_data <- mutate(sub_data,data_lable = 1) 
  
  total_data <- sub_data %>>%
    select(data_ID,data_lable) %>>%
    join(x = total_data)
  return(total_data)
}




##下载图片
pic_down <- function(img_url,img_dic,img_name,img_num){
  for(i in 1:img_num) 
    if(!is.na(img_url[i]))
      download(img_url[i],paste(img_dic,img_name[i],".jpg",sep = ""), mode = "wb")
  print(img_name)
}
