.PHONY: clean
.PHONY: shiny_app
.PHONY: dash_app
# SHELL: /bin/bash

### Clean existing datasets, figures or reports generated in this Makefile for builing
clean:
	rm -f derived_data/*.csv
	rm -f figures/*.png
	rm -f heart_disease_report.pdf
	rm -f derived_docs/*

### Report Generation
heart_disease_report.pdf:\
heart_disease_report.tex\
figures/corrgram.png\
figures/roc.png\
derived_docs/summary_of_final_model.tex\
figures/diagnostic_plots.png\
figures/mallow_roc.png\
figures/adjrsq_roc.png\
figures/lasso_roc.png\
figures/tree_roc.png
	pdflatex heart_disease_report.tex

### Data Requirements
## Train, Val, Test data
derived_data/train_dat.csv\
derived_data/val_dat.csv\
derived_data/test_dat.csv\
derived_data/train_val_dat.csv:\
train_val_gen.R\
source_data/heart.csv
	Rscript train_val_gen.R


### Generate Corrgram
figures/corrgram.png:\
derived_data/train_dat.csv\
corrgram_gen.R
	Rscript corrgram_gen.R

## Generate Final Model Object
derived_objects/final_model.rds:\
source_data/heart.csv\
derived_data/train_dat.csv\
final_model_summary_gen.R
	Rscript final_model_summary_gen.R

### Generate Corrgram
figures/roc.png:\
derived_objects/final_model.rds\
derived_data/val_dat.csv\
derived_data/train_val_dat.csv\
derived_data/test_dat.csv\
roc_gen.R
	Rscript roc_gen.R

## Generate Final Model summary
derived_docs/summary_of_final_model.tex:\
derived_objects/final_model.rds\
final_model_summary_gen.R
	Rscript final_model_summary_gen.R

## Generate Final Model Diagnostic Plots
figures/diagnostic_plots.png:\
derived_objects/final_model.rds\
diagnostic_plots_gen.R
	Rscript diagnostic_plots_gen.R


### Generate Corrgram for Malow's CP
figures/mallow_roc.png:\
derived_data/train_dat.csv\
derived_data/val_dat.csv\
derived_data/test_dat.csv\
mallows_cp_roc_gen.R
	Rscript mallows_cp_roc_gen.R

### Generate Corrgram for Adjusted R Squared
figures/adjrsq_roc.png:\
derived_data/train_dat.csv\
derived_data/val_dat.csv\
derived_data/test_dat.csv\
derived_data/train_val_dat.csv\
adj_rsq_roc_gen.R
	Rscript adj_rsq_roc_gen.R

### Generate Corrgram for LASSO
figures/lasso_roc.png:\
derived_data/train_val_dat.csv\
derived_data/test_dat.csv\
lasso_roc_gen.R
	Rscript lasso_roc_gen.R

### Generate Corrgram for Decision Tree
figures/tree_roc.png:\
derived_data/train_val_dat.csv\
derived_data/test_dat.csv\
tree_roc_gen.R
	Rscript tree_roc_gen.R

### Shiny Dashboard Generation
shiny_app:\
source_data/heart.csv\
shiny_app.R
	Rscript shiny_app.R ${PORT}


### Shiny Dashboard Generation
dash_app:\
source_data/heart.csv\
dash_app_heartd.py
	python3 dash_app_heartd.py ${PORT}

source_data/heart.csv:
	mkdir -p source_data
	mkdir -p figures
	mkdir -p derived_data
	mkdir -p derived_docs
	mkdir -p derived_objects
	mv heart.csv source_data/heart.csv
