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


mod_review_add_paper_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      bs4Dash::box(
        title = "FeedTrait - Contribute to the Review",
        collapsible = FALSE,
        width = 12,
        shiny::tags$p(
          htmltools::includeMarkdown(app_sys("app/www/md/add-paper.md"))
        )
      )
    ),
    fluidRow(
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
          )
        ),
        fluidRow(
          column(
            width = 12,
            textInput(
              inputId = ns("paper_doi"),
              label = shiny::HTML("DOI <br> <small> (e.g. 'https://doi.org/10.1016/j.scitotenv.2020.138989') </small> "),
              value = "https://doi.org/"
            )
          )
        ),
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
              label = shiny::HTML("Authors <br> <small> (e.g. 'Sánchez-Pérez et al.') </small> "),
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
      )
    ),
    fluidRow(
      bs4Dash::box(
        title = "Information about the study",
        collapsible = FALSE,
        width = 12,
        fluidRow(
          picker_input(
            inputId = ns("where"),
            label = "Where",
            choices = options_input(review_data$where, option_none = TRUE),
            selected = "None",
            multiple = TRUE
          ),
          picker_input(
            inputId = ns("study_scale"),
            label = "Study Scale",
            choices = options_input(review_data$study_scale, option_none = TRUE),
            selected = "None",
            multiple = FALSE
          ),
          picker_input(
            inputId = ns("ecosystem"),
            label = "Ecosystem",
            choices = options_input(review_data$ecosystem, option_none = TRUE),
            selected = "None",
            multiple = FALSE
          )
        ),
        fluidRow(
          picker_input(
            inputId = ns("taxon_span"),
            label = "Taxon span",
            choices = options_input(review_data$taxon_span, option_none = TRUE),
            selected = "None",
            multiple = FALSE
          ),
          picker_input(
            inputId = ns("taxonomic_unit"),
            label = "Taxonomic unit",
            choices = options_input(review_data$taxunit, option_none = TRUE),
            selected = "None",
            multiple = FALSE
          ),
          picker_input(
            inputId = ns("taxonomic_group"),
            label = "Taxonomic group",
            choices = options_input(review_data$taxonomic_group, option_none = TRUE),
            selected = "None",
            multiple = FALSE
          )
        )
      )
    ),
    fluidRow(
      bs4Dash::box(
        title = "Information about the study - Approximate Location",
        collapsible = FALSE,
        width = 12,
        fluidRow(
          column(
            width = 6,
            sliderInput(
              inputId = ns("latitude"),
              label = shiny::HTML("Latitude (in Decimal Degrees) <br> <small> (e.g. '-28.1') </small> "),
              value = 0, min = -90, max = 90, step = 0.1
            )
          ),
          column(
            width = 6,
            sliderInput(
              inputId = ns("longitude"),
              label = shiny::HTML("Longitude (in Decimal Degrees) <br> <small> (e.g. '-20.3') </small> "),
              value = 0, min = -180, max = 180, step = 0.1
            )
          )
        ),
        fluidRow(
          shiny::HTML("You can use &nbsp; <b><a href='https://www.latlong.net/' target='_blank'> this website </a></b> &nbsp; to convert the latitude and longitude of the study site to decimals degrees.")
        ),
        br(),
        fluidRow(strong("Preview study location:")),
        fluidRow(
          leaflet::leafletOutput(ns("study_location")),
        )
      )
    ),
    fluidRow(
      bs4Dash::box(
        title = "Information about the study - Traits",
        collapsible = FALSE,
        width = 12,
        fluidRow(
          picker_input(
            inputId = ns("trait_type"),
            label = "Trait type",
            choices = options_input(review_data$trait_type, option_none = TRUE),
            selected = "None",
            multiple = FALSE
          ),
          picker_input(
            inputId = ns("intraspecific_data"),
            label = "Intraspecific data",
            choices = options_input(review_data$intraspecific_data, option_none = TRUE),
            selected = "None",
            multiple = FALSE
          ),
          picker_input(
            inputId = ns("trait_dimension"),
            label = "Trait dimension",
            choices = options_input(review_data$trait_dimension, option_none = TRUE),
            selected = "None",
            multiple = TRUE
          )
        ),
        fluidRow(
          picker_input(
            inputId = ns("trait_details"),
            label = "Trait details",
            choices = options_input(trait_information$trait_details, option_none = TRUE),
            selected = "None",
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
      )
    ),
    fluidRow(
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
      )
    ),
    fluidRow(
      bs4Dash::box(
        title = "Review your suggestion",
        collapsible = FALSE,
        width = 12,
        br(),
        shiny::h5("Paper metadata"),
        reactable::reactableOutput(outputId = ns("paper_metadata_table_responses")),
        br(), br(),
        shiny::h5("Information about the study"),
        reactable::reactableOutput(outputId = ns("paper_study_table_responses")),
        br(), br(),
        shiny::h5("Information about the study - Location"),
        reactable::reactableOutput(ns("paper_study_location_responses")),
        br(), br(),
        shiny::h5("Information about the study - Traits"),
        reactable::reactableOutput(ns("paper_study_traits_responses")),
        br(), br(),
        shiny::h5("Information about you (contributer)"),
        reactable::reactableOutput(
          outputId = ns("contributor_table_responses")
        )
      )
    ),
    fluidRow(
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
  )
}

