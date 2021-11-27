## Import final model object
final.model <- readRDS("derived_objects/final_model.rds")

## Save Diagnostic Plots
png(filename="figures/diagnostic_plots.png") ## Save the figure
par(mfrow =c(1, 4))

plot(final.model, cex=1.5, cex.title=0.5, cex.label=0.7)
