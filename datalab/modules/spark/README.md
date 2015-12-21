# Description

Ansible role to build/install Spark on Ubuntu.

## Role Variables

- `spark_version` - Spark version to install from sources or pre-built package (default: "1.4.1")
- `spark_install_directory`: Installation directory (default: '/usr/local')
- `spark_prebuilt_package_url`: Url to download Spark pre-built package. The archive file name should match the pattern **spark-{spark_version}.tgz**
- `spark_checkout` - Set it to 'git' to checkout Spark sources from `github` or 'tarball' to get them from official Apache repository (default: "tarball")
- `spark_do_build` - If set to true, Spark sources will be downloaded and built (default: false)
- `spark_build_options` - Build options. Can be for instance "-Phive -Pyarn" (default: "" )
- `sbt_launch_version` - : The sbt launcher version "0.13.7"
- `spark_copy_prebuilt_package` - : If set to true, ansible copies Spark pre-built package from `spark_prebuilt_package_location` path within the host file system (default: true)
- `spark_prebuilt_package_location` - Relative/absolute path to the pre-built package directory in the local ansible host (default: "distrib/spark")
