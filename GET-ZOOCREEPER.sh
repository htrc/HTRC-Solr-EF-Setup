#!/bin/bash

/bin/rm zoocreeper-master.zip
wget https://github.com/boundary/zoocreeper/archive/master.zip -O zoocreeper-master.zip \
    && unzip zoocreeper-master.zip \
    && cd zoocreeper-master \
    && mvn clean package
  



