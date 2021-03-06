library(shiny)

# Define server logic required 
shinyServer(function(input, output) {
    
    tunisia <- read_csv("tunisia.csv")
    
    # year function
    filter_years <- reactive({
        tunisia %>% 
            filter(year >= input$years[1],
                   year <= input$years[2])
    })
    
    # gdp plot
    output$gdpPlot <- plotly::renderPlotly({
        
        tunisia_filtered <- filter_years()
        
        tunisia_filtered %>% 
            # filter(year != 2008) %>% 
            ggplot(aes(year, growth_rate_of_the_real_gross_domestic_product_gdp, group = 1)) +
            geom_line() +
            labs(title = "Growth Rate of the GDP, Tunisia",
                 x = "",
                 y = "Growth Rate (%)")
    })
    
    # shares plot
    output$sharesPlot <- plotly::renderPlotly({
        
        tunisia_filtered <- filter_years()
        
        tunisia_filtered %>%  
            select(year, agriculture, industry, services) %>% 
            pivot_longer(-year,
                         names_to = "sector",
                         values_to = "gdp_share") %>% 
            filter(sector %in% input$sectors) %>% 
            ggplot(aes(year, gdp_share, fill = sector)) +
            geom_col() +
            labs(title = "Growth Rate of the GDP, Tunisia",
                 x = "",
                 y = "Growth Rate (%)")
    })
    
    # percentages table
    output$percentTable <- DT::renderDataTable({
        
        DT::datatable(
            tunisia %>% select(year, contains("_percent")),
            rownames = FALSE,
            colnames = c("Year", 
                         "Population Growth (%)", 
                         "Infant Mortality Rate",
                         "Unemployment Rate",
                         "Inflation Rate",
                         "Fertility Rate"),
            filter = "top"
        )
    })
})
