buildTimeSeries <- function(dataFrame) {
    repDataByInterval <- group_by(dataFrame, interval)
    repDataByInterval <- summarise(repDataByInterval, steps = mean(steps, na.rm = TRUE))
    tsData <- ts(repDataByInterval$steps, start=c(0, 0), frequency = (60 / 5))
    tsData
}