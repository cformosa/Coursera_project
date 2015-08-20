'''
R SCRIPT FOR PROJECT
'''

Part 1: #want to combine the test and training x and y variables along with the feature names
setwd('C:\\Users\\Chris\\Documents\\R\\Coursera\\UCI HAR Dataset\\train') 

x_train <- read.table('X_train.txt') #training set
feats <- read.table('C:\\Users\\Chris\\Documents\\R\\Coursera\\UCI HAR Dataset\\features.txt') #read feature table in
x <- rbind(as.vector(feats$V2), x_train) #add our features to identify each column

y_train <- read.table('y_train.txt') #training activity numbers set
y <- rbind('activity', y_train) #add word activity so we can identify this row easily


subject_train <- read.table('subject_train.txt') #read subject set in
subject <- rbind('subject', subject_train) #add word so we can identify this row easily

test <- cbind(subject, y, x) #combine all these into one big training table


setwd('C:\\Users\\Chris\\Documents\\R\\Coursera\\UCI HAR Dataset\\test')

x_test <- read.table('X_test.txt') #x test set

y_test <- read.table('y_test.txt')# y test set

subject_test <- read.table('subject_test.txt') # subject test set

training <- cbind(subject_test, y_test, x_test) #combine to make a big test set


total_data <- rbind(test, training) #combine to make our original dataset with all our information
View(total_data)
colnames(total_data)[1] = 'Activity'
colnames(total_data)[2] = 'y'
#step 1 is done!

Step 2:

mean_std <- select(total_data, grep('[Ss][Tt][Dd]|[Mm][Ee][Aa][Nn]', total_data))
#by using grep we can parse for only columns that contain std or mean in some case (upper or lower)
data2 <- cbind(total_data$Activity, total_data$y, mean_std) #new data containing only std and mean numerical columns
View(data2)

#we selected any columns that had the word mean or std in them anywhere, so step 2 is done

Step 3:
y_labels <- c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS','SITTING', 'STANDING', 'LAYING')
y_real <- y_labels[as.numeric(total_data$y)]

'''
THis code is clever... It knows for ex. y_labels[1] = 'WALKING', so we made all y values
numbers 1 to 6 and then it matched them by index
'''

y_real[1] <- 'activity'
data3 <- cbind(total_data$Activity, y_real, mean_std) #new dataset with correct activity labels so that it can be read easier
View(data3)
Step 3 is done


Step 4:

ncol(data3) #88
colnames(data3)[3:88] = as.vector(data3[1,][3:88]) #fix the column headers to be accurate
colnames(data3)[1] = 'subject_now' #replaces the correct column header
colnames(data3)[2] = 'activity' #replaces the correct column header
cleaner_data <- data3[-1,]  #eliminates the repeating row since we made this row our column headers
View(cleaner_data)

unclean_titles <- colnames(cleaner_data)[3:88] #format column headers so they are more coherent
half_clean <- gsub('-mean', ' Mean', unclean_titles) #makes the Mean columns more concise
full_clean <- gsub('-std', ' Std', half_clean) #makes the Std columns more cocise

colnames(cleaner_data)[3:88] = as.vector(full_clean) #put in new column headers
View(cleaner_data)
write.table(cleaner_data, file = 'C:\\Users\\Chris\\Documents\\R\\Coursera\\UCI HAR Dataset\\close.txt')
#the write.table function above was just for me, so ignore please
Step 4 is done

Step 5:
#want groups by subject and activity, so lets check out dplyr and tidyr
library(tidyr)
library(dplyr)

clean <- gather(cleaner_data, obs, value, -c(subject_now, activity)) #makes our data tidy (namely 1 obs per row now)
View(clean)
final_answer <- clean %>%
  select(1:4) %>%
  group_by(subject_now, activity) %>%
  summarise(mean = mean(as.numeric(value)), std = sd(as.numeric(value))) #gives new mean and std column for quick results of groups
View(final_answer)
