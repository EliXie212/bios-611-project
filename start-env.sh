#!/bin/bash
mkdir source_data
mkdir figures
mkdir derived_data
mkdir derived_docs
mkdir derived_objects

docker build . -t project-env


docker run -v $(pwd):/home/rstudio/project \
                  -p 8787:8787 \
                  -p 8722:22 \
                  -e PASSWORD=hello123 \
                  -t project-env
