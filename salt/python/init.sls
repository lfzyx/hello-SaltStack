zlib:
  pkg.installed:
    - pkgs:
      - gcc
      - zlib-devel
      - bzip2-devel
      - openssl-devel
    - refresh: True

python3.4:
  archive.extracted:
    - name: /tmp/
    - source: https://www.python.org/ftp/python/3.4.2/Python-3.4.2.tgz
    - source_hash: sha1=5c756dded3492a9842efa5a10d610820b8f753e7
    - if_missing: /usr/local/bin/python3.4

  cmd.run:
    - name: '/tmp/Python-3.4.2/configure && make && make install'
    - cwd: /tmp/
    - unless: which python3.4

pip3:
  file.managed:
    - name: /tmp/get-pip.py
    - source: https://bootstrap.pypa.io/get-pip.py
    - skip_verify: True

  cmd.run:
    - name: '/usr/local/bin/python3 /tmp/get-pip.py'
    - cwd: /tmp/
    - unless: which pip3
    - reload_modules: True

  pip.installed:
    - name: 'psutil'
    - bin_env: /usr/local/bin/pip3
