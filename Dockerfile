FROM rocker/verse:4.0.4

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    graphviz \
    less \
    liblapack-dev \
    libtk8.6 \
    pbzip2 \
    p7zip-full \
    tk8.6 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && install2.r --error \
    actuar \
    arules \
    arulesCBA \
    arulesNBMiner \
    arulesSequences \
    arulesViz \
    BiocManager \
    BTYD \
    BTYDplus \
    broom \
    conflicted \
    cowplot \
    DataExplorer \
    DT \
    directlabels \
    evir \
    fitdistrplus \
    fs \
    furrr \
    ggraph \
    lobstr \
    pryr \
    rfm \
    rmdformats \
    snakecase \
    survival \
    survminer \
    tidygraph \
    tidyquant \
    tidytext \
    timetk

RUN Rscript -e 'BiocManager::install("Rgraphviz")'

COPY build/conffiles.7z           /tmp
COPY build/docker_install_rpkgs.R /tmp

WORKDIR /tmp

RUN git clone https://github.com/lindenb/makefile2graph.git \
  && cd makefile2graph \
  && make \
  && make install

WORKDIR /home/rstudio

RUN Rscript /tmp/docker_install_rpkgs.R

RUN 7z x /tmp/conffiles.7z \
  && cp conffiles/.bash*     . \
  && cp conffiles/.gitconfig . \
  && cp conffiles/.Renviron  . \
  && cp conffiles/.Rprofile  . \
  && cp conffiles/user-settings .rstudio/monitored/user-settings/ \
  && chown -R rstudio:rstudio /home/rstudio \
  && rm -rfv conffiles/

