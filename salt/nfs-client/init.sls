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
    - device: {{salt['mine.get'](pillar['minion_ids']+'web','network.ip_addrs').values()[0][0]}}:/opt/DATA
    - fstype: nfs4
    - opts: rsize=8192,wsize=8192,timeo=14,_netdev

/opt/Log:
  mount.mounted:
    - device: {{salt['mine.get'](pillar['minion_ids']+'web','network.ip_addrs').values()[0][0]}}:/opt/Log
    - fstype: nfs4
    - opts: rsize=8192,wsize=8192,timeo=14,_netdev
