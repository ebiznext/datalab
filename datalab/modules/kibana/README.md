# Description

An Ansible role for installing [Kibana](http://www.elasticsearch.org/overview/kibana/).

## Role Variables

- `kibana_version` - Kibana version to install (default: `4.1.1`)
- `kibana_download_package_url` - Url to download Kibana tarball. The archive file name should match the pattern **kibana-{kibana_version}.tgz**
- `kibana_install_directory` - The installation directory (default: '/usr/local')
- `kibana_config_server_addr` - Kibana address to bind to (default: `0.0.0.0`)
- `kibana_config_server_port` - Kibana port (default: `5601`)
- `kibana_elasticsearch_addr` - ElasticSearch endpoint (default: `http://localhost:9200`)
- `kibana_service_state` - Run kibana service (default: `stopped`)
- `kibana_service_enabled` - Make sure Kibana service is started after system boot (default: `no`)
