#!/bin/sh
# simple script to update the /usr/lib/jvm/default symbolic link and /etc/alternatives
# of Oracle JDK, if installed.
#

java_major_version={{java_major_version}}
echo "Checking Java path: " /usr/lib/jvm/java-$java_major_version-oracle


#--------------------------------------#
# set /usr/lib/jvm/default symbolic link
#

line=$(ls -l /usr/lib/jvm/default)
if [[ $line =~ /usr/lib/jvm/java-$java_major_version-oracle$ ]]; then
    echo "Already done for '/usr/lib/jvm/default'."

else

    if [ -L /usr/lib/jvm/default ]; then
        echo "Removing symbolic link '/usr/lib/jvm/default' ..."
        rm -f  /usr/lib/jvm/default
    else
        echo "'/usr/lib/jvm/default' should be a symbolic link; fixing..."
        rm -rf /usr/lib/jvm/default
    fi

    echo "Re-linking '/usr/lib/jvm/default' to chosen version..."
    ln -s  /usr/lib/jvm/java-$java_major_version-oracle  /usr/lib/jvm/default

fi



#--------------------------------------#
# set alternatives
#

line=$(ls -l /etc/alternatives/java)
#echo $line


if [[ $line =~ /usr/lib/jvm/default/bin/java$ ]]; then
    echo "alternatives system already done."

else
    echo "Updating /etc/alternatives ..."

    # set java link
#    update-alternatives --verbose --remove-all java
    update-alternatives --verbose --install /usr/bin/java java /usr/lib/jvm/default/bin/java 1

fi

line=$(ls -l /etc/alternatives/javac)

if [[ $line =~ /usr/lib/jvm/default/bin/javac$ ]]; then
    echo "alternatives system already done."

else
    echo "Updating /etc/alternatives ..."

    # set javac link
#    update-alternatives --verbose --remove-all javac
    update-alternatives --verbose --install /usr/bin/javac javac /usr/lib/jvm/default/bin/javac 1

fi

line=$(ls -l /etc/alternatives/jar)

if [[ $line =~ /usr/lib/jvm/default/bin/jar$ ]]; then
    echo "alternatives system already done."

else
    echo "Updating /etc/alternatives ..."

    # set jar link
#    update-alternatives --verbose --remove-all jar
    update-alternatives --verbose --install /usr/bin/jar jar /usr/lib/jvm/default/bin/jar 1

fi
