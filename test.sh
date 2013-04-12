#!/bin/bash

HADOOP_FOLDER="hadoop-1.0.4"

cd $(dirname $0)

WHICH_HADOOP=$(which hadoop)
if [ "$?" != "0" ] ; then
  $WHICH_HADOOP version
  if [ "$?" != "0" ] ; then
    # Need to set up Hadoop
    if [ ! -e "$HADOOP_FOLDER" ] ; then
      if [ ! -e "$HADOOP_FOLDER.tar.gz" ] ; then
        wget http://www.gtlib.gatech.edu/pub/apache/hadoop/common/$HADOOP_FOLDER/$HADOOP_FOLDER.tar.gz
      fi
      tar xzvf $HADOOP_FOLDER.tar.gz
    fi
#     cat > $HADOOP_FOLDER/conf/core-site.xml <<EOF
# <?xml version="1.0"?>
# <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
# 
# <configuration>
#   <property>
#     <name>hadoop.log.dir</name>
#     <value>/tmp/</value>
#   </property>
#   <property>
#     <name>fs.s3n.awsAccessKeyId</name>
#     <value>KEY</value>
#     </property>
#     <property>
#       <name>fs.s3n.awsSecretAccessKey</name>
#       <value>SECRET</value>
#     </property>
# </configuration>
# EOF
    WHICH_HADOOP="$HADOOP_FOLDER/bin/hadoop"
  fi
fi

mvn package
JAVA_HOME=$(dirname $(dirname $(which java))) $WHICH_HADOOP jar target/com.bornski.hadoop.packagedpythondemo-1.0.jar com.bornski.hadoop.packagedpythondemo.RunDemo
