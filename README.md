﻿# easychannel

Appointment handling system for private medical centers in sri lanka. Users and medical staff can access user portal and staff portal from same mobile application. User type is detected according to user's password. System facilitate que prediction model to give estimation of how long would a user take for their appointment. Using this prediction time estimated appoinment start time is given for every user in the queue. Data from [Hangu Open Data project](https://github.com/fenghaolin/HanguData) was used and data were labled after throroughly studying details provided in [Feng et al. (2024)](https://github.com/fenghaolin/HanguData). Also special focus were given to labels that were specific to the sri lankan context such as most of the patients have very limited data when making appointments to generate prediction times. 

[XGBoost](https://www.nvidia.com/en-us/glossary/xgboost/) model was created using the labeled data and model was accurate up to 60% due to limitations of data. More accurate dataset specific to the context of the problem will be able to achieve significant accuracy. 

Setup
-> go to easy channel app directory in android studio or vs code.
-> run flutter doctor and make sure all the dependencies are installed then run the app.
-> make sure your app can make network requests to local host.
-> go to backend/queue directory
-> run the flask app in python environment after installing requiremens.txt
-> when you make a new appointment you will be given estimated time for your new appointment
