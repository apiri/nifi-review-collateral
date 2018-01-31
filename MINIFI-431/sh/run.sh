#!/bin/sh

git clone https://github.com/apache/nifi-minifi.git ${HOME}/nifi-minifi
cd /root/nifi-minifi
sed -e '9ifetch = +refs/pull/*/head:refs/remotes/origin/pr/*' -i ${HOME}/nifi-minifi/.git/config
git fetch --all && git checkout origin/pr/112
mvn clean install -DskipTests -T2


# Grab the c2 context from JIRA
wget https://issues.apache.org/jira/secure/attachment/12907562/minifi-c2-context.xml -O /root/nifi-minifi/minifi-c2/minifi-c2-assembly/target/minifi-c2-0.5.0-SNAPSHOT-bin/minifi-c2-0.5.0-SNAPSHOT/conf/minifi-c2-context.xml

# Make some sample versioned flows in hadoop-agents
mkdir -p /root/nifi-minifi/minifi-c2/minifi-c2-assembly/target/minifi-c2-0.5.0-SNAPSHOT-bin/minifi-c2-0.5.0-SNAPSHOT/files/hadoop-agents
cp /root/nifi-minifi/minifi-c2/minifi-c2-assembly/target/minifi-c2-0.5.0-SNAPSHOT-bin/minifi-c2-0.5.0-SNAPSHOT/files/raspi3/* /root/nifi-minifi/minifi-c2/minifi-c2-assembly/target/minifi-c2-0.5.0-SNAPSHOT-bin/minifi-c2-0.5.0-SNAPSHOT/files/hadoop-agents/
cp /root/nifi-minifi/minifi-c2/minifi-c2-assembly/target/minifi-c2-0.5.0-SNAPSHOT-bin/minifi-c2-0.5.0-SNAPSHOT/files/hadoop-agents/config.text.yml.v1 /root/nifi-minifi/minifi-c2/minifi-c2-assembly/target/minifi-c2-0.5.0-SNAPSHOT-bin/minifi-c2-0.5.0-SNAPSHOT/files/hadoop-agents/config.text.yml
cp /root/nifi-minifi/minifi-c2/minifi-c2-assembly/target/minifi-c2-0.5.0-SNAPSHOT-bin/minifi-c2-0.5.0-SNAPSHOT/files/hadoop-agents/config.text.yml.v1 /root/nifi-minifi/minifi-c2/minifi-c2-assembly/target/minifi-c2-0.5.0-SNAPSHOT-bin/minifi-c2-0.5.0-SNAPSHOT/files/hadoop-agents/config.text.yml.v2
cp /root/nifi-minifi/minifi-c2/minifi-c2-assembly/target/minifi-c2-0.5.0-SNAPSHOT-bin/minifi-c2-0.5.0-SNAPSHOT/files/hadoop-agents/config.text.yml.v1 /root/nifi-minifi/minifi-c2/minifi-c2-assembly/target/minifi-c2-0.5.0-SNAPSHOT-bin/minifi-c2-0.5.0-SNAPSHOT/files/hadoop-agents/config.text.yml.v3

# Grab the bootstrap for minifi instance
wget https://issues.apache.org/jira/secure/attachment/12907561/bootstrap.conf -O /root/nifi-minifi/minifi-assembly/target/minifi-0.5.0-SNAPSHOT-bin/minifi-0.5.0-SNAPSHOT/conf/bootstrap.conf
sed -i 's/60000/10000/g' /root/nifi-minifi/minifi-assembly/target/minifi-0.5.0-SNAPSHOT-bin/minifi-0.5.0-SNAPSHOT/conf/bootstrap.conf

# Start your engines
/root/nifi-minifi/minifi-c2/minifi-c2-assembly/target/minifi-c2-0.5.0-SNAPSHOT-bin/minifi-c2-0.5.0-SNAPSHOT/bin/c2.sh &
/root/nifi-minifi/minifi-assembly/target/minifi-0.5.0-SNAPSHOT-bin/minifi-0.5.0-SNAPSHOT/bin/minifi.sh start

# Monitor
tail -F /root/nifi-minifi/minifi-assembly/target/minifi-0.5.0-SNAPSHOT-bin/minifi-0.5.0-SNAPSHOT/logs/minifi-*.log

#RUN git clone https://github.com/apache/nifi-minifi.git ${HOME}/nifi-minifi
#WORKDIR /root/nifi-minifi
#RUN sed -e '9ifetch = +refs/pull/*/head:refs/remotes/origin/pr/*' -i ${HOME}/nifi-minifi/.git/config
#RUN git fetch --all && git checkout origin/pr/112
#RUN mvn clean install -DskipTests
## Start your engines
#RUN /root/nifi-minifi/minifi-c2/minifi-c2-assembly/target/minifi-c2-0.5.0-SNAPSHOT-bin/minifi-c2-0.5.0-SNAPSHOT/bin/c2.sh &
#RUN /root/nifi-minifi/minifi-assembly/target/minifi-0.5.0-SNAPSHOT-bin/minifi-0.5.0-SNAPSHOT/bin/minifi.sh start

# Monitor
#RUN tail -F /root/nifi-minifi/minifi-assembly/target/minifi-0.5.0-SNAPSHOT-bin/minifi-0.5.0-SNAPSHOT/logs/minifi-*.log
