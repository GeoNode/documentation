==========================
GeoNode Basic Installation
==========================

Overview
========

The followings are the easiest and recommended ways to deploy a full-stack GeoNode server on your host.

#. **First Step**: Deploy :guilabel:`GeoNode on a local server`, running as ``http://localhost/`` service. :guilabel:`GeoServer` will be also available at ``http://localhost/geoserver/``

#. **Second Step**: Deploy :guilabel:`GeoNode on a production server`, running as ``https://my_geonode.geonode.org/`` service. :guilabel:`GeoServer` will be also available at ``https://my_geonode.geonode.org/geoserver/``

#. **Third Step**: Customize :guilabel:`.env` to match your needs

#. **Fourth Step**: Secure your production deployment; change the :guilabel:`admin` passwords and :guilabel:`OAUth2` keys

First Step: Deploy GeoNode on a local server (e.g.: http://localhost/)
======================================================================

Ubuntu
^^^^^^

Packages Installation
.....................

First, we are going to install all the **system packages** needed for the GeoNode setup.
Login to the target machine and execute the following commands:

.. code-block:: shell

  sudo apt install -y gdal-bin
  sudo apt install -y python3-pip python3-dev python3-virtualenv python3-venv virtualenvwrapper
  sudo apt install -y libxml2 libxml2-dev gettext
  sudo apt install -y libxslt1-dev libjpeg-dev libpng-dev libpq-dev libgdal-dev libgdal20
  sudo apt install -y software-properties-common build-essential
  sudo apt install -y git unzip gcc zlib1g-dev libgeos-dev libproj-dev
  sudo apt install -y sqlite3 spatialite-bin libsqlite3-mod-spatialite

Docker Setup (First time only)
..............................

.. code-block:: shell

  sudo add-apt-repository universe
  sudo apt-get update -y
  sudo apt-get install -y git-core git-buildpackage debhelper devscripts
  sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

  sudo apt-get update -y
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
  sudo apt autoremove --purge

  sudo usermod -aG docker <your_system_user>
  su <your_system_user>

Create an instance of your ``geonode-project``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Let's say your project is named :guilabel:`my_geonode` perform the following steps:

.. code-block:: shell

  git clone https://github.com/GeoNode/geonode-project.git -b 3.x

  source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
  mkvirtualenv --python=/usr/bin/python3 my_geonode
  pip install Django==2.2.12

  django-admin startproject --template=./geonode-project -e py,sh,md,rst,json,yml,ini,env,sample -n monitoring-cron -n Dockerfile my_geonode

  # If the previous command does not work for some reason, try the following one
  python -m django startproject --template=./geonode-project -e py,sh,md,rst,json,yml,ini,env,sample -n monitoring-cron -n Dockerfile my_geonode

Startup the containers
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: shell

  cd my_geonode
  ./docker-build.sh

- You can follow the containers startup by running the following commands from ``my_geonode`` root folder:

    .. code-block:: shell

        # GeoNode Container
        docker-compose logs -f django

        # GeoServer Container
        docker-compose logs -f geoserver

        # DB Container
        docker-compose logs -f db

        # NGINX Container
        docker-compose logs -f geonode

- If any error occurs, try to catch the error stacktrace by running the following commands from ``my_geonode`` root folder:

    .. code-block:: shell

        # GeoNode “entrypoint.sh” Logs
        tail -F -n 300 invoke.log


Connect to :guilabel:`http://localhost/`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The startup typically takes some time, so be patient…

If everything goes well, you should be able to see from the ``geonode startup logs`` a line similar to the following one:

.. code-block:: shell

  <some date> [UWSGI] Uwsgi running...

Connect to :guilabel:`http://localhost/`

The default credentials are:

 * GeoNode (:guilabel:`http://localhost/`) :guilabel:`admin`:

    ``username: admin``
    ``password: admin``

 * GeoServer (:guilabel:`http://localhost/geoserver/`) :guilabel:`admin`:

    ``username: admin``
    ``password: geoserver``

Second Step: Deploy GeoNode on a production server (e.g.: https://my_geonode.geonode.org/)
==========================================================================================

In the case you would like to deploy to, let's say, :guilabel:`https://my_geonode.geonode.org/`, you will need to change ``.env`` as follows:

.. code-block:: diff

    --- geonode-project\.env
    +++ my_geonode\.env
    @@ -1,7 +1,7 @@
    -COMPOSE_PROJECT_NAME={{project_name}}
    +COMPOSE_PROJECT_NAME=my_geonode
    BACKUPS_VOLUME_DRIVER=local
    
    DOCKER_HOST_IP=
    DOCKER_ENV=production
    # See https://github.com/geosolutions-it/geonode-generic/issues/28
    # to see why we force API version to 1.24
    @@ -9,40 +9,40 @@
    
    C_FORCE_ROOT=1
    IS_CELERY=false
    IS_FIRST_START=true
    FORCE_REINIT=false
    
    -SITEURL=http://localhost/
    +SITEURL=https://my_geonode.geonode.org/
    ALLOWED_HOSTS=['django',]
    
    # LANGUAGE_CODE=pt
    # LANGUAGES=(('en','English'),('pt','Portuguese'))
    
    GEONODE_INSTANCE_NAME=geonode
    -DJANGO_SETTINGS_MODULE={{project_name}}.settings
    -UWSGI_CMD=uwsgi --ini /usr/src/{{project_name}}/uwsgi.ini
    +DJANGO_SETTINGS_MODULE=my_geonode.settings
    +UWSGI_CMD=uwsgi --ini /usr/src/my_geonode/uwsgi.ini
    
    # #################
    # backend
    # #################
    -GEONODE_DATABASE={{project_name}}
    +GEONODE_DATABASE=my_geonode
    GEONODE_DATABASE_PASSWORD=geonode
    -GEONODE_GEODATABASE={{project_name}}_data
    +GEONODE_GEODATABASE=my_geonode_data
    GEONODE_GEODATABASE_PASSWORD=geonode
    
    -DATABASE_URL=postgres://{{project_name}}:geonode@db:5432/{{project_name}}
    -GEODATABASE_URL=postgis://{{project_name}}_data:geonode@db:5432/{{project_name}}_data
    +DATABASE_URL=postgres://my_geonode:geonode@db:5432/my_geonode
    +GEODATABASE_URL=postgis://my_geonode_data:geonode@db:5432/my_geonode_data
    DEFAULT_BACKEND_DATASTORE=datastore
    BROKER_URL=amqp://guest:guest@rabbitmq:5672/
    
    # #################
    # geoserver
    # #################
    -GEOSERVER_WEB_UI_LOCATION=http://localhost/geoserver/
    -GEOSERVER_PUBLIC_LOCATION=http://localhost/geoserver/
    +GEOSERVER_WEB_UI_LOCATION=https://my_geonode.geonode.org/geoserver/
    +GEOSERVER_PUBLIC_LOCATION=https://my_geonode.geonode.org/geoserver/
    GEOSERVER_LOCATION=http://geoserver:8080/geoserver/
    GEOSERVER_ADMIN_PASSWORD=geoserver
    
    OGC_REQUEST_TIMEOUT=30
    OGC_REQUEST_MAX_RETRIES=1
    OGC_REQUEST_BACKOFF_FACTOR=0.3
    @@ -58,50 +58,50 @@
    MOSAIC_ENABLED=False
    
    # #################
    # nginx
    # HTTPD Server
    # #################
    -GEONODE_LB_HOST_IP=localhost
    +GEONODE_LB_HOST_IP=my_geonode.geonode.org
    GEONODE_LB_PORT=80
    
    # IP or domain name and port where the server can be reached on HTTPS (leave HOST empty if you want to use HTTP only)
    # port where the server can be reached on HTTPS
    -HTTP_HOST=localhost
    -HTTPS_HOST=
    +HTTP_HOST=
    +HTTPS_HOST=my_geonode.geonode.org
    
    HTTP_PORT=80
    HTTPS_PORT=443
    
    # Let's Encrypt certificates for https encryption. You must have a domain name as HTTPS_HOST (doesn't work
    # with an ip) and it must be reachable from the outside. This can be one of the following :
    # disabled : we do not get a certificate at all (a placeholder certificate will be used)
    # staging : we get staging certificates (are invalid, but allow to test the process completely and have much higher limit rates)
    # production : we get a normal certificate (default)
    -LETSENCRYPT_MODE=disabled
    +# LETSENCRYPT_MODE=disabled
    # LETSENCRYPT_MODE=staging
    -# LETSENCRYPT_MODE=production
    +LETSENCRYPT_MODE=production
    
    RESOLVER=127.0.0.11
    
    # #################
    # Security
    # #################
    # Admin Settings
    ADMIN_PASSWORD=admin
    -ADMIN_EMAIL=admin@localhost
    +ADMIN_EMAIL=admin@my_geonode.geonode.org
    
    # EMAIL Notifications
    EMAIL_ENABLE=False
    DJANGO_EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
    DJANGO_EMAIL_HOST=localhost
    DJANGO_EMAIL_PORT=25
    DJANGO_EMAIL_HOST_USER=
    DJANGO_EMAIL_HOST_PASSWORD=
    DJANGO_EMAIL_USE_TLS=False
    -DEFAULT_FROM_EMAIL='GeoNode <no-reply@geonode.org>'
    +DEFAULT_FROM_EMAIL='GeoNode <no-reply@my_geonode.geonode.org>'
    
    # Session/Access Control
    LOCKDOWN_GEONODE=False
    CORS_ORIGIN_ALLOW_ALL=True
    SESSION_EXPIRED_CONTROL_ENABLED=True
    DEFAULT_ANONYMOUS_VIEW_PERMISSION=True


Restart the containers
^^^^^^^^^^^^^^^^^^^^^^

Whenever you change someting on :guilabel:`.env` file, you will need to rebuild the container

.. warning:: **Be careful!** The following command drops any change you might have done manually inside the containers, except for the static volumes.

.. code-block:: shell

  docker-compose up -d

Third Step: Customize :guilabel:`.env` to match your needs
===========================================================

In the case you would like to modify the GeoNode behavior, always use the :guilabel:`.env` file in order to update the :guilabel:`settings`.

If you need to change a setting which does not exist in :guilabel:`.env`, you can force the values inside :guilabel:`my_geonode/settings.py`

Refer to the section: :ref:`settings`

You can add here any property referred as

    | Env: ``PROPERTY_NAME``


Restart the containers
^^^^^^^^^^^^^^^^^^^^^^

Whenever you change someting on :guilabel:`.env` file, you will need to rebuild the containers.

.. warning:: **Be careful!** The following command drops any change you might have done manually inside the containers, except for the static volumes.

.. code-block:: shell

  docker-compose up -d django


Fourth Step: Secure your production deployment; change the :guilabel:`admin` passwords and :guilabel:`OAUth2` keys
==================================================================================================================

GeoServer Setup
^^^^^^^^^^^^^^^

Admin Password Update
.....................

.. figure:: img/geoserver_setup_001.png
    :align: center

.. figure:: img/geoserver_setup_002.png
    :align: center

    *GeoServer Admin Password Update*

OAUth2 REST API Key
...................

.. note:: In order to generate new strong random passwords you can use an online service like https://passwordsgenerator.net/
    
    Avoid using Symbols ( e.g. @#$% ) as they might conflict with :guilabel:`.env` file

.. figure:: img/geoserver_setup_003.png
    :align: center

    *OAUth2 REST API Key Update*

GeoServer Disk Quota
....................

.. figure:: img/geoserver_setup_004.png
    :align: center

    *GeoServer Disk Quota Update*

Update the passwords and keys on :guilabel:`.env` file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: In order to generate new strong random passwords you can use an online service like https://passwordsgenerator.net/
    
    Avoid using Symbols ( e.g. @#$% ) as they might conflict with :guilabel:`.env` file

.. code-block:: diff

    --- my_geonode\.env
    +++ my_geonode\.prod.env
    @@ -6,13 +6,13 @@
    # See https://github.com/geosolutions-it/geonode-generic/issues/28
    # to see why we force API version to 1.24
    DOCKER_API_VERSION="1.24"
    
    C_FORCE_ROOT=1
    IS_CELERY=false
    -IS_FIRST_START=true
    +IS_FIRST_START=false
    FORCE_REINIT=false
    
    SITEURL=https://my_geonode.geonode.org/
    ALLOWED_HOSTS=['django',]
    
    # LANGUAGE_CODE=pt
    @@ -38,13 +38,14 @@
    # #################
    # geoserver
    # #################
    GEOSERVER_WEB_UI_LOCATION=https://my_geonode.geonode.org/geoserver/
    GEOSERVER_PUBLIC_LOCATION=https://my_geonode.geonode.org/geoserver/
    GEOSERVER_LOCATION=http://geoserver:8080/geoserver/
    -GEOSERVER_ADMIN_PASSWORD=geoserver
    +GEOSERVER_ADMIN_USER=admin
    +GEOSERVER_ADMIN_PASSWORD=<new_geoserver_admin_password>
    
    OGC_REQUEST_TIMEOUT=30
    OGC_REQUEST_MAX_RETRIES=1
    OGC_REQUEST_BACKOFF_FACTOR=0.3
    OGC_REQUEST_POOL_MAXSIZE=10
    OGC_REQUEST_POOL_CONNECTIONS=10
    @@ -84,13 +85,13 @@
    RESOLVER=127.0.0.11
    
    # #################
    # Security
    # #################
    # Admin Settings
    -ADMIN_PASSWORD=admin
    +ADMIN_PASSWORD=<new_geonode_admin_password>
    ADMIN_EMAIL=admin@my_geonode.geonode.org
    
    # EMAIL Notifications
    EMAIL_ENABLE=False
    DJANGO_EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
    DJANGO_EMAIL_HOST=localhost
    @@ -114,15 +115,15 @@
    ACCOUNT_CONFIRM_EMAIL_ON_GET=False
    ACCOUNT_EMAIL_VERIFICATION=optional
    ACCOUNT_EMAIL_CONFIRMATION_EMAIL=False
    ACCOUNT_EMAIL_CONFIRMATION_REQUIRED=False
    
    # OAuth2
    -OAUTH2_API_KEY=
    -OAUTH2_CLIENT_ID=Jrchz2oPY3akmzndmgUTYrs9gczlgoV20YPSvqaV
    -OAUTH2_CLIENT_SECRET=rCnp5txobUo83EpQEblM8fVj3QT5zb5qRfxNsuPzCqZaiRyIoxM4jdgMiZKFfePBHYXCLd7B8NlkfDBY9HKeIQPcy5Cp08KQNpRHQbjpLItDHv12GvkSeXp6OxaUETv3
    +OAUTH2_API_KEY=<new_OAUTH2_API_KEY>
    +OAUTH2_CLIENT_ID=<new_OAUTH2_CLIENT_ID>
    +OAUTH2_CLIENT_SECRET=<new_OAUTH2_CLIENT_SECRET>
    
    # GeoNode APIs
    API_LOCKDOWN=False
    TASTYPIE_APIKEY=
    
    # #################

[Optional] Update your SSH Certificates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In production deployment mode, GeoNode uses by default :guilabel:`Let's Encrypt` certificates

You may want to provide your own certificates to GeoNode

.. code-block:: shell

    docker exec -it nginx4my_geonode_geonode sh -c 'mkdir /geonode-certificates/my_geonode'

    wget --no-check-certificate 'http://<url_to_your_chain.crt>' \
        -O chain.crt

    wget --no-check-certificate 'http://<url_to_your_key.key>' \
        -O my_geonode.key

    docker cp chain.crt nginx4my_geonode_geonode:/geonode-certificates/my_geonode

    docker cp my_geonode.key nginx4my_geonode_geonode:/geonode-certificates/my_geonode

    docker-compose exec geonode sh
    apk add vim

    vim nginx.https.enabled.conf


.. code-block:: diff

        -ssl_certificate     /certificate_symlink/fullchain.pem;
        -ssl_certificate_key /certificate_symlink/privkey.pem;
        +ssl_certificate       /geonode-certificates/my_geonode/chain.crt;
        +ssl_certificate_key   /geonode-certificates/my_geonode/my_geonode.key;


.. code-block:: shell

    nginx -s reload
    exit


Restart the GeoNode and NGINX containers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Whenever you change someting on :guilabel:`.env` file, you will need to rebuild the container

.. warning:: **Be careful!** The following command drops any change you might have done manually inside the containers, except for the static volumes.

.. code-block:: shell

  docker-compose up -d django
  docker-compose restart geonode

