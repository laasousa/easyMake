#' graph_dependencies
#'
#' @param files A character vector of filenames within the project,
#' for instance one produced by list.files(recursive = TRUE)
#' @param dependencies A dataframe containing the edge list of dependencies
#' between files. This is the same file which is passed to easy_make(). The
#' dataframe should have two fields "file" and "pre_req" showing the file
#' and its immediate pre-requisite respectively. If a file has multiple
#' pre-requisites, list each dependency as a separate line in the dataframe.
#'
#' @return A DiagrammeR plot showing the dependency graph.
#' @export
#'
#' @examples
#'
#' filelist <-  c("analysis/file1.R", "analysis/file2.R", "analysis/markdown.Rmd",
#' "dep.RData", "Makefile", "maker.Rproj", "man/hello.Rd",
#' "mtcars.csv", "mtcars.RData", "output.txt", "R/dep_graph.R",
#' "R/hello.R", "R/make_maker.R")
#'
#' dependencies <- dplyr::data_frame(
#' file    = c("analysis/file2.R", "analysis/markdown.Rmd", "mtcars.csv",
#' 						"mtcars.RData", "analysis/file2.R"),
#' pre_req = c("mtcars.csv", "mtcars.RData", "analysis/file1.R",
#' 					"analysis/file2.R", "R/hello.R"))
#' graph_dependencies(dependencies, filelist)
#'
graph_dependencies <- function(dependencies, files = list.files(recursive = TRUE)){

	file_df <- data.frame(files, stringsAsFactors = FALSE)
	file_df$type <- tools::file_ext(file_df$files)
	file_df$shape <- ifelse(file_df$type %in% c("R", "Rmd"), "circle", "square")

	nodes <-
		DiagrammeR::create_nodes(nodes = file_df$files,
														 shape = file_df$shape)

	edges <-
		DiagrammeR::create_edges(from = dependencies$pre_req,
														 to = dependencies$file,
														 relationship = "leading to")

	graph <-
		DiagrammeR::create_graph(nodes_df = nodes,
														 edges_df = edges,
														 graph_attrs = "layout = circo")

	DiagrammeR::render_graph(graph)
}


