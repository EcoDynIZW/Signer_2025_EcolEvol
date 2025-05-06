## Script to Render All Quarto Documents and Copy the Reports to ./docs/reports/
## WARNING: LINE 44 REMOVES ALL EXISTING HTML REPORTS!

library(quarto)
library(fs)
library(stringr)
library(purrr)
library(here)

src <- here("R")
out <- here("docs", "reports")

render_report <- function(input_file, input_dir = src, output_dir = out, ...) {
  # render the input document to the current working directory
  quarto::quarto_render(input = paste0(input_dir, "/", input_file), output_format = "html", ...)
  
  # name of the rendered output file
  output_name <- stringr::str_remove(input_file, '.qmd')
  
  # move the file to the output path
  dir_files <- paste0(input_dir, "/", output_name, "_files")
  dir_cache <- paste0(input_dir, "/", output_name, "_cache")
  
  if (file.exists(dir_files)) fs::file_move(dir_files, output_dir)
  if (file.exists(dir_cache)) fs::file_move(dir_cache, output_dir)
  fs::file_move(paste0(input_dir, "/", output_name, ".html"), output_dir)
  
  msg <- paste0(output_name, ".html moved to ", output_dir)
  message(msg)
}

## files to render
qmds <- list.files(path = src, pattern = ".qmd$")


## render single report --------------------------------------------------------

# render_report(qmds[4])


## render all reports ----------------------------------------------------------

## WARNING: THIS PART REMOVES ALL EXISTING HTML REPORTS!
unlink(out, recursive = TRUE)
dir.create(out)
## WARNING: THIS PART REMOVES ALL EXISTING OUTPUTS!
#unlink(here("output", "simulated"), recursive = TRUE)
#unlink(here("output", "empirical"), recursive = TRUE)
walk(qmds, ~render_report(.x))
