#!/bin/bash
mkdir source_data
mkdir figures
mkdir derived_data

sudo docker build . -t project-env


sudo docker run -v $(pwd):/home/rstudio/project \
                  -p 8787:8787 \
                  -p 8722:22 \
                  -e PASSWORD=hello123 \
                  -t project-env
