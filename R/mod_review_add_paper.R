#' review_add_paper UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#'
#'
# review_data |>
# dplyr::glimpse()
# Rows: 4,435
# Columns: 16
# $ code               <dbl> 2, 2, 2, 2, 3, 3, 4, 4, 4, 5, 5, 5, 5, 5, 5, 8, 8,…
# $ year               <dbl> 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020, 20…
# $ reference          <chr> "Sánchez-Pérez et al., 2020, STOTEN", "Sánchez-Pér…
# $ doi                <chr> "https://doi.org/10.1016/j.scitotenv.2020.138989",…
# $ doi_html           <glue> "<a href='https://doi.org/10.1016/j.scitotenv.202…
# $ taxunit            <chr> "species", "species", "species", "species", "speci…
# $ taxon_span         <chr> "class", "class", "class", "class", "kingdom", "ki…
# $ taxon              <chr> "Pisces", "Pisces", "Pisces", "Pisces", "Zooplankt…
# $ taxonomic_group    <chr> "Pisces", "Pisces", "Pisces", "Pisces", "Protostom…
# $ ecosystem          <chr> "freshwater", "freshwater", "freshwater", "freshwa…
# $ study_scale        <fct> regional, regional, regional, regional, regional, …
# $ where              <chr> "Spain", "Spain", "Spain", "Spain", "Poland", "Pol…
# $ trait_type         <chr> "response", "response", "response", "response", "r…
# $ intraspecific_data <fct> no, no, no, no, no, no, no, no, no, no, no, no, no…
# $ trait_details      <chr> "Maximum length; Maximum age; Fecundity; Reproduct…
# $ trait_dimension    <chr> "trophic", "life_history", "habitat", "undetermine…

# shiny inputs
# function 	widget
# actionButton 	Action Button
# checkboxGroupInput 	A group of check boxes
# checkboxInput 	A single check box
# dateInput 	A calendar to aid date selection
# dateRangeInput 	A pair of calendars for selecting a date range
# fileInput 	A file upload control wizard
# helpText 	Help text that can be added to an input form
# numericInput 	A field to enter numbers
# radioButtons 	A set of radio buttons
# selectInput 	A box with choices to select from
# sliderInput 	A slider bar
# submitButton 	A submit button
# textInput 	A field to enter text



