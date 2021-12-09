BIOS 611 Project
===================

-----------------------------

### Introduction
This project seeks to analyze a classic public heart disease dataset from a 1988 study. We seek to
understand how this dataset can help us understand the risk indicators/factors associated with heart
disease and inform diagnostic decisions.

### Dataset
The dataset we use was from 1988 and consists of four databases: Cleveland,
Hungary, Switzerland, and Long Beach V attributed to four doctors: Andras
Janosi, M.D (Hungarian Institute of Cardiology. Budapest co), William Steinbrunn, M.D (University Hospital, Zurich, Switzerland), Matthias Pfisterer, M.D
(University Hospital, Basel, Switzerlan) and Robert Detrano, M.D. (V.A. Medical Center, Long Beach and Cleveland Clinic Foundation).


The data can be found on kaggle:

https://www.kaggle.com/johnsmith88/heart-disease-dataset


Using This Project
------------------
You will need Docker. You will need to be able to run docker as your current user.

Instructions on installation of docker can be found here:

Windows: https://docs.docker.com/desktop/windows/install/

Ubuntu: https://docs.docker.com/engine/install/ubuntu/


To initiate the docker environment, run:

	`./start-env.sh`

Then open an Rstudio instance on port 8787. You can access the instance by going
to your browser and type:

	`localhost:8787`

When prompted by Rstudio to enter username and password, enter Rstudio and "hello123".

You can also modified the username and password in the Dockerfile.

The working directory of the project is located at home/rstudio/project. Make sure
you are in the working directory before proceeding by using:

	`cd /home/rstudio/project`



Please download the dataset from the kaggle and move the csv file under source_data directory.


Makefile
--------
The Makefile included in this repository will help build different components
 of the project.

You will need to go the terminal of the rstudio instance to run the following commands
to build different components

To build the report, use the following:

	> make pdflatex heart_disease_report.tex


Shiny App
---------
To explore the distributions of different explanatory variables in healthy population
vs disease population with a shiny app, use the following:

	> make shiny_app
	

Dash App
---------
To visualize 2D PCA and t-SNE clusters with different features with dash app, use the following:

	> make dash_app

Then following the link returned in the terminal.
