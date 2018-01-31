FROM maven:3.5-jdk-8-slim

RUN apt-get update && apt-get install -y git wget vim tmux

ADD ./sh/run.sh /root/
WORKDIR /root
