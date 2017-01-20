{% for DIR in ['/opt/docBase/', '/opt/tomcat0/', '/opt/bakdocBase'] %}
{{ DIR }}:
  file.directory:
    - name: {{ DIR }}
    - makedirs: True
{% endfor %}

tomcat build:
  archive.extracted:
    - name: /opt/tomcat0/
    - source: http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz
    - source_hash: sha1=c711970918f4c0ebd120cf35605795c416e342c8

{% for project in pillar['project'] %}
tomcat{{project}}:
  file.copy:
    - name: /opt/tomcat0/{{project}}
    - source: /opt/tomcat0/apache-tomcat-8.0.36

{{project}}/bin/catalina.sh:
  file.replace:
    - name: /opt/tomcat0/{{project}}/bin/catalina.sh
    - pattern: 'CATALINA_OUT=\"\$CATALINA_BASE\"'
    - repl: 'CATALINA_OUT=/opt/Log/{{project}}log'

{{project}}/conf/logging.properties:
  file.replace:
    - name: /opt/tomcat0/{{project}}/conf/logging.properties
    - pattern: '\$\{catalina.base\}'
    - repl: '/opt/Log/{{project}}log'

{{project}}/conf/server.xml:
  file.managed:
      - name: /opt/tomcat0/{{project}}/conf/server.xml
      - source: salt://tomcat/server.xml
      - template: jinja
      - defaults:
          project: {{project}}

{{project}}/bin/setenv.sh:
  file.managed:
      - name: /opt/tomcat0/{{project}}/bin/setenv.sh
      - source: salt://tomcat/setenv.sh
      - template: jinja
      - defaults:
          project: {{project}}

{{project}}Log:
  file.directory:
    - name: /opt/Log/{{project}}log/logs
    - makedirs: True

{% endfor %}
