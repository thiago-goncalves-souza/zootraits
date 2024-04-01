#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    bs4Dash::dashboardPage(
      scrollToTop = TRUE,
      help = NULL,
      dark = NULL,

      # ---
      header = bs4Dash::dashboardHeader(
        title = "ZooTraits",
        fixed = FALSE
      ),

      # ----
      sidebar = bs4Dash::dashboardSidebar(
        skin = "light",
        title = "ZooTraits",
        bs4Dash::bs4SidebarMenu(
          bs4Dash::bs4SidebarMenuItem(
            text = "Home",
            tabName = "homepage",
            icon = icon("home")
          ),
          bs4Dash::bs4SidebarMenuItem(
            text = "ExploreTrait",
            icon = icon("table"),
            startExpanded = TRUE,
            bs4Dash::bs4SidebarMenuSubItem(
              text = "Data Exploration",
              tabName = "review_data_exploration",
              icon = icon("magnifying-glass")
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              text = "Metadata",
              tabName = "review_metadata",
              icon = icon("file-lines")
            )
          ),
          bs4Dash::bs4SidebarMenuItem(
            text = "FeedTrait",
            tabName = "review_add_paper",
            icon = icon("folder-plus")
          ),
          bs4Dash::bs4SidebarMenuItem(
            text = "GetTrait",
            icon = icon("table"),
            tabName = "get_trait"
          ),
          bs4Dash::bs4SidebarMenuItem(
            text = "About",
            tabName = "about",
            icon = icon("book-open")
          )
        )
      ),

      # ----
      body = bs4Dash::dashboardBody(
        fresh::use_theme(create_theme_css()),
        bs4Dash::bs4TabItems(
          bs4Dash::bs4TabItem(
            tabName = "homepage",
            mod_homepage_ui("homepage_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "review_data_exploration",
            mod_review_data_exploration_ui("review_data_exploration_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "review_metadata",
            mod_review_metadata_ui("review_metadata_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "review_add_paper",
            mod_review_add_paper_ui("review_add_paper_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "get_trait",
            mod_get_trait_ui("mod_get_trait_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "about",
            mod_about_ui("about_1")
          )
        )
      ),

      # ----
      footer = bs4Dash::dashboardFooter(
        right = shiny::HTML(
          '<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" style="max-width: 20%;" /></a>.'
        ),
        left = shiny::HTML(
          "<a href='https://seas.umich.edu/globalchangebiology' target='_blank'><img src='www/logos/global-change-biology-logo.png' style='max-width: 30%;'></a>"
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "ZooTraits"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
