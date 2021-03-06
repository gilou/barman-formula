# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "barman/map.jinja" import barman with context %}

barman-config:
  file.managed:
    - name: {{ barman.config }}
    - source: salt://barman/files/barman.conf
    - mode: 644
    - user: {{ barman.user }}
    - group: {{ barman.user }}
    - template: jinja
    - defaults:
        user: {{ barman.user }}
        config_dir: {{ barman.config_dir }}
        home: {{ barman.home }}
        log_file: {{ barman.log_file }}
        log_level: {{ barman.log_level }}
        compression: {{ barman.compression }}
        recovery_options: {{ barman.recovery_options }}

{% for host, cfg in barman.hosts.iteritems() %}
{{ barman.config_dir }}/{{host}}.conf:
  file.managed:
    - source: salt://barman/files/host-template.conf
    - user: {{ barman.user }}
    - group: {{ barman.user }}
    - mode: 644
    - template: jinja
    - defaults:
        host: {{ host }}
        description: {{ cfg.description }}
        conninfo: {{ cfg.conninfo }}
        backup_method: {{ cfg.backup_method }}
        last_backup_maximum_age: {{ cfg.last_backup_maximum_age }}
        retention_policy: {{ cfg.retention_policy }}
{% if cfg.backup_method == 'postgres' %}
        streaming_conninfo: {{ cfg.streaming_conninfo }}
        streaming_archiver: {{ cfg.streaming_archiver }}
        slot_name: {{ cfg.slot_name }}
{% else %}
        ssh_command: {{ cfg.ssh_command }}
        reuse_backup: {{ cfg.reuse_backup }}
        archiver: {{ cfg.archiver }}
{% endif %}

{% endfor %}

