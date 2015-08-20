'''
R SCRIPT FOR PROJECT
'''

Part 1:
setwd('C:\\Users\\Chris\\Documents\\R\\Coursera\\UCI HAR Dataset\\train')

x_train <- read.table('X_train.txt') #training set
feats <- read.table('C:\\Users\\Chris\\Documents\\R\\Coursera\\UCI HAR Dataset\\features.txt')
x <- rbind(as.vector(feats$V2), x_train)

y_train <- read.table('y_train.txt') #training labels
y <- rbind('activity', y_train)


subject_train <- read.table('subject_train.txt')
subject <- rbind('subject', subject_train)

test <- cbind(subject, y, x)


setwd('C:\\Users\\Chris\\Documents\\R\\Coursera\\UCI HAR Dataset\\test')

x_test <- read.table('X_test.txt')

y_test <- read.table('y_test.txt')

subject_test <- read.table('subject_test.txt')

training <- cbind(subject_test, y_test, x_test)


total_data <- rbind(test, training)
View(total_data)
colnames(total_data)[1] = 'Activity'
colnames(total_data)[2] = 'y'
#step 1 is done!

Step 2:

mean_std <- select(total_data, grep('[Ss][Tt][Dd]|[Mm][Ee][Aa][Nn]', total_data))
data2 <- cbind(total_data$Activity, total_data$y, mean_std)
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
data3 <- cbind(total_data$Activity, y_real, mean_std)
View(data3)
Step 3 is done


Step 4:

ncol(data3)
colnames(data3)[3:88] = as.vector(data3[1,][3:88])
colnames(data3)[1] = 'subject_now'
colnames(data3)[2] = 'activity'
cleaner_data <- data3[-1,]
View(cleaner_data)

unclean_titles <- colnames(cleaner_data)[3:88]
half_clean <- gsub('-mean', ' Mean', unclean_titles)
full_clean <- gsub('-std', ' Std', half_clean)
full_clean
#full_clean makes the variables a little more concise
colnames(cleaner_data)[3:88] = as.vector(full_clean)
View(cleaner_data)
write.table(cleaner_data, file = 'C:\\Users\\Chris\\Documents\\R\\Coursera\\UCI HAR Dataset\\close.txt')

Step 4 is done

Step 5:
#want groups by subject and activity, so lets check out dplyr and tidyr
library(tidyr)
library(dplyr)

clean <- gather(cleaner_data, obs, value, -c(subject_now, activity))
View(clean)
final_answer <- clean %>%
  select(1:4) %>%
  group_by(subject_now, activity) %>%
  summarise(mean = mean(as.numeric(value)), std = sd(as.numeric(value)))
View(final_answer)