mod_review_add_paper_ui <- function(id) {
  ns <- NS(id)
  tagList(
    bs4Dash::box(
      title = "Contribute to the Review",
      collapsible = FALSE,
      width = 12,
      shiny::tags$p(
        htmltools::includeMarkdown(app_sys("app/www/md/add-paper.md"))
      )
    ),
    bs4Dash::box(
      title = "Paper metadata",
      collapsible = FALSE,
      width = 12,
      fluidRow(
        column(
          width = 12,
          textInput(
            inputId = ns("paper_title"),
            label = shiny::HTML("Title <br> <small> (e.g. 'Functional response of fish assemblage to multiple stressors in a highly regulated Mediterranean river system') </small> "),
            value = ""
          )
        )),
        fluidRow(
        column(
          width = 12,
          textInput(
            inputId = ns("paper_doi"),
            label = shiny::HTML("DOI <br> <small> (e.g. 'https://doi.org/10.1016/j.scitotenv.2020.138989') </small> "),
            value = "https://doi.org/"
          )
        )),
        fluidRow(
        column(
          width = 12,
          textInput(
            inputId = ns("paper_url"),
            label = shiny::HTML("Alternative URL <br> <small> (e.g. 'https://www.sciencedirect.com/science/article/abs/pii/S0048969720325067') </small> "),
            value = ""
          )
        )
      ),
      fluidRow(
        column(
          width = 4,
          textInput(
            inputId = ns("paper_author"),
            label = shiny::HTML("Authors <br> <small> (e.g. '..') </small> "),
            value = ""
          )
        ),
        column(
          width = 4,
          textInput(
            inputId = ns("paper_journal"),
            label = shiny::HTML("Journal Name <br> <small> (e.g. 'Science of The Total Environment') </small> "),
            value = ""
          )
        ),
        column(
          width = 4,
          numericInput(
            inputId = ns("paper_year"),
            label = shiny::HTML("Year <br> <small> (e.g. '2020') </small> "),
            value = 2021,
            min = 1900,
            max = lubridate::year(Sys.Date())
          )
        ),
      )
    ),
    bs4Dash::box(
      title = "Information about the study",
      collapsible = FALSE,
      width = 12,
      fluidRow(
        picker_input(
          inputId = ns("study_scale"),
          label = "Study Scale",
          choices = options_input(review_data$study_scale),
          selected = options_input(review_data$study_scale)[1],
          multiple = FALSE
        ),
        picker_input(
          inputId = ns("ecosystem"),
          label = "Ecosystem",
          choices = options_input(review_data$ecosystem),
          selected = options_input(review_data$ecosystem)[1],
          multiple = FALSE
        ),
        picker_input(
          inputId = ns("where"),
          label = "Where",
          choices = options_input(review_data$where),
          selected = options_input(review_data$where)[1],
          multiple = FALSE
        )
      ),
      fluidRow(
        picker_input(
          inputId = ns("taxon_span"),
          label = "Taxon span",
          choices = options_input(review_data$taxon_span),
          selected = options_input(review_data$taxon_span)[1],
          multiple = FALSE
        ),
        picker_input(
          inputId = ns("taxonomic_unit"),
          label = "Taxonomic unit",
          choices = options_input(review_data$taxunit),
          selected = options_input(review_data$taxunit)[1],
          multiple = FALSE
        ),
        picker_input(
          inputId = ns("taxonomic_group"),
          label = "Taxonomic group",
          choices = options_input(review_data$taxonomic_group),
          selected = options_input(review_data$taxonomic_group)[1],
          multiple = FALSE
        )
      )
    ),
    bs4Dash::box(
      title = "Information about the study - Location",
      collapsible = FALSE,
      width = 12,
      fluidRow(
        column(
          width = 6,
          textInput(
            inputId = ns("latitude"),
            label = shiny::HTML("Latitude (in Decimal Degrees) <br> <small> (e.g. '-28.164997') </small> "),
            value = ""
          )
        ),
        column(
          width = 6,
          textInput(
            inputId = ns("longitude"),
            label = shiny::HTML("Longitude (in Decimal Degrees) <br> <small> (e.g. '-20.390625') </small> "),
            value = ""
          )
        )
      ),
      fluidRow(
        shiny::HTML("You can use &nbsp; <b><a href='https://www.latlong.net/' target='_blank'> this website </a></b> &nbsp; to convert the latitude and longitude of the study site to decimals degrees.")
      )
    ),
    bs4Dash::box(
      title = "Information about the study - Traits",
      collapsible = FALSE,
      width = 12,
      fluidRow(
        picker_input(
          inputId = ns("trait_type"),
          label = "Trait type",
          choices = options_input(review_data$trait_type),
          selected = options_input(review_data$trait_type)[1],
          multiple = TRUE
        ),
        picker_input(
          inputId = ns("intraspecific_data"),
          label = "Intraspecific data",
          choices = options_input(review_data$intraspecific_data),
          selected = options_input(review_data$intraspecific_data)[1],
          multiple = TRUE
        ),
        picker_input(
          inputId = ns("trait_dimension"),
          label = "Trait dimension",
          choices = options_input(review_data$trait_dimension),
          selected = options_input(review_data$trait_dimension)[1],
          multiple = TRUE
        )
      ),
      fluidRow(
        picker_input(
          inputId = ns("trait_details"),
          label = "Trait details",
          choices = options_input(trait_information$trait_details),
          selected = options_input(trait_information$trait_details)[1],
          multiple = TRUE, search = TRUE,
          width = 12
        )
      ),
      fluidRow(
        column(
          width = 12,
          textInput(
            inputId = ns("trait_details_other"),
            label = shiny::HTML("Other trait details <br> <small> If there is any other trait not listed in the filter above, write it here: </small> "),
            value = "",
            width = "100%"
          )
        )
      )
    ),
    bs4Dash::box(
      title = "Information about you (contributer)",
      collapsible = FALSE,
      width = 12,
      fluidRow(
        textInput(
          inputId = ns("your_name"),
          label = "Your name",
          value = "",
          width = "100%"
        )
      ),
      fluidRow(
        textInput(
          inputId = ns("your_email"),
          label = "Your email",
          value = "",
          width = "100%"
        )
      ),
      fluidRow(
        textInput(
          inputId = ns("your_affiliation"),
          label = "Your affiliation",
          value = "",
          width = "100%"
        )
      ),
      fluidRow(
        textInput(
          inputId = ns("your_orcid"),
          label = "Your ORCID ID",
          value = "https://orcid.org/0000-0000-0000-0000",
          width = "100%"
        )
      )
    ),
    bs4Dash::box(
      title = "Review your suggestion",
      collapsible = FALSE,
      width = 12,
      "TO DO!"
    ),
    bs4Dash::box(
      title = "Submit your suggestion",
      collapsible = FALSE,
      width = 12,
      div(
        style = "content-align: center; display: flex;",
        shiny::actionButton(
          # TO DO: center the button
          inputId = ns("send_suggestion"),
          label = "Send suggestion",
          icon = shiny::icon("plus"),
          width = "20%"
        )
      )
    )
  )
}

#' review_add_paper Server Functions
#'
#' @noRd
mod_review_add_paper_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
  })
}

## To be copied in the UI
# mod_review_add_paper_ui("review_add_paper_1")

## To be copied in the server
# mod_review_add_paper_server("review_add_paper_1")
