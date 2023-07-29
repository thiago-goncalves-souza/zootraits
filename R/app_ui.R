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
            text = "Review Dataset",
            icon = icon("table"),
            startExpanded = TRUE,
            bs4Dash::bs4SidebarMenuSubItem(
              text = "Data Exploration",
              tabName = "review_data_exploration",
              icon = icon("magnifying-glass")
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              text = "Table",
              tabName = "review_data_exploration_table",
              icon = icon("table")
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              text = "Metadata",
              tabName = "review_metadata",
              icon = icon("file-lines")
            )
          ),
          bs4Dash::bs4SidebarMenuItem(
            text = "Open Traits Network",
            icon = icon("table"),
            startExpanded = TRUE,
            bs4Dash::bs4SidebarMenuSubItem(
              text = "About",
              tabName = "otn_about",
              icon = icon("table")
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              text = "Data Exploration",
              tabName = "otn_explore",
              icon = icon("magnifying-glass")
            )
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
            tabName = "review_data_exploration_table",
            mod_review_data_exploration_table_ui("review_data_exploration_table_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "review_metadata",
            mod_review_metadata_ui("review_metadata_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "otn_explore",
            mod_otn_explore_ui("otn_explore_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "otn_about",
            mod_otn_about_ui("otn_about_1")
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
          "<a href='https://onlinelibrary.wiley.com/doi/full/10.1002/ece3.10016' target='_blank'>Review Article</a>"
        ),
        left = shiny::HTML(
          "<a href='https://seas.umich.edu/globalchangebiology' target='_blank'><img src='www/logos/global-change-biology-logo.png' style='max-width: 20%;'></a>"
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
