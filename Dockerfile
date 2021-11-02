FROM rocker/verse
RUN wget https://sqlite.org/snapshot/sqlite-snapshot-202110132029.tar.gz
RUN pip3 install beautifulsoup4 theano tensorflow keras sklearn pandas numpy pandasql
RUN R -e "install.packages(c('matlab','Rtsne'));"
RUN R -e "install.packages(c(\"shiny\",\"deSolve\",\"signal\"))"
RUN R -e "install.packages(\"reticulate\")";
RUN R -e "install.packages(\"gbm\")";
RUN R -e "install.packages(\"caret\")";
RUN R -e "install.packages(c(\"shiny\",\"plotly\"))";
RUN pip3 install jupyter jupyterlab
RUN R -e "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest', 'corrgram', 'ROCR', 'pracma', 'party', 'glmnet', 'tinytex', 'leap', 'magrittr', 'reticulate'))"
RUN R -e "devtools::install_github(\"IRkernel/IRkernel\"); IRkernel::installspec(user=FALSE);"
RUN R -e "install.package('RSQLite')";
RUN pip3 install matplotlib plotly bokeh plotnine dplython
