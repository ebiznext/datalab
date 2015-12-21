FROM ansible/ubuntu14.04-ansible:latest

# Add playbooks to the Docker image
ADD site.yml /tmp/
ADD roles /tmp/
ADD inventory.ini /tmp/inventory.ini
COPY group_vars /tmp/group_vars/
COPY host_vars /tmp/host_vars/
COPY .vault_pass.txt /tmp/

WORKDIR /tmp

# Run Ansible to configure the Docker image
RUN /opt/ansible/ansible/bin/ansible-playbook site.yml --vault-password-file .vault_pass.txt -c local -i inventory.ini -e "java_major_version={{jdk_version}}" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
