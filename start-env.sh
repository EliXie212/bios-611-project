#!/bin/bash

mkdir source_data
mkdir figures
mkdir derived_data
mkdir derived_docs
mkdir derived_objects
mv heart.csv source_data/heart.csv

docker build . -t project-env


docker run -v $(pwd):/home/rstudio/project \
                  -p 8787:8787 \
                  -p 8722:8722 \
                  -p 8725:8725 \
                  -e PASSWORD=hello123 \
                  -t project-env
