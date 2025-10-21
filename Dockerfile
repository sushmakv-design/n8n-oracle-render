RUN apt-get update
WORKDIR /opt
ADD ./ORACLE-INSTANT-CLIENT.deb  /opt
#if libaio also required
RUN apt-get install libaio1 
RUN dpkg -i oracle-instantclient.deb