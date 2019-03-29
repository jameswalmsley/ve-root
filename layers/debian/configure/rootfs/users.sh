#!/bin/bash

{% for user,v in config['system']['users'].items() %}
adduser {{ user }} --gecos "First Last,RN,WP,HP" --disabled-password
echo {{ user }}:{{ v['password' ]}} | chpasswd
    {% for group in v['groups'] %}
adduser {{ user }} {{ group }}
    {% endfor %}
{% endfor %}
