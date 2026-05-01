# Internal package hooks.

#' @importFrom utils packageVersion
.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "stern ", utils::packageVersion("stern"), " loaded.\n",
    "  - Call stern_setup_fonts() once before plotting.\n",
    "  - Categorical: scale_color_stern_cat() / scale_fill_stern_cat()\n",
    "  - Sequential:  scale_color_stern_seq() / scale_fill_stern_seq()\n",
    "  - Diverging:   scale_color_stern_div() / scale_fill_stern_div()\n",
    "  - Theme:       theme_stern() + theme_stern_vertical() / theme_stern_map()\n",
    "  - Text on fill: stern_text_on_seq() / stern_text_on_div()"
  )
}
