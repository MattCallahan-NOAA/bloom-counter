#load packages
library(shiny)
library(tidyverse)
library(shinycssloaders)
library(lubridate)
library(httr)
library(gridExtra)
library(shinythemes)

#define ecosystem subregions
subregions<-c("Southeastern Bering Sea", 
  "Northern Bering Sea", 
  "Western Gulf of Alaska", 
  "Eastern Gulf of Alaska",
  "Western Aleutians",
  "Central Aleutians",
  "Eastern Aleutians")

#textlink<-paste0("https://coastwatch.pfeg.noaa.gov/erddap/griddap/nesdisVHNSQchlaWeekly.png?chlor_a%5B(last)","%5D%5B(0.0)%5D%5B(",62.006249999999994,"):(53.006249999999994)%5D%5B(-179.98125):(-156.01874999999998)%5D&.draw=surface&.vars=longitude%7Clatitude%7Cchlor_a&.colorBar=%7C%7C%7C%7C%7C&.bgColor=0xffccccff")

#link<-readRDS("Data/links.RDS")
extents<-read.csv("Data/extents.csv")

#virrs
viirs<-readRDS("Data/viirs2022.RDS")

#define UI
ui <- fluidPage(

  titlePanel("Alaska chlorophyll bloom counter"),
             #put text in header
             tags$blockquote("Chlorophyll-a biomass (ug/L) aggregated by region. Data are derived from the VIIRS weekly 4k product and obtained from coastwatch https://coastwatch.pfeg.noaa.gov/erddap/griddap/nesdisVHNSQchlaWeekly.html. Code at https://github.com/MattCallahan-NOAA/bloom-counter. Contact matt.callahan@noaa.gov with questions"),
             #define sidebar layout
             sidebarLayout(
                #Define sidebar panel
                sidebarPanel(
                  #region input
                 selectInput(inputId = "region",
                             label = "Select subregion",
                             choices = subregions,
                             selected = "Southeastern Bering Sea"
                 ),
                 img(src='esr_map_depth_filters.png', width="450", height="275")
               ),
               mainPanel(textOutput(outputId="selected_region"),
                         textOutput(outputId="maxlon"),
                        # img(src=textlink)
                       #  img(src=paste(textOutput(outputId="link")))
                       #  img(src="https://coastwatch.pfeg.noaa.gov/erddap/griddap/nesdisVHNSQchlaWeekly.png?chlor_a%5B(last)%5D%5B(0.0)%5D%5B(62.006249999999994):(53.006249999999994)%5D%5B(-179.98125):(-156.01874999999998)%5D&.draw=surface&.vars=longitude%7Clatitude%7Cchlor_a&.colorBar=%7C%7C%7C%7C%7C&.bgColor=0xffccccff")
                         img(src=paste0("https://coastwatch.pfeg.noaa.gov/erddap/griddap/nesdisVHNSQchlaWeekly.png?chlor_a%5B(last)%5D%5B(0.0)%5D%5B(",
                        #               as.character(textOutput(outputId="maxlat")),
                      htmlOutput(outputId="maxlat"),
                      #62,
                                        "):(",
                      #                  as.character(textOutput(outputId="minlat")),
                      htmlOutput(outputId="minlat"),
                      #53,
                                        ")%5D%5B(",
                      #                  as.character(textOutput(outputId="minlon")),
                      htmlOutput(outputId="minlon"),
                      #-179.99,
                                       "):(",
                      #                  as.character(textOutput(outputId="maxlon")),
                      htmlOutput(outputId="maxlon"),
                     # -156,
                                        ")%5D&.draw=surface&.vars=longitude%7Clatitude%7Cchlor_a&.colorBar=%7C%7C%7C%7C%7C&.bgColor=0xffccccff")),
                     plotOutput(outputId ="chla_plot")
               
              
             
               )  
             )

)
              
#define server
server <- function(input, output) {
  #
  output$selected_region<- renderText({input$region})
  extents2<-reactive(extents%>%filter(Ecosystem_Subarea==input$region))
  output$minlat<-renderText(extents2()$minlat)
  output$maxlat<-renderText(extents2()$maxlat)
  output$minlon<-renderText(extents2()$minon)
  output$maxlon<-renderText(extents2()$maxlon)
 # output$link<-renderText((link%>%filter(Ecosystem_Subarea==input$region))$link)
  #textlink<-"https://coastwatch.pfeg.noaa.gov/erddap/griddap/nesdisVHNSQchlaWeekly.png?chlor_a%5B(last)%5D%5B(0.0)%5D%5B(62.006249999999994):(53.006249999999994)%5D%5B(-179.98125):(-156.01874999999998)%5D&.draw=surface&.vars=longitude%7Clatitude%7Cchlor_a&.colorBar=%7C%7C%7C%7C%7C&.bgColor=0xffccccff"
 viirs2<-reactive(viirs%>%filter(WATERS_COD=="FED" & depth>-200 & Ecosystem_Subarea==input$region)%>%group_by(date)%>%
                    summarise(chla=mean(chlorophyll, na.rm=T),
                              N=n()))
  output$chla_plot<-renderPlot({
   ggplot()+
     geom_line(data=viirs2(), aes(x=date, y=chla), size=2, color="light green")+
      geom_text(data=viirs2(), aes(x=date, y=chla, label=N))+
      xlab("")+ylab("chlorophyll-a (ug/L)")+
      theme_bw()+
      theme(axis.text = element_text(size=12),
            axis.title.y = element_text(size=16))
 }) 
}

  

shinyApp(ui = ui, server = server)


