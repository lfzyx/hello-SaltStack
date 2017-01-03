redis user:
  group.present:
    - name: redis
  user.present:
    - name: redis
    - groups:
      - redis
    - home: /var/lib/redis
    - shell: /sbin/nologin

{% for DIR in ['/etc/redis/', '/var/run/redis/', '/var/log/redis/'] %}
{{ DIR }}:
  file.directory:
    - name: {{ DIR }}
    - user: redis
    - group: redis
    - makedirs: True
{% endfor %}

redis build:
  archive.extracted:
    - name: /tmp/
    - source: http://download.redis.io/releases/redis-3.2.6.tar.gz
    - source_hash: sha1=0c7bc5c751bdbc6fabed178db9cdbdd948915d1b
    - if_missing: /usr/bin/redis-server

  cmd.run:
    - name: 'make && make PREFIX=/usr/ install'
    - cwd: /tmp/redis-3.2.6/
    - unless: which redis-server

/etc/redis/redis.conf:
  file.managed:
    - name: /etc/redis/redis.conf
    - source: salt://redis/redis.conf
    - template: jinja

/etc/init.d/redis:
  file.managed:
    - name: /etc/init.d/redis
    - source: salt://redis/redis
    - template: jinja
    - mode: 755

redis_running:
  service.running:
    - name: redis
    - enable: True
