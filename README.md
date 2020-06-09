This project contains the code, data, and artifacts for the *Getting Started in Domino* Tutorial, found 
[here](https://docs.dominodatalab.com/en/4.1/get_started_r/index.html) for R.

This tutorial will guide you through a common model lifecycle in Domino. 
You will start by working with data from the Balancing Mechanism Reporting Service in the UK. 
We will be exploring the Electricty Generation by Fuel Type and predicting the electricty generation in the future. 

Table of Contents:

* power.R
* power_report.Rmd
* Power_for_Launcher.R
* forecast_predictor.R
* data.csv
* app.sh
* model.rds

To run the model API, be sure to set up an environment with the following code in the Dockerfile:

`RUN R --no-save -e "install.packages(c('prophet'))"`