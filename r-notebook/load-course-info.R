library(golfcoursegeo)
library(tidyverse)

courseInfo <- extractCourseInfoFromKmlFiles(elevationCacheFile='/Users/scott/golfcoursegeo-elevation-cache.rds', kmlFiles=c(
  '/opt/data/golf-15th-club/Jumeirah Golf Estates.kml',
  '/opt/data/golf-15th-club/Regnum Carya Golf and Spa Resort.kml',
  '/opt/data/golf-15th-club/The Grove.kml',
  '/opt/data/golf-15th-club/Gary Player Golf Course.kml',
  '/opt/data/golf-15th-club/Oceanico Victoria Golf Club.kml',
  '/opt/data/golf-15th-club/Le Golf National.kml',
  '/opt/data/golf-15th-club/Golf Club Gut Lärchenhof.kml'
))

#courseInfo <- extractCourseInfoFromKmlFiles(elevationCacheFile='/Users/scott/golfcoursegeo-elevation-cache.rds',
#                                            kmlFiles='/opt/data/golf-15th-club/Le Golf National.kml')

courses <- read_csv('courses.csv', col_names=FALSE) %>%
  rename(course_id=X1, CourseName=X2, MetarStation=X3, TimeZone=X4)

courseInfo <- courseInfo %>% right_join(courses, by='CourseName')
