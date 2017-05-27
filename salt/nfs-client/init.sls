nfs-client:
  pkg.installed:
    - pkgs:
{% if grains['osfullname']|lower == 'debian' %}
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

/opt/DATA:
  mount.mounted:
    - device: {{pillar['nfs-server']}}:/opt/DATA
    - fstype: nfs4
    - opts: rsize=8192,wsize=8192,timeo=14,bg,_netdev

/opt/Log:
  mount.mounted:
    - device: {{pillar['nfs-server']}}:/opt/Log
    - fstype: nfs4
    - opts: rsize=8192,wsize=8192,timeo=14,bg,_netdev