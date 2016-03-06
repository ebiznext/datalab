# Ansible Playbook for Elasticsearch
This is an [Ansible](http://www.ansibleworks.com/) playbook for [Elasticsearch](http://www.elasticsearch.org/).

## Features
- Support for installing plugins
- Support for installing custom JARs in the Elasticsearch classpath (e.g. custom Lucene Similarity JAR)
- Support for installing the [Marvel](http://www.elasticsearch.org/guide/en/marvel/current/) plugin

## Requirements
- Java (version 8 recommended)
- Maven (3.1 or higher)
- Increase max open files

## Some role variables for custom installation

- `elasticsearch_version` - Elasticsearch version to install (default: "1.7.3")
- `elasticsearch_install_prebuilt` - If set, ansible will install elasticsearch from a pre-built package (default: 'yes')
- `elasticsearch_install_directory` - The installion directory (default: '/usr/local')
- `elasticsearch_prebuit_package_url` - Url to download Elasticsearch pre-built package. The archive file name should match the pattern **elasticsearch-{elasticsearch_version}.tgz**
- `elasticsearch_plugins_repo` - Url to an elasticsearch repository (an http server). This is useful if you want to download elasticsearch plugins from a specific location.
- `elasticsearch_config_cluster_name` - Cluster name to identify your cluster for auto-discovery (default: "elasticsearch")
- `elasticsearch_config_network_bind_host` - Set the bind address specifically IPv4 or IPv6 (default: "0.0.0.0")
- `elasticsearch_config_network_http_port` - Elasticsearch http port (default: "9200")
- `elasticsearch_service_enabled` - Make sure Elasticsearch service is enabled after system boot (default: "no")
- `elasticsearch_service_state` - Stop Elasticsearch service (default: "stopped")
- `elasticsearch_config_memory_heap_size` - ES heap size (default: "512m")

For more details about configuration parameters see `elasticsearch.default.j2` and `elasticsearch.yml.j2` files.


## Enabling Added Features

### Installing plugins

You will need to define an array called `elasticsearch_plugins` in the host/group vars file, such that:

```
elasticsearch_plugins:
 - { name: '<plugin name>', url: '<[optional] plugin url>' }
 - ...

```
By default head and analysis-icu plugins are installed (see defaults/main.yml).

Concerning [searchguard plugin](https://github.com/floragunncom/search-guard) it is important to note that it [didn't support Elasticsearcl 1.7](https://github.com/floragunncom/search-guard/issues/41) yet. Otherwise, for the previous versions it is possible to build and/or install the plugin. Just set the `elasticsearch_plugins_searchguard_install` flag to `true` (disabled by default). The search-guard plugin should not be specified within "elasticsearch_plugins" list as it will has a custom installation.

### Installing Custom JARs
Custom jars are made available to the Elasticsearch classpath by being downloaded into the elasticsearch_home_dir/lib folder. You will need to define an array called `elasticsearch_custom_jars` in the corresponding playbook or inventory file, such that:

```
elasticsearch_custom_jars:
 - { uri: '<URL where JAR can be downloaded from: required>', filename: '<alternative name for final JAR if different from file downladed: leave blank to use same filename>', user: '<BASIC auth username: leave blank of not needed>', passwd: '<BASIC auth password: leave blank of not needed>' }
 - ...
```

### Configuring Thread Pools
Elasticsearch [thread pools](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-threadpool.html) can be configured using the `elasticsearch_config.thread_pools` list variable:

```
elasticsearch_config_thread_pools:
  - "threadpool.bulk.type: fixed"
  - "threadpool.bulk.size: 50"
  - "threadpool.bulk.queue_size: 1000"
```

### Configuring Marvel

If you want to install Marvel plugin for ES, the following variable need to be set to `true` in the playbook or inventory:

- elasticsearch_plugins_marvel_install

The following variables provide configuration for the plugin. More options may be available in the future (see [http://www.elasticsearch.org/guide/en/marvel/current/#stats-export](http://www.elasticsearch.org/guide/en/marvel/current/#stats-export)):

- elasticsearch.plugins.marvel.agent_enabled
- elasticsearch.plugins.marvel.agent_exporter_es_hosts
- elasticsearch.plugins.marvel.agent_indices
- elasticsearch.plugins.marvel.agent_interval
- elasticsearch.plugins.marvel.agent_exporter_es_index_timeformat

### Change timezone
If you prefer to set the time zone, typically if you are not using `ntp`, use the `elasticsearch_timezone` parameter:

```
elasticsearch_timezone: "Europe/Paris"
```
