# Reproducible Research: Peer Assessment 1

```r
    library('dplyr')
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

## Loading and preprocessing the data

```r
    #Unzipping and reading the data
    unzip('activity.zip')
    repData <- read.csv('activity.csv')
```

```r
    #Grouping the data
    repDataByDate <- group_by(repData, date)
    repDataByDate <- summarise(repDataByDate, stepsByDate = sum(steps, na.rm = TRUE))
    hist(repDataByDate$stepsByDate, main = "Histogram of a total steps count per day", xlab = "Total steps count", breaks = 10)
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)

## What is mean total number of steps taken per day?

```r
    mean(repDataByDate$stepsByDate)
```

```
## [1] 9354.23
```

```r
    median(repDataByDate$stepsByDate)
```

```
## [1] 10395
```

## What is the average daily activity pattern?

```r
    repDataByInterval <- group_by(repData, interval)
    repDataByInterval <- summarise(repDataByInterval, steps = mean(steps, na.rm = TRUE))
```

```r
    tsData <- ts(repDataByInterval$steps, start=c(0, 0), frequency = (60 / 5))
    plot(tsData, main="Average daily activity", ylab="Steps per 5 minutes", xlab="Time, hours")
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png)


```r
    maxStepsInterval <- repDataByInterval[repDataByInterval$steps == max(repDataByInterval$steps), ]$interval    
```

## Imputing missing values

```r
    for (i in seq(1, length(repData$steps))) {
        if (is.na(repData[i, 'steps'])) {
            repData[i, 'steps'] = repDataByInterval[repDataByInterval$interval == repData[i, 'interval'],]$steps
        }
    }
```

```r
    repDataByDate <- group_by(repData, date)
    repDataByDate <- summarise(repDataByDate, stepsByDate = sum(steps, na.rm = TRUE))
    hist(repDataByDate$stepsByDate, main = "Histogram of a total steps count per day", xlab = "Total steps count", breaks = 10)
```

![](PA1_template_files/figure-html/unnamed-chunk-9-1.png)

```r
    mean(repDataByDate$stepsByDate)
```

```
## [1] 10766.19
```

```r
    median(repDataByDate$stepsByDate)
```

```
## [1] 10766.19
```
## Are there differences in activity patterns between weekdays and weekends?

```r
    repDataExt <- mutate(repData, weekend = (weekdays(as.POSIXlt(date)) == "Суббота" | weekdays(as.POSIXlt(date)) == "Воскресенье"))
    repDateWeekday <- filter(repDataExt, !weekend)
    repDateWeekend <- filter(repDataExt, weekend)
    source('buildTimeSeries.R')
    repDateWeekdayTS <- buildTimeSeries(repDateWeekday)
    repDateWeekendTS <- buildTimeSeries(repDateWeekend)
    # par(mfrow=c(1, 2))
    plot(repDateWeekdayTS, main="Average daily activity (weekday)", ylab="Steps per 5 minutes", xlab="Time, hours")
```

![](PA1_template_files/figure-html/unnamed-chunk-11-1.png)

```r
    plot(repDateWeekendTS, main="Average daily activity (weekend)", ylab="Steps per 5 minutes", xlab="Time, hours")
```

![](PA1_template_files/figure-html/unnamed-chunk-11-2.png)







