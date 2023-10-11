library(ggplot2)
library(jsonlite)

data <- as.numeric(jsonlite::read_json("../../saves/estimation_errors.json"))
df <- data.frame(
  id = c(1:length(data)),
  error = data
)

ggplot(df) +
 aes(x = id, y = error) +
 geom_point(shape = "circle", size = 1.5, colour = "#112446") +
 labs(x = "Dataset id", y = "Error") +
 theme_minimal() +
 theme(axis.title.y = element_text(size = 12L), 
 axis.title.x = element_text(size = 12L))
