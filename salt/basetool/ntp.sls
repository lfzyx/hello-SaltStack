ntp:
  pkg.installed:
    - name: ntp
    - allow_updates: True
  service.running:
{% if grains['osfullname']|lower == 'centos' %}
    - name: ntpd
{% elif grains['osfullname']|lower == 'debian' %}
    - name: ntp
{% endif %}
    - template: jinja
