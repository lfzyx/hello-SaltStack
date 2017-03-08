nfs-server:
  pkg.installed:
    - pkgs:
{% if grains['osfullname']|lower == 'debian' %}
      - nfs-kernel-server
      - nfs-common
{% elif grains['osfullname']|lower == 'centos' %}
      - nfs-utils
{% endif %}
    - allow_updates: True

DATA_directory:
  file.directory:
    - name: /opt/DATA

Log_directory:
  file.directory:
    - name: /opt/Log

/etc/exports:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - source: salt://nfs-server/files/exports
    - template: jinja

rpcbind_running:
  service.running:
    - name: rpcbind
    - enable: True

nfs_running:
  service.running:
    - name: nfs
    - enable: True
    - watch:
      - file: /etc/exports

