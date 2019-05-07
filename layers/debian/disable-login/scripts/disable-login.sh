#!/bin/bash

{% for k,user in config['system'].users.items() %}
passwd -l {{ k }}
echo "{{ k }} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
{% endfor %}

