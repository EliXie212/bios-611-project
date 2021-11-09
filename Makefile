.PHONY: clean
.PHONY: shiny_app
# SHELL: /bin/bash

### Clean existing datasets, figures or reports generated in this Makefile for builing
clean:
	rm -f derived_data/*.csv
	rm -f figures/*.png
	rm -f heart_disease_report.pdf

### Report Generation
heart_disease_report.pdf:\
heart_disease_report.tex\
figures/corrgram.png
	pdflatex heart_disease_report.tex

### Data Requirements
## Train data
derived_data/train_dat.csv:\
train_val_gen.R\
source_data/heart.csv
	Rscript train_val_gen.R

derived_data/val_dat.csv:\
train_val_gen.R\
source_data/heart.csv\
	Rscript train_val_gen.R


### Generate Corrgram Generation
figures/corrgram.png:\
derived_data/train_dat.csv\
corrgram_gen.R
	Rscript corrgram_gen.R

### Shiny Dashboard Generation
shiny_app:\
source_data/heart.csv\
shiny_app.R
	Rscript shiny_app.R ${PORT}
