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
            tabName = "about",
            mod_about_ui("about_1")
          )
        )
      ),

      # ----
      footer = bs4Dash::dashboardFooter(
        left = shiny::HTML(
          ".."
        ),
        right = shiny::HTML(
          ".."
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
      app_title = "zootraits"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}