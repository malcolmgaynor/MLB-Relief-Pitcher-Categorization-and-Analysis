library(tidyverse)

#read in data
#fangraphsall<-read.csv(file=file.choose())
head(fangraphsall)


#Percent23
percent23<-read.csv(file=file.choose())
percent23$year <- "2023"

percent23 <- percent23 %>% 
  rename(
    Name = last_name..first_name,
    Season = year
  )

#merge fangraphs and savant data
total23 <- merge(fangraphsall,percent23,by=c("Name","Season"))



#Velo23
velo23<-read.csv(file=file.choose())

velo23$year <- "2023"

velo23 <- velo23 %>% 
  rename(
    Name = last_name..first_name,
    Season = year
  )

total23 <- merge(total23,velo23,by=c("Name","Season"))


#Spin23
spin23<-read.csv(file=file.choose())

spin23$year <- "2023"

spin23 <- spin23 %>% 
  rename(
    Name = last_name..first_name,
    Season = year
  )

total23 <- merge(total23,spin23,by=c("Name","Season"))
tail(total23)

#Percent22
percent22<-read.csv(file=file.choose())
percent22$year <- "2022"

percent22 <- percent22 %>% 
  rename(
    Name = last_name..first_name,
    Season = year
  )

total22 <- merge(fangraphsall,percent22,by=c("Name","Season"))




#Velo22
velo22<-read.csv(file=file.choose())

velo22$year <- "2022"

velo22 <- velo22 %>% 
  rename(
    Name = last_name..first_name,
    Season = year
  )

total22 <- merge(total22,velo22,by=c("Name","Season"))


#Spin22
spin22<-read.csv(file=file.choose())

spin22$year <- "2022"

spin22 <- spin22 %>% 
  rename(
    Name = last_name..first_name,
    Season = year
  )

total22 <- merge(total22,spin22,by=c("Name","Season"))
tail(total22)



#Percent21
percent21<-read.csv(file=file.choose())
percent21$year <- "2021"

percent21 <- percent21 %>% 
  rename(
    Name = last_name..first_name,
    Season = year
  )

total21 <- merge(fangraphsall,percent21,by=c("Name","Season"))



#Velo21
velo21<-read.csv(file=file.choose())

velo21$year <- "2021"

velo21 <- velo21 %>% 
  rename(
    Name = last_name..first_name,
    Season = year
  )

total21 <- merge(total21,velo21,by=c("Name","Season"))


#Spin21
spin21<-read.csv(file=file.choose())

spin21$year <- "2021"

spin21 <- spin21 %>% 
  rename(
    Name = last_name..first_name,
    Season = year
  )

total21 <- merge(total21,spin21,by=c("Name","Season"))
tail(total21)




#Percent19
percent19<-read.csv(file=file.choose())
percent19$year <- "2019"

percent19 <- percent19 %>% 
  rename(
    Name = last_name..first_name,
    Season = year
  )

total19 <- merge(fangraphsall,percent19,by=c("Name","Season"))



#Velo19
velo19<-read.csv(file=file.choose())

velo19$year <- "2019"

velo19 <- velo19 %>% 
  rename(
    Name = last_name..first_name,
    Season = year
  )

total19 <- merge(total19,velo19,by=c("Name","Season"))


#Spin19
spin19<-read.csv(file=file.choose())

spin19$year <- "2019"

spin19 <- spin19 %>% 
  rename(
    Name = last_name..first_name,
    Season = year
  )

total19 <- merge(total19,spin19,by=c("Name","Season"))
tail(total19)



#Percent18
percent18<-read.csv(file=file.choose())
percent18$year <- "2018"

percent18 <- percent18 %>% 
  rename(
    Name = last_name..first_name,
    Season = year
  )

total18 <- merge(fangraphsall,percent18,by=c("Name","Season"))



#Velo18
velo18<-read.csv(file=file.choose())

velo18$year <- "2018"

velo18 <- velo18 %>% 
  rename(
    Name = last_name..first_name,
    Season = year
  )

total18 <- merge(total18,velo18,by=c("Name","Season"))


#Spin18
spin18<-read.csv(file=file.choose())

spin18$year <- "2018"

spin18 <- spin18 %>% 
  rename(
    Name = last_name..first_name,
    Season = year
  )

total18 <- merge(total18,spin18,by=c("Name","Season"))
tail(total23)

totalAll <- rbind(total18, total19,total21,total22,total23)
View(totalAll)

colnames(totalAll)
alldata = subset(totalAll, select = -c(pitcher.x,pitcher.y,pitcher) )

alldata <- alldata %>% replace(is.na(.), 0)

alldata$Season<-as.character(alldata$Season)

alldata$code<-paste(alldata$Season,alldata$Name)
tail(alldata)

View(alldata)



write.csv(alldata, "final_to_cluster.csv")




