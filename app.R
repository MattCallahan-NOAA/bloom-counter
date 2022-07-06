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
link<-readRDS("Data/links.RDS")
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
                         textOutput(outputId="link"),
                         img(src=paste(textOutput(outputId="link")))
                       #  img(src="https://coastwatch.pfeg.noaa.gov/erddap/griddap/nesdisVHNSQchlaWeekly.png?chlor_a%5B(last)%5D%5B(0.0)%5D%5B(62.006249999999994):(53.006249999999994)%5D%5B(-179.98125):(-156.01874999999998)%5D&.draw=surface&.vars=longitude%7Clatitude%7Cchlor_a&.colorBar=%7C%7C%7C%7C%7C&.bgColor=0xffccccff")
                      #   img(src=paste0("https://coastwatch.pfeg.noaa.gov/erddap/griddap/nesdisVHNSQchlaWeekly.png?chlor_a%5B(last)%5D%5B(0.0)%5D%5B(",
                      #                 as.character(textOutput(outputId="maxlat")),
                      #                  "):(",
                      #                  as.character(textOutput(outputId="minlat")),
                      #                  ")%5D%5B(",
                      #                  as.character(textOutput(outputId="minlon")),
                      #                 "):(",
                      #                  as.character(textOutput(outputId="maxlon")),
                      #                  ")%5D&.draw=surface&.vars=longitude%7Clatitude%7Cchlor_a&.colorBar=%7C%7C%7C%7C%7C&.bgColor=0xffccccff")
               
              
             
               )  
             )

)
              
#define server
server <- function(input, output) {
  #
  output$selected_region<- renderText({input$region})
  #output$minlat<-renderText(as.numeric((extents%>%filter(Ecosystem_Subarea==input$region))$minlat))
  #output$maxlat<-renderText(as.numeric((extents%>%filter(Ecosystem_Subarea==input$region))$maxlat))
  #output$minlon<-renderText(as.numeric((extents%>%filter(Ecosystem_Subarea==input$region))$minon))
  #output$minlon<-renderText(as.numeric((extents%>%filter(Ecosystem_Subarea==input$region))$maxlon))
  output$link<-renderText((link%>%filter(Ecosystem_Subarea==input$region))$link)
  
  
}

  

shinyApp(ui = ui, server = server)
