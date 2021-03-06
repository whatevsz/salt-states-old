{% from 'salt/map.jinja' import saltmap with context %}

{% set master = salt['pillar.get']('override_salt_master', {}).get(grains['id'], 'salt') %}

salt-minion:
  service.running:
    - name: {{ saltmap.minion.service }}
    - enable: true
    - watch:
      - file: salt-minion-conf
    - order: last

salt-minion-conf:
  file.managed:
    - name: {{ saltmap.minion.conf_file }}
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 600
    - source: salt://salt/files/minion.jinja
    - template: jinja
    - defaults:
        master: {{ master }}
