{% if grains['osfullname']|lower == 'centos' %}
/etc/yum.repos.d/nginx.repo:
{% elif grains['osfullname']|lower == 'debian' %}
/etc/apt/sources.list.d/nginx.list:
{% endif %}
  file.managed:
    - mode: 644
    - user: root
    - group: root
{% if grains['osfullname']|lower == 'centos' %}
    - source: salt://nginx/nginx.repo
{% elif grains['osfullname']|lower == 'debian' %}
    - source: salt://nginx/nginx.list
{% endif %}
    - template: jinja

nginx:
  pkg.installed:
    - refresh: True

/etc/nginx/nginx.conf:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - source: salt://nginx/nginx.conf
    - template: jinja

/etc/nginx/conf.d/web.conf:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - source: salt://nginx/web.conf
    - template: jinja

/etc/nginx/conf.d/admin.conf:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - source: salt://nginx/admin.conf
    - template: jinja

/etc/nginx/conf.d/limit:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - source: salt://nginx/limit
    - template: jinja

/etc/nginx/conf.d/{{pillar['ssl']['web_certificate']}}:
    file.managed:
    - mode: 600
    - user: root
    - group: root
    - source: salt://nginx/ssl/{{pillar['minion_ids']}}/{{pillar['ssl']['web_certificate']}}
    - template: jinja

/etc/nginx/conf.d/{{pillar['ssl']['web_certificate_key']}}:
    file.managed:
    - mode: 600
    - user: root
    - group: root
    - source: salt://nginx/ssl/{{pillar['minion_ids']}}/{{pillar['ssl']['web_certificate_key']}}
    - template: jinja

/etc/nginx/conf.d/{{pillar['ssl']['admin_certificate']}}:
    file.managed:
    - mode: 600
    - user: root
    - group: root
    - source: salt://nginx/ssl/{{pillar['minion_ids']}}/{{pillar['ssl']['admin_certificate']}}
    - template: jinja

/etc/nginx/conf.d/{{pillar['ssl']['admin_certificate_key']}}:
    file.managed:
    - mode: 600
    - user: root
    - group: root
    - source: salt://nginx/ssl/{{pillar['minion_ids']}}/{{pillar['ssl']['admin_certificate_key']}}
    - template: jinja

/var/log/nginx/log/:
  file.directory:
    - name: /var/log/nginx/log/
    - user: nginx
    - group: adm
    - makedirs: True

nginx_run:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/*