#' review_add_paper Server Functions
#'
#' @noRd
mod_review_add_paper_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Create an InputValidator object
    input_validator <- shinyvalidate::InputValidator$new()

    # Add validation rules
    input_validator$add_rule("paper_title", shinyvalidate::sv_required())
    input_validator$add_rule("paper_doi", shinyvalidate::sv_required())
    input_validator$add_rule("paper_url", shinyvalidate::sv_required())
    input_validator$add_rule("paper_author", shinyvalidate::sv_required())
    input_validator$add_rule("paper_journal", shinyvalidate::sv_required())
    input_validator$add_rule("paper_year", shinyvalidate::sv_required())
    input_validator$add_rule("study_scale", shinyvalidate::sv_required())
    input_validator$add_rule("ecosystem", shinyvalidate::sv_required())
    input_validator$add_rule("where", shinyvalidate::sv_required())
    input_validator$add_rule("taxon_span", shinyvalidate::sv_required())
    input_validator$add_rule("taxonomic_unit", shinyvalidate::sv_required())
    input_validator$add_rule("taxonomic_group", shinyvalidate::sv_required())
    input_validator$add_rule("latitude", shinyvalidate::sv_required())
    input_validator$add_rule("longitude", shinyvalidate::sv_required())
    input_validator$add_rule("trait_type", shinyvalidate::sv_required())
    input_validator$add_rule("intraspecific_data", shinyvalidate::sv_required())
    input_validator$add_rule("trait_dimension", shinyvalidate::sv_required())
    input_validator$add_rule("trait_details", shinyvalidate::sv_required())
    input_validator$add_rule("your_name", shinyvalidate::sv_required())
    input_validator$add_rule("your_email", shinyvalidate::sv_required())
    input_validator$add_rule("your_affiliation", shinyvalidate::sv_required())
    input_validator$add_rule("your_orcid", shinyvalidate::sv_required())


    input_validator$add_rule("latitude", shinyvalidate::sv_numeric())
    input_validator$add_rule("longitude", shinyvalidate::sv_numeric())

    input_validator$add_rule("your_email", shinyvalidate::sv_email())

    input_validator$add_rule("your_orcid", shinyvalidate::sv_url())

    input_validator$add_rule("paper_doi", shinyvalidate::sv_url())

    input_validator$add_rule("paper_url", shinyvalidate::sv_url())

    # Start displaying errors in the UI
    input_validator$enable()

    contributor_responses <- reactive({
      tibble::tibble(
        contributor_name = input$your_name,
        contributor_email = input$your_email,
        contributor_affiliation = input$your_affiliation,
        contributor_orcid = input$your_orcid
      )
    })

    output$contributor_table_responses <- reactable::renderReactable({
      contributor_responses() |>
        reactable::reactable(
          columns = list(
            contributor_name = reactable::colDef(name = "Name"),
            contributor_email = reactable::colDef(name = "Email"),
            contributor_affiliation = reactable::colDef(name = "Affiliation"),
            contributor_orcid = reactable::colDef(name = "ORCID")
          )
        )
    })

    paper_responses <- reactive({
      tibble::tibble(
        paper_title = input$paper_title,
        paper_doi = input$paper_doi,
        paper_url = input$paper_url,
        paper_author = input$paper_author,
        paper_journal = input$paper_journal,
        paper_year = input$paper_year,
        study_scale = input$study_scale,
        ecosystem = input$ecosystem,
        where = paste0(input$where, collapse = "; "),
        taxon_span = input$taxon_span,
        taxonomic_unit = input$taxonomic_unit,
        taxonomic_group = input$taxonomic_group,
        latitude = input$latitude,
        longitude = input$longitude,
        trait_type = input$trait_type,
        intraspecific_data = input$intraspecific_data,
        trait_dimension = paste0(input$trait_dimension, collapse = "; "),
        trait_details = paste0(input$trait_details, collapse = "; "),
        trait_details_other = input$trait_details_other
      )
    })


    output$paper_metadata_table_responses <- reactable::renderReactable({
      paper_responses() |>
        dplyr::select(paper_title:paper_year) |>
        reactable::reactable(
          columns = list(
            paper_title = reactable::colDef(name = "Title"),
            paper_doi = reactable::colDef(name = "DOI"),
            paper_url = reactable::colDef(name = "URL"),
            paper_author = reactable::colDef(name = "Author"),
            paper_journal = reactable::colDef(name = "Journal"),
            paper_year = reactable::colDef(name = "Year")
          )
        )
    })


    output$paper_study_table_responses <- reactable::renderReactable({
      paper_responses() |>
        dplyr::select(study_scale:taxonomic_group) |>
        reactable::reactable(
          columns = list(
            study_scale = reactable::colDef(name = "Study Scale"),
            ecosystem = reactable::colDef(name = "Ecosystem"),
            where = reactable::colDef(name = "Where"),
            taxon_span = reactable::colDef(name = "Taxon span"),
            taxonomic_unit = reactable::colDef(name = "Taxonomic unit"),
            taxonomic_group = reactable::colDef(name = "Taxonomic group")
          )
        )
    })

    output$paper_study_traits_responses <- reactable::renderReactable({
      paper_responses() |>
        dplyr::select(trait_type:trait_details_other) |>
        reactable::reactable(
          columns = list(
            trait_type = reactable::colDef(name = "Trait type"),
            intraspecific_data = reactable::colDef(name = "Intraspecific data"),
            trait_dimension = reactable::colDef(name = "Trait dimension"),
            trait_details = reactable::colDef(name = "Trait details"),
            trait_details_other = reactable::colDef(name = "Other trait details")
          )
        )
    })


    lat_lon <- reactive({
      tibble::tibble(
        lng = input$longitude,
        lat = input$latitude
      )
    })

    output$study_location <- leaflet::renderLeaflet({
      lat_lon() |>
        leaflet::leaflet() |>
        leaflet::setView(lng = 0, lat = 0, zoom = 2) |>
        leaflet::addProviderTiles(
          "Esri.WorldImagery",
          group = "ESRI World Imagery"
        ) |>
        leaflet::addMarkers(
          lng = ~lng,
          lat = ~lat
        )
    })

    output$paper_study_location_responses <- reactable::renderReactable({
      lat_lon() |>
        reactable::reactable(
          columns = list(
            lng = reactable::colDef(name = "Longitude"),
            lat = reactable::colDef(name = "Latitude")
          )
        )
    })

    observeEvent(input$send_suggestion, {
      # 4. Don't proceed if any input is invalid

      if (input_validator$is_valid()) {
        # 5. If all inputs are valid, proceed

        # generating an id to be used in the code column
        sys_time <- Sys.time()
        date_time_text <- stringr::str_extract_all(sys_time, pattern = "(\\d)+") |>
          unlist() |>
          paste0(collapse = "")

        code <- paste0("c_", date_time_text, collapse = "")

        paper_to_add <- paper_responses() |>
          dplyr::mutate(
            date_time = sys_time,
            contributor_email = input$your_email
          ) |>
          dplyr::mutate(
            verified = FALSE,
            code = code,
            .before = tidyselect::everything()
          )

        contributor_to_add <- contributor_responses() |>
          dplyr::mutate(date_time = sys_time) |>
          dplyr::mutate(
            code = code,
            .before = tidyselect::everything()
          )

        googlesheets4::sheet_append(
          ss = "1nStfAOwUvUuVC4Xo3ArI8i1Be9TxGNdmntfn87OGSy4",
          data = paper_to_add,
          sheet = "papers"
        )

        googlesheets4::sheet_append(
          ss = "1nStfAOwUvUuVC4Xo3ArI8i1Be9TxGNdmntfn87OGSy4",
          data = contributor_to_add,
          sheet = "contributors"
        )

        shinyalert::shinyalert(
          title = "Suggestion sent!",
          text = "Thank you for your contribution. The Zootraits team will review your suggestion.",
          size = "s",
          closeOnEsc = TRUE,
          closeOnClickOutside = FALSE,
          html = TRUE,
          type = "success",
          showConfirmButton = TRUE,
          showCancelButton = FALSE,
          confirmButtonText = "OK",
          confirmButtonCol = "#AEDEF4",
          timer = 0,
          imageUrl = "",
          animation = TRUE
        )
      } else {
        showNotification(
          "Please fix the errors in the form before continuing",
          type = "warning"
        )
      }
    })
  })
}

## To be copied in the UI
# mod_review_add_paper_ui("review_add_paper_1")

## To be copied in the server
# mod_review_add_paper_server("review_add_paper_1")
