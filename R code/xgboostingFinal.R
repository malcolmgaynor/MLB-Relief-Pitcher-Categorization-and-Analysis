library(matrixStats)
library(rpart)
library(rpart.plot)
library(caret)
library(xgboost)

#read in data

#alldata<-read.csv(file=file.choose())
#newdata<-read.csv(file=file.choose())
newdata$code<-newdata$Code


#combining clustering stats with supervised learning stats
real_all_stats<- merge(alldata,newdata,by="code")

#convert percentages to decimals
real_all_stats$IFFB.<- as.numeric(sub("%", "", real_all_stats$IFFB.)) / 100
real_all_stats$Soft.<- as.numeric(sub("%", "", real_all_stats$Soft.)) / 100
real_all_stats$Med.<- as.numeric(sub("%", "", real_all_stats$Med.)) / 100
real_all_stats$Hard.<- as.numeric(sub("%", "", real_all_stats$Hard.)) / 100
real_all_stats$Barrel.<- as.numeric(sub("%", "", real_all_stats$Barrel.)) / 100
real_all_stats$HardHit.<- as.numeric(sub("%", "", real_all_stats$HardHit.)) / 100

#divide clusters
realcluster1 <- subset(real_all_stats, realclusters == 1)
realcluster2 <- subset(real_all_stats, realclusters == 2)
realcluster3 <- subset(real_all_stats, realclusters == 3)
realcluster4 <- subset(real_all_stats, realclusters == 4)
realcluster5 <- subset(real_all_stats, realclusters == 5)
realcluster6 <- subset(real_all_stats, realclusters == 6)
realcluster7 <- subset(real_all_stats, realclusters == 7)





### Repeat following code for all 7 cluster. Change number on first and last line

#set df to be the current cluster, onlyconsidering relevant columns
df <- realcluster7[c(1,10:44,47:70)]

#split into testing and training data matrices
index <- createDataPartition(df$ERA, p = 0.7, list = FALSE)
train_data <- df[index, ]
test_data <- df[-index, ]

dtrain <- xgb.DMatrix(data = as.matrix(train_data[, -1:-2]),label=train_data$ERA)
dtest <- xgb.DMatrix(data = as.matrix(test_data[, -1:-2]),label=test_data$ERA)

# compute cross validation with the training data to find ideal value for nrounds

xgbcrossval <- xgb.cv(
  data = dtrain,
  label = train_data$ERA,
  nrounds = 10000,
  objective = "reg:squarederror",
  early_stopping_rounds = 50,
  nfold = 10,
  params = list(
    eta = 0.01, 
    max_depth = 3,
    min_child_weight = 3,
    subsample = 0.8,
    colsample_bytree = 0.8),
  verbose = 0
)

# now make our actual gradient boosting model, with our nrounds from the previous cv:
xgb.fit.final <- xgboost(
  params = list(
    eta = 0.01, 
    max_depth = 3,
    min_child_weight = 3,
    subsample = 0.8,
    colsample_bytree = 0.8),
  data = dtrain,
  label = train_data$ERA,
  nrounds = xgbcrossval$best_iteration,
  objective = "reg:squarederror",
  verbose = 0
)

#now calculate RMSE of testing data
predictions <- predict(xgb.fit.final, dtest)
rmse_value <- rmse(predictions, test_data$ERA)
print(paste("RMSE: ", rmse_value))

#rename based on cluster
final.xgb.cluster.7 <-xgb.fit.final

#final.xgb.cluster.1: 0.833, n = 82
#final.xgb.cluster.2: 1.003, n = 251
#final.xgb.cluster.3: 0.884, n = 253
#final.xgb.cluster.4: 0.976, n = 140
#final.xgb.cluster.5: 1.006, n = 185
#final.xgb.cluster.6: 0.959, n = 88
#final.xgb.cluster.7: 0.837, n = 87

vip::vip(final.xgb.cluster.1)
vip::vip(final.xgb.cluster.2)
vip::vip(final.xgb.cluster.3)
vip::vip(final.xgb.cluster.4)
vip::vip(final.xgb.cluster.5)
vip::vip(final.xgb.cluster.6)
vip::vip(final.xgb.cluster.7)

#isolate names/ERA and other stats, then make predictions and add them on to name and ERA
namecode <- real_all_stats[c(1,45,10)]
final_for_xgb_matrix <- xgb.DMatrix(data = as.matrix(real_all_stats[c(11:44,47:70)]), label = real_all_stats$ERA)

#apply xgboost model to all relievers
final_predictionsxgb1 <- predict(final.xgb.cluster.1, final_for_xgb_matrix)
final_with_preds<-namecode
final_with_preds$xgb1<-final_predictionsxgb1

final_predictionsxgb2 <- predict(final.xgb.cluster.2, final_for_xgb_matrix)
final_with_preds$xgb2<-final_predictionsxgb2

final_predictionsxgb3 <- predict(final.xgb.cluster.3, final_for_xgb_matrix)
final_with_preds$xgb3<-final_predictionsxgb3

final_predictionsxgb4 <- predict(final.xgb.cluster.4, final_for_xgb_matrix)
final_with_preds$xgb4<-final_predictionsxgb4

final_predictionsxgb5 <- predict(final.xgb.cluster.5, final_for_xgb_matrix)
final_with_preds$xgb5<-final_predictionsxgb5

final_predictionsxgb6 <- predict(final.xgb.cluster.6, final_for_xgb_matrix)
final_with_preds$xgb6<-final_predictionsxgb6

final_predictionsxgb7 <- predict(final.xgb.cluster.7, final_for_xgb_matrix)
final_with_preds$xgb7<-final_predictionsxgb7

View(final_with_preds)

#find largest discrepancy between predicted min and max

xgb_cols <- c("xgb1", "xgb2", "xgb3","xgb4","xgb5","xgb6","xgb7")

# Calculate the row-wise maximum
final_with_preds$max_pred <- apply(final_with_preds[xgb_cols], 1, max)
final_with_preds$min_pred <- apply(final_with_preds[xgb_cols], 1, min)
final_with_preds$range_pred <- final_with_preds$max_pred - final_with_preds$min_pred
final_with_preds$pred_improvement <-final_with_preds$ERA - final_with_preds$min_pred

#Here are the predictions to be analyzed
View(final_with_preds)

#export data
write.csv(final_with_preds,"FINALera.predictions.csv")





