library(RCurl)
library(readr)
library(lubridate)
library(purrr)

getMetarWeather <- function(stationCodes, startDate, endDate, timeZone='Etc/UTC') {
  
  # have found that buffering by a day is necessary to make sure we get all obs
  startDateB <- startDate - 1
  endDateB <- endDate + 1
  
  startYear <- year(startDateB)
  startMonth <- month(startDateB)
  startDay <- day(startDateB)
  endYear <- year(endDateB)
  endMonth <- month(endDateB)
  endDay <- day(endDateB)
  
  map_df(stationCodes, function(stationCode) {
    
    writeLines(paste0('Getting METAR data for station ', stationCode, ' for dates ', startDate, ' to ', endDate))
    
    u <- 'https://mesonet.agron.iastate.edu/cgi-bin/request/asos.py?data=all&tz=Etc/UTC&format=comma'
    u <- paste0(u, '&year1=', startYear, '&month1=', startMonth, '&day1=', startDay)
    u <- paste0(u, '&year2=', endYear, '&month2=', endMonth, '&day2=', endDay)
    u <- paste0(u, '&station=', stationCode)
    
    df <- read_csv(getURL(u), skip=5, na='M',
                   col_types='cTddddddddddccccddddccT') %>%
      mutate(LocalTime=with_tz(valid, timeZone), LocalTimeD=as_date(LocalTime)) %>%
      filter(LocalTimeD >= startDate & LocalTimeD <= endDate) %>%
      select(-LocalTimeD)
    
    df
    
  })
  
}

