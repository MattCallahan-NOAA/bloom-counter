#calculate extents from the lookup table
lkp%>%
  group_by(Ecosystem_Subarea)%>%
  summarise(minlat=min(latc),
            maxlat=max(latc),
            minlon=min(lonc),
            maxlon=max(lonc))#%>%
  write.csv("Data/extents.csv")
#check central aleutians
#calculate extents from the lookup table
lkp%>%
  filter(Ecosystem_Subarea=="Central Aleutians" & lonc>0)%>%
  group_by(Ecosystem_Subarea)%>%
  summarise(minlat=min(latc),
            maxlat=max(latc),
            minlon=min(lonc),
            maxlon=max(lonc))

(extents%>%filter(Ecosystem_Subarea=="Central Aleutians"))$minlat

extents<-read.csv("Data/extents.csv")

tibble(Ecosystem_Subarea=c("Southeastern Bering Sea", 
                             "Northern Bering Sea", 
                             "Western Gulf of Alaska", 
                             "Eastern Gulf of Alaska",
                             "Western Aleutians",
                             "Central Aleutians",
                             "Eastern Aleutians"),
       link=c("https://coastwatch.pfeg.noaa.gov/erddap/griddap/nesdisVHNSQchlaWeekly.png?chlor_a%5B(last)%5D%5B(0.0)%5D%5B(62.006249999999994):(53.006249999999994)%5D%5B(-179.98125):(-156.01874999999998)%5D&.draw=surface&.vars=longitude%7Clatitude%7Cchlor_a&.colorBar=%7C%7C%7C%7C%7C&.bgColor=0xffccccff",
              "https://coastwatch.pfeg.noaa.gov/erddap/griddap/nesdisVHNSQchlaWeekly.png?chlor_a%5B(last)%5D%5B(0.0)%5D%5B(66):(60.0)%5D%5B(-179.98125):(-161)%5D&.draw=surface&.vars=longitude%7Clatitude%7Cchlor_a&.colorBar=%7C%7C%7C%7C%7C&.bgColor=0xffccccff", 
              "https://coastwatch.pfeg.noaa.gov/erddap/griddap/nesdisVHNSQchlaWeekly.png?chlor_a%5B(last)%5D%5B(0.0)%5D%5B(61):(53.006249999999994)%5D%5B(-164):(-147)%5D&.draw=surface&.vars=longitude%7Clatitude%7Cchlor_a&.colorBar=%7C%7C%7C%7C%7C&.bgColor=0xffccccff",
              "https://coastwatch.pfeg.noaa.gov/erddap/griddap/nesdisVHNSQchlaWeekly.png?chlor_a%5B(last)%5D%5B(0.0)%5D%5B(61):(53.006249999999994)%5D%5B(-147):(-133)%5D&.draw=surface&.vars=longitude%7Clatitude%7Cchlor_a&.colorBar=%7C%7C%7C%7C%7C&.bgColor=0xffccccff",
              "https://coastwatch.pfeg.noaa.gov/erddap/griddap/nesdisVHNSQchlaWeekly.png?chlor_a%5B(last)%5D%5B(0.0)%5D%5B(57):(48)%5D%5B(168):(177)%5D&.draw=surface&.vars=longitude%7Clatitude%7Cchlor_a&.colorBar=%7C%7C%7C%7C%7C&.bgColor=0xffccccff",
              "https://coastwatch.pfeg.noaa.gov/erddap/griddap/nesdisVHNSQchlaWeekly.png?chlor_a%5B(last)%5D%5B(0.0)%5D%5B(56):(47)%5D%5B(170):(-170)%5D&.draw=surface&.vars=longitude%7Clatitude%7Cchlor_a&.colorBar=%7C%7C%7C%7C%7C&.bgColor=0xffccccff",
              "https://coastwatch.pfeg.noaa.gov/erddap/griddap/nesdisVHNSQchlaWeekly.png?chlor_a%5B(last)%5D%5B(0.0)%5D%5B(55):(49)%5D%5B(-170):(-164)%5D&.draw=surface&.vars=longitude%7Clatitude%7Cchlor_a&.colorBar=%7C%7C%7C%7C%7C&.bgColor=0xffccccff")
       )%>%
         saveRDS("Data/links.RDS")

       