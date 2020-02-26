FROM antonildes/tidyverse:latest

# Copy R scripts to Docker 
COPY learning_today.R /root/learning_today.R
COPY function.R /root/function.R
COPY learning_today.sh /root/learning_today.sh
RUN chmod 0755 /root/learning_today.sh

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/pense-sepse

# Give execution rights on the cron job
RUN chmod 0755 /etc/cron.d/pense-sepse

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

#Install Cron/ syslog for debugging my cron jobs
RUN apt-get update && apt-get install -y gnupg2
RUN apt-get -y install cron rsyslog

### MongoDB ###
# Import the public key used by the package management system:
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4

# Create a list file for MongoDB:
RUN echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list

# Reload local package database:
RUN apt-get update

# Install the MongoDB packages:
RUN apt-get install -y mongodb-org

VOLUME ["/data/db"]
 
EXPOSE 27017

RUN apt-get update -qq \
    && apt-get -y --no-install-recommends install \
        lbzip2 \
        build-essential \
        cron \
    && install2.r --error --deps TRUE \
        data.table \
        lubridate \
        stringi \
        glue \
        remotes \
        devtools \
        jsonlite \
        foreach \
        doFuture \
		mongolite \
    && R -e "install.packages('aws.sns', repos = c('cloudyr' = 'http://cloudyr.github.io/drat'))" \
    && R -e "install.packages('aws.s3', repos = c('cloudyr' = 'http://cloudyr.github.io/drat'))"

# CMD ["mongod", "--bind_ip_all"]
# Run the command on container startup and keep the container running as service
CMD /usr/sbin/cron -f | service rsyslog restart && mongod --bind_ip_all

