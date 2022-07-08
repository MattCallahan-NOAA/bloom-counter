#load packages
library(shiny)
library(tidyverse)
library(lubridate)

#define ecosystem subregions
subregions<-c("Southeastern Bering Sea", 
  "Northern Bering Sea", 
  "Western Gulf of Alaska", 
  "Eastern Gulf of Alaska",
  "Western Aleutians",
  "Central Aleutians",
  "Eastern Aleutians")

#df with links for each region
link_df<-readRDS("Data/links.RDS")

#current year
current_year<-year(Sys.Date())

#load latest virrs
viirs2022<-readRDS("Data/viirs_2022_avg.RDS")%>%
  mutate(date=as.Date(paste(current_year, week, 1, sep="-"), "%Y-%U-%u"))
#load old viirs
viirsold<-readRDS("Data/viirs_old_av.RDS")%>%
  mutate(date=as.Date(paste(current_year, week, 1, sep="-"), "%Y-%U-%u"))

#define UI
ui <- fluidPage(

  titlePanel("Alaska chlorophyll bloom counter"),
          
            
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
                 #map of esr regions
                 img(src='esr_map_depth_filters.png', width="450", height="275")
               ),
               mainPanel(
                 #description
                 tags$blockquote("Weekly VIIRS chlorophyll-a concentration averages for each ecosystem status report (ESR) region. Green is 2022, red is 2013-2021 average. Dotted lines are annual standard deviations. Data were limited to federal waters (>=3mi offshore). In the GOA and BS a -10 to -200m depth filter was applied. Aleutian waters were not constrained by depth. Data are derived from the VIIRS weekly 4k product and obtained from coastwatch https://coastwatch.pfeg.noaa.gov/erddap/griddap/nesdisVHNSQchlaWeekly.html. Code at https://github.com/MattCallahan-NOAA/bloom-counter. Contact matt.callahan@noaa.gov with questions"),
                 #chla time series
                     plotOutput(outputId ="chla_plot"),
                     
                 #
                 tags$blockquote("Latest VIIRS chlorophyll concentrations directly from coastwatch"),
                     #embeded web link
                     htmlOutput(outputId="web")
             
               )  
             )

)
              
#define server
server <- function(input, output) {
  #
  #output$selected_region<- renderText({input$region})

  #url for web view
  test_url <- reactive({
    req(input$region)
    
    
    isolate((filter(link_df, Ecosystem_Subarea==input$region)$link))
  })
  
  output$web <- renderUI({
    tags$img(id = "web", src = test_url(), height =650, width =500)
    
  })
  
  #plot
  #filter data
 viirs_1<-reactive(viirs2022%>%filter(Ecosystem_Subarea==input$region))
 viirs_2<-reactive(viirsold%>%filter(Ecosystem_Subarea==input$region))
 
 
 #plot
  output$chla_plot<-renderPlot({
   ggplot()+
      geom_line(data=viirs_2(), aes(x=date, y=chlorophyll), size=1, color="red")+
      geom_line(data=viirs_2(), aes(x=date, y=chlorophyll-stdev), size=1, lty=2, color="red")+
      geom_line(data=viirs_2(), aes(x=date, y=chlorophyll+stdev), size=1, lty=2, color="red")+
     geom_line(data=viirs_1(), aes(x=date, y=chlorophyll), size=2, color="light green")+
     # geom_text(data=viirs_1(), aes(x=week, y=chlorophyll, label=n))+
      xlab("")+ylab("chlorophyll-a (mg/L)")+
      theme_bw()+
      theme(axis.text = element_text(size=12),
            axis.title = element_text(size=16))
 }) 
}

  

shinyApp(ui = ui, server = server)


