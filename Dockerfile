FROM antonildes/tidyverse:latest

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/pense-sepse

# Give execution rights on the cron job
RUN chmod 0755 /etc/cron.d/pense-sepse

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

#Install Cron/ syslog for debugging my cron jobs
RUN apt-get update
RUN apt-get -y install cron rsyslog

# Copy R scripts to Docker 
COPY learning_today.R /root/learning_today.R
COPY function.R /root/function.R

# Run the command on container startup and keep the container running as service
CMD /usr/sbin/cron -f | service rsyslog restart

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
