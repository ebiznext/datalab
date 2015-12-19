FROM {{docker_registry_host}}/ubuntu14.04-jdk:{{java_major_version}}

# Add playbooks to the Docker image
ADD site.yml /tmp/
ADD filter_plugins /tmp/
ADD roles /tmp/
ADD inventory.ini /tmp/inventory.ini
COPY group_vars /tmp/group_vars/
COPY host_vars /tmp/host_vars/
COPY .vault_pass.txt /tmp/

WORKDIR /tmp

# Run Ansible to configure the Docker image
RUN /opt/ansible/ansible/bin/ansible-playbook site.yml --vault-password-file .vault_pass.txt -c local -i inventory.ini -e "java_major_version={{java_major_version}}" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE {{kibana_config_server_port}}

# Run script
ADD start.sh /
RUN chown {{kibana_user}}:{{kibana_group}} /start.sh
RUN chmod u+x /start.sh

CMD /start.sh
