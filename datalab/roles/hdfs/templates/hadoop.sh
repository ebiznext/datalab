export HADOOP_HOME={{hdfs.home_dir}}
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export JAVA_HOME={{java_home | default('/usr/lib/jvm/default')}}
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
