FROM rocker/verse
RUN wget https://sqlite.org/snapshot/sqlite-snapshot-202110132029.tar.gz
RUN apt update && apt-get install -y emacs openssh-server python3-pip
RUN pip3 install beautifulsoup4 theano tensorflow keras sklearn pandas numpy pandasql
RUN R -e "install.packages(c('matlab','Rtsne'));"
RUN R -e "install.packages(c(\"shiny\",\"deSolve\",\"signal\"))"
RUN R -e "install.packages(\"reticulate\")";
RUN R -e "install.packages(\"gbm\")";
RUN R -e "install.packages(\"caret\")";
RUN R -e "install.packages(c(\"shiny\",\"plotly\"))";
RUN pip3 install jupyter jupyterlab
RUN R -e "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'gbm'));"
RUN R -e "install.packages(c('pbdZMQ', 'devtools', 'uuid', 'digest', 'corrgram'));"
RUN R -e "install.packages(c('ROCR', 'pracma', 'party', 'glmnet', 'texreg'));"
RUN R -e "install.packages(c('tinytex', 'leaps', 'magrittr', 'reticulate'));"
RUN R -e "devtools::install_github(\"IRkernel/IRkernel\"); IRkernel::installspec(user=FALSE);"
RUN R -e "install.packages('RSQLite')";
RUN pip3 install matplotlib plotly bokeh plotnine dplython
