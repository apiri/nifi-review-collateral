FROM maven:3-jdk-8

RUN cd ~/ && git clone https://github.com/apache/nifi.git

RUN cd ~/nifi && mvn clean install -T2