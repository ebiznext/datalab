# Description

Ansible role to build/install Spark on Debian / RedHat.

## Role Variables

- `spark_version` - Spark version (default: "1.4.1")
- `hadoop_version` - Hadoop version (default: "2.6")
- `spark_home_directory`: Spark home directory (default: '/usr/local/spark')
- `spark_prebuilt_url`: Url to download Spark pre-built package.
- `spark_do_build` - If set to true, Spark sources will be downloaded and built (default: false)
- `spark_build_checkout` - Set it to `git` to checkout Spark sources from `github` or `tarball` to get them from official Apache repository (default: "tarball")
- `spark_build_options` - Build options. Can be for instance "-Phive -Pyarn" (default: "" )
- `spark_build_sbt_launch_version` - : The sbt launcher version (default: "0.13.7")
- `spark_tarball_url` - : Url to download Spark sources as a tarball
