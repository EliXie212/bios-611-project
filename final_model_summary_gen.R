library(tinytex)
library(texreg)

final.model <- readRDS("derived_objects/final_model.rds")

out <- texreg(final.model,
       caption="Final Model Summary",
       model.names="Final model")
cat("Final Model Summary",
    out,
    file="derived_docs/summary_of_final_model.tex")
