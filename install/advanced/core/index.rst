.. _geonode-vanilla:

===============
GeoNode Vanilla
===============

Overview
========

The following steps will guide you to a fresh setup of GeoNode.

All guides will first install and configure the system to run it in ``DEBUG`` mode (also known as ``DEVELOPMENT`` mode)
and then by configuring an HTTPD server to serve GeoNode through the standard ``HTTP`` (``80``) port.

.. warning:: Those guides **are not** meant to be used on a production system.
  There will be dedicated chapters that will show you some *hints* to optimize GeoNode for a production-ready machine.
  In any case, we strongly suggest to task an experienced *DevOp* or *System Administrator* before exposing your server to the ``WEB``.

Ubuntu 22.04 LTS
=================

This part of the documentation describes the complete setup process for GeoNode on an Ubuntu 22.04.1LTS **64-bit** clean environment (Desktop or Server).

All examples use shell commands that you must enter on a local terminal or a remote shell.

- If you have a graphical desktop environment you can open the terminal application after login;
- if you are working on a remote server the provider or sysadmin should has given you access through an ssh client.

.. _install_dep:

1. Install the dependencies
^^^^^^^^^^^^^^^^^^^^^^^^^^^

In this section, we are going to install all the basic packages and tools needed for a complete GeoNode installation.

.. warning:: To follow this guide, a basic knowledge about Ubuntu Server configuration and working with a shell is required.

.. note:: This guide uses ``vim`` as the editor; fill free to use ``nano``, ``gedit`` or others.

Upgrade system packages
.......................

Check that your system is already up-to-date with the repository running the following commands:

.. code-block:: shell

   sudo add-apt-repository ppa:ubuntugis/ppa
   sudo apt update -y


Packages Installation
.....................

.. note:: You don't need to install the **system packages** if you want to run the project using Docker

We will use **example.org** as fictitious Domain Name.

First, we are going to install all the **system packages** needed for the GeoNode setup. Login to the target machine and execute the following commands:

.. code-block:: shell

  # Install packages from GeoNode core
  sudo apt install -y --allow-downgrades build-essential \
    python3-gdal=3.4.1+dfsg-1build4 gdal-bin=3.4.1+dfsg-1build4 libgdal-dev=3.4.1+dfsg-1build4 \
    python3-all-dev python3.10-dev python3.10-venv virtualenvwrapper \
    libxml2 libxml2-dev gettext libmemcached-dev zlib1g-dev \
    libxslt1-dev libjpeg-dev libpng-dev libpq-dev \
    software-properties-common build-essential \
    git unzip gcc zlib1g-dev libgeos-dev libproj-dev \
    sqlite3 spatialite-bin libsqlite3-mod-spatialite libsqlite3-dev

  # Install Openjdk
  sudo apt install openjdk-11-jdk-headless default-jdk-headless -y

  # Verify GDAL version
  gdalinfo --version
    $> GDAL 3.4.1, released 2021/12/27

  # Verify Python version
  python3.10 --version
    $> Python 3.10.4

  which python3.10
    $> /usr/bin/python3.10

  # Verify Java version
  java -version
    $> openjdk version "11.0.16"

  # Install VIM
  sudo apt install -y vim

  # Cleanup the packages
  sudo apt update -y; sudo apt autoremove --purge

.. warning:: GeoNode 4.2.x is not compatible with Python < 3.7

.. _install_venv:

2. GeoNode Installation
^^^^^^^^^^^^^^^^^^^^^^^

This is the most basic installation of GeoNode. It won't use any external server like ``Apache Tomcat``, ``PostgreSQL`` or ``HTTPD``.

First of all we need to prepare a new Python Virtual Environment

Since geonode needs a large number of different python libraries and packages, its recommended to use a python virtual environment to avoid conflicts on dependencies with system wide python packages and other installed software. See also documentation of `Virtualenvwrapper <https://virtualenvwrapper.readthedocs.io/en/stable/>`_ package for more information

.. note:: The GeoNode Virtual Environment must be created only the first time. You won't need to create it again everytime.

.. code-block:: shell

  which python3.10  # copy the path of python executable

  # Create the GeoNode Virtual Environment (first time only)
  export WORKON_HOME=~/.virtualenvs
  source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
  mkvirtualenv --python=/usr/bin/python3.10 geonode  # Use the python path from above

  # Alterantively you can also create the virtual env like below
  mkdir -p ~/.virtualenvs
  python3.10 -m venv ~/.virtualenvs/geonode
  source ~/.virtualenvs/geonode/bin/activate


At this point your command prompt shows a ``(geonode)`` prefix, this indicates that your virtualenv is active.

.. note:: The next time you need to access the Virtual Environment just run

  .. code-block:: shell

    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
    workon geonode

    # Alterantively you can also create the virtual env like below
    source ~/.virtualenvs/geonode/bin/activate

.. note:: In order to save permanently the virtualenvwrapper environment

  .. code-block:: shell

    vim ~/.bashrc

    # Write to the bottom of the file the following lines
    export WORKON_HOME=~/.virtualenvs
    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh

.. code-block:: shell

  # Let's create the GeoNode core base folder and clone it
  sudo mkdir -p /opt/geonode/; sudo usermod -a -G www-data $USER; sudo chown -Rf $USER:www-data /opt/geonode/; sudo chmod -Rf 775 /opt/geonode/

  # Clone the GeoNode source code on /opt/geonode
  cd /opt; git clone https://github.com/GeoNode/geonode.git -b 4.2.x geonode

.. code-block:: shell

  # Install the Python packages
  cd /opt/geonode
  pip install -r requirements.txt --upgrade
  pip install -e . --upgrade
  pip install pygdal=="`gdal-config --version`.*"


.. _configure_dbs_core:

3. Postgis database Setup
^^^^^^^^^^^^^^^^^^^^^^^^^

.. warning::

Be sure you have successfully completed all the steps of the section :ref:`install_dep`.

In this section, we are going to setup users and databases for GeoNode in PostgreSQL.

Install and Configure the PostgreSQL Database System
....................................................

In this section we are going to install the ``PostgreSQL`` packages along with the ``PostGIS`` extension. Those steps must be done **only** if you don't have the DB already installed on your system.

.. code-block:: shell

  # Ubuntu 22.04.1 (focal)
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
  sudo wget --no-check-certificate --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  sudo apt update -y; sudo apt install -y postgresql-13 postgresql-13-postgis-3 postgresql-13-postgis-3-scripts postgresql-13 postgresql-client-13

We now must create two databases, ``geonode`` and ``geonode_data``, belonging to the role ``geonode``.

.. warning:: This is our default configuration.
  You can use any database or role you need.
  The connection parameters must be correctly configured on ``settings``, as we will see later in this section.

Databases and Permissions
.........................

First, create the geonode user. GeoNode is going to use this user to access the database

.. code-block:: shell

  sudo service postgresql start
  sudo -u postgres createuser -P geonode

  # Use the password: geonode

You will be prompted asked to set a password for the user. **Enter geonode as password**.

.. warning:: This is a sample password used for the sake of simplicity. This password is very **weak** and should be changed in a production environment.

Create database ``geonode`` and ``geonode_data`` with owner ``geonode``

.. code-block:: shell

  sudo -u postgres createdb -O geonode geonode
  sudo -u postgres createdb -O geonode geonode_data

Next let's create PostGIS extensions

.. code-block:: shell

  sudo -u postgres psql -d geonode -c 'CREATE EXTENSION postgis;'
  sudo -u postgres psql -d geonode -c 'GRANT ALL ON geometry_columns TO PUBLIC;'
  sudo -u postgres psql -d geonode -c 'GRANT ALL ON spatial_ref_sys TO PUBLIC;'
  sudo -u postgres psql -d geonode -c 'GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO geonode;'
  sudo -u postgres psql -d geonode -c 'GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO geonode;'

  sudo -u postgres psql -d geonode_data -c 'CREATE EXTENSION postgis;'
  sudo -u postgres psql -d geonode_data -c 'GRANT ALL ON geometry_columns TO PUBLIC;'
  sudo -u postgres psql -d geonode_data -c 'GRANT ALL ON spatial_ref_sys TO PUBLIC;'
  sudo -u postgres psql -d geonode_data -c 'GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO geonode;'
  sudo -u postgres psql -d geonode_data -c 'GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO geonode;'

Final step is to change user access policies for local connections in the file ``pg_hba.conf``

.. code-block:: shell

  sudo vim /etc/postgresql/13/main/pg_hba.conf

Scroll down to the bottom of the document. We want to make local connection ``trusted`` for the default user.

Make sure your configuration looks like the one below.

.. code-block:: shell

    ...
    # DO NOT DISABLE!
    # If you change this first entry you will need to make sure that the
    # database superuser can access the database using some other method.
    # Noninteractive access to all databases is required during automatic
    # maintenance (custom daily cronjobs, replication, and similar tasks).
    #
    # Database administrative login by Unix domain socket
    local   all             postgres                                trust

    # TYPE  DATABASE        USER            ADDRESS                 METHOD

    # "local" is for Unix domain socket connections only
    local   all             all                                     md5
    # IPv4 local connections:
    host    all             all             127.0.0.1/32            md5
    # IPv6 local connections:
    host    all             all             ::1/128                 md5
    # Allow replication connections from localhost, by a user with the
    # replication privilege.
    local   replication     all                                     peer
    host    replication     all             127.0.0.1/32            md5
    host    replication     all             ::1/128                 md5

.. warning:: If your ``PostgreSQL`` database resides on a **separate/remote machine**, you'll have to **allow** remote access to the databases in the ``/etc/postgresql/13/main/pg_hba.conf`` to the ``geonode`` user and tell PostgreSQL to **accept** non-local connections in your ``/etc/postgresql/13/main/postgresql.conf`` file

Restart PostgreSQL to make the change effective.

.. code-block:: shell

  sudo service postgresql restart

PostgreSQL is now ready. To test the configuration, try to connect to the ``geonode`` database as ``geonode`` role.

.. code-block:: shell

  psql -U postgres geonode
  # This should not ask for any password

  psql -U geonode geonode
  # This should ask for the password geonode

  # Repeat the test with geonode_data DB
  psql -U postgres geonode_data
  psql -U geonode geonode_data


4. Install GeoServer
^^^^^^^^^^^^^^^^^^^^

In this section, we are going to install the ``Apache Tomcat 8`` Servlet Java container, which will be started by default on the internal port ``8080``.

We will also perform several optimizations to:

1. Correctly setup the Java VM Options, like the available heap memory and the garbage collector options.
2. Externalize the ``GeoServer`` and ``GeoWebcache`` catalogs in order to allow further updates without the risk of deleting our datasets.

.. note:: This is still a basic setup of those components. More details will be provided on sections of the documentation concerning the hardening of the system in a production environment. Nevertheless, you will need to tweak a bit those settings accordingly with your current system. As an instance, if your machine does not have enough memory, you will need to lower down the initial amount of available heap memory. **Warnings** and **notes** will be placed below the statements that will require your attention.

Install Apache Tomcat
............................

The reference version of Tomcat for the Geoserver for GeoNode is **Tomcat 9**.


The following steps have been adapted from https://yallalabs.com/linux/ubuntu/how-to-install-apache-tomcat-9-ubuntu-20-04/

.. warning:: Apache Tomcat 9 and Geoserver require Java 11 or newer to be installed on the server.
  Check the steps before in order to be sure you have OpenJDK 11 correctly installed on your system.

First, it is not recommended to run Apache Tomcat as user root, so we will create a new system user which will run the Apache Tomcat server

.. code-block:: shell

  sudo useradd -m -U -d /opt/tomcat -s /bin/bash tomcat
  sudo usermod -a -G www-data tomcat

.. warning:: Now, go to the official Apache Tomcat `website <https://tomcat.apache.org/>`_ and download the most recent version of the software to your server. But don't use Tomcat10 because there are still some errors between Geoserver and Tomcat. 

.. code-block:: shell

  VERSION=9.0.65; wget https://archive.apache.org/dist/tomcat/tomcat-9/v${VERSION}/bin/apache-tomcat-${VERSION}.tar.gz


Once the download is complete, extract the tar file to the /opt/tomcat directory:

.. code-block:: shell

  sudo mkdir /opt/tomcat
  sudo tar -xf apache-tomcat-${VERSION}.tar.gz -C /opt/tomcat/; rm apache-tomcat-${VERSION}.tar.gz

Apache Tomcat is updated regulary. So, to have more control over versions and updates, we’ll create a symbolic link as below:

.. code-block:: shell

  sudo ln -s /opt/tomcat/apache-tomcat-${VERSION} /opt/tomcat/latest

Now, let’s change the ownership of all Apache Tomcat files as below:

.. code-block:: shell

  sudo chown -R tomcat:www-data /opt/tomcat/

Make the shell scripts inside the bin directory executable:

.. code-block:: shell

  sudo sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'

Create the a systemd file with the following content:

.. code-block:: shell

  # Check the correct JAVA_HOME location
  JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
  echo $JAVA_HOME
    $> /usr/lib/jvm/java-1.11.0-openjdk-amd64/jre/

  # Let's create a symbolic link to the JRE
  sudo ln -s /usr/lib/jvm/java-1.11.0-openjdk-amd64/jre/ /usr/lib/jvm/jre

  # Let's create the tomcat service
  sudo vim /etc/systemd/system/tomcat9.service

.. code-block:: bash

  [Unit]
  Description=Tomcat 9 servlet container
  After=network.target

  [Service]
  Type=forking

  User=tomcat
  Group=tomcat

  Environment="JAVA_HOME=/usr/lib/jvm/jre"
  Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true"

  Environment="CATALINA_BASE=/opt/tomcat/latest"
  Environment="CATALINA_HOME=/opt/tomcat/latest"
  Environment="CATALINA_PID=/opt/tomcat/latest/temp/tomcat.pid"
  Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

  ExecStart=/opt/tomcat/latest/bin/startup.sh
  ExecStop=/opt/tomcat/latest/bin/shutdown.sh

  [Install]
  WantedBy=multi-user.target

Now you can start the Apache Tomcat 9 server and enable it to start on boot time using the following command:

.. code-block:: shell

  sudo systemctl daemon-reload
  sudo systemctl start tomcat9.service
  sudo systemctl status tomcat9.service
  sudo systemctl enable tomcat9.service


For verification, type the following ss command, which will show you the 8080 open port number, the default open port reserved for Apache Tomcat Server.

.. code-block:: shell

  ss -ltn

In a clean Ubuntu 22.04.1, the ss command may not be found and the iproute2 library should be installed first.

.. code-block:: shell

  sudo apt install iproute2
  # Then run the ss command
  ss -ltn

In a clean Ubuntu 22.04.1, the ss command may not be found and the iproute2 library should be installed first.

.. code-block:: shell

  sudo apt install iproute2
  # Then run the ss command
  ss -ltn

If your server is protected by a firewall and you want to access Tomcat from the outside of your local network, you need to open port 8080.

Use the following command to open the necessary port:

.. code-block:: shell

  sudo ufw allow 8080/tcp

.. warning:: Generally, when running Tomcat in a production environment, you should use a load balancer or reverse proxy.

  It’s a best practice to allow access to port ``8080`` only from your internal network.

  We will use ``NGINX`` in order to provide Apache Tomcat through the standard ``HTTP`` port.

.. note:: Alternatively you can define the Tomcat Service as follow, in case you would like to use ``systemctl``

  .. code-block:: shell

    sudo vim /usr/lib/systemd/system/tomcat9.service

  .. code-block:: ini

    [Unit]
    Description=Apache Tomcat Server
    After=syslog.target network.target

    [Service]
    Type=forking
    User=tomcat
    Group=tomcat

    Environment=JAVA_HOME=/usr/lib/jvm/jre
    Environment=JAVA_OPTS=-Djava.security.egd=file:///dev/urandom
    Environment=CATALINA_PID=/opt/tomcat/latest/temp/tomcat.pid
    Environment=CATALINA_HOME=/opt/tomcat/latest
    Environment=CATALINA_BASE=/opt/tomcat/latest

    ExecStart=/opt/tomcat/latest/bin/startup.sh
    ExecStop=/opt/tomcat/latest/bin/shutdown.sh

    RestartSec=30
    Restart=always

    [Install]
    WantedBy=multi-user.target

  .. code-block:: shell

    sudo systemctl daemon-reload
    sudo systemctl enable tomcat9.service
    sudo systemctl start tomcat9.service

Install GeoServer on Tomcat
............................

Let's externalize the ``GEOSERVER_DATA_DIR`` and ``logs``

.. code-block:: shell

  # Create the target folders
  sudo mkdir -p /opt/data
  sudo chown -Rf $USER:www-data /opt/data
  sudo chmod -Rf 775 /opt/data
  sudo mkdir -p /opt/data/logs
  sudo chown -Rf $USER:www-data /opt/data/logs
  sudo chmod -Rf 775 /opt/data/logs

  # Download and extract the default GEOSERVER_DATA_DIR
  GS_VERSION=2.24.2
  sudo wget --no-check-certificate "https://artifacts.geonode.org/geoserver/$GS_VERSION/geonode-geoserver-ext-web-app-data.zip" -O data-$GS_VERSION.zip
  
  sudo unzip data-$GS_VERSION.zip -d /opt/data/

  sudo mv /opt/data/data/ /opt/data/geoserver_data
  sudo chown -Rf tomcat:www-data /opt/data/geoserver_data
  sudo chmod -Rf 775 /opt/data/geoserver_data

  sudo mkdir -p /opt/data/geoserver_logs
  sudo chown -Rf tomcat:www-data /opt/data/geoserver_logs
  sudo chmod -Rf 775 /opt/data/geoserver_logs

  sudo mkdir -p /opt/data/gwc_cache_dir
  sudo chown -Rf tomcat:www-data /opt/data/gwc_cache_dir
  sudo chmod -Rf 775 /opt/data/gwc_cache_dir

  # Download and install GeoServer
  sudo wget --no-check-certificate "https://artifacts.geonode.org/geoserver/$GS_VERSION/geoserver.war" -O geoserver-$GS_VERSION.war
  sudo mv geoserver-$GS_VERSION.war /opt/tomcat/latest/webapps/geoserver.war

Let's now configure the ``JAVA_OPTS``, i.e. the parameters to run the Servlet Container, like heap memory, garbage collector and so on.

.. code-block:: shell

  sudo sed -i -e 's/xom-\*\.jar/xom-\*\.jar,bcprov\*\.jar/g' /opt/tomcat/latest/conf/catalina.properties

  export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
  echo 'JAVA_HOME='$JAVA_HOME | sudo tee --append /opt/tomcat/latest/bin/setenv.sh
  sudo sed -i -e "s/JAVA_OPTS=/#JAVA_OPTS=/g" /opt/tomcat/latest/bin/setenv.sh

  echo 'GEOSERVER_DATA_DIR="/opt/data/geoserver_data"' | sudo tee --append /opt/tomcat/latest/bin/setenv.sh
  echo 'GEOSERVER_LOG_LOCATION="/opt/data/geoserver_logs/geoserver.log"' | sudo tee --append /opt/tomcat/latest/bin/setenv.sh
  echo 'GEOWEBCACHE_CACHE_DIR="/opt/data/gwc_cache_dir"' | sudo tee --append /opt/tomcat/latest/bin/setenv.sh
  echo 'GEOFENCE_DIR="$GEOSERVER_DATA_DIR/geofence"' | sudo tee --append /opt/tomcat/latest/bin/setenv.sh
  echo 'TIMEZONE="UTC"' | sudo tee --append /opt/tomcat/latest/bin/setenv.sh

  echo 'JAVA_OPTS="-server -Djava.awt.headless=true -Dorg.geotools.shapefile.datetime=false -DGS-SHAPEFILE-CHARSET=UTF-8 -XX:+UseParallelGC -XX:ParallelGCThreads=4 -Dfile.encoding=UTF8 -Duser.timezone=$TIMEZONE -Xms512m -Xmx4096m -Djavax.servlet.request.encoding=UTF-8 -Djavax.servlet.response.encoding=UTF-8 -DGEOSERVER_CSRF_DISABLED=true -DPRINT_BASE_URL=http://localhost:8080/geoserver/pdf -DGEOSERVER_DATA_DIR=$GEOSERVER_DATA_DIR -Dgeofence.dir=$GEOFENCE_DIR -DGEOSERVER_LOG_LOCATION=$GEOSERVER_LOG_LOCATION -DGEOWEBCACHE_CACHE_DIR=$GEOWEBCACHE_CACHE_DIR -Dgwc.context.suffix=gwc"' | sudo tee --append /opt/tomcat/latest/bin/setenv.sh

.. note:: After the execution of the above statements, you should be able to see the new options written at the bottom of the file ``/opt/tomcat/latest/bin/setenv.sh``.

  .. code-block:: shell

      ...
      # If you run Tomcat on port numbers that are all higher than 1023, then you
      # do not need authbind.  It is used for binding Tomcat to lower port numbers.
      # (yes/no, default: no)
      #AUTHBIND=no
      JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64/jre/
      GEOSERVER_DATA_DIR="/opt/data/geoserver_data"
      GEOSERVER_LOG_LOCATION="/opt/data/geoserver_logs/geoserver.log"
      GEOWEBCACHE_CACHE_DIR="/opt/data/gwc_cache_dir"
      GEOFENCE_DIR="$GEOSERVER_DATA_DIR/geofence"
      TIMEZONE="UTC"
      JAVA_OPTS="-server -Djava.awt.headless=true -Dorg.geotools.shapefile.datetime=false -DGS-SHAPEFILE-CHARSET=UTF-8 -XX:+UseParallelGC -XX:ParallelGCThreads=4 -Dfile.encoding=UTF8 -Duser.timezone=$TIMEZONE -Xms512m -Xmx4096m -Djavax.servlet.request.encoding=UTF-8 -Djavax.servlet.response.encoding=UTF-8 -DGEOSERVER_CSRF_DISABLED=true -DPRINT_BASE_URL=http://localhost:8080/geoserver/pdf -DGEOSERVER_DATA_DIR=$GEOSERVER_DATA_DIR -Dgeofence.dir=$GEOFENCE_DIR -DGEOSERVER_LOG_LOCATION=$GEOSERVER_LOG_LOCATION -DGEOWEBCACHE_CACHE_DIR=$GEOWEBCACHE_CACHE_DIR"

  Those options could be updated or changed manually at any time, accordingly to your needs.

.. warning:: The default options we are going to add to the Servlet Container, assume you can reserve at least ``4GB`` of ``RAM`` to ``GeoServer`` (see the option ``-Xmx4096m``). You must be sure your machine has enough memory to run both ``GeoServer`` and ``GeoNode``, which in this case means at least ``4GB`` for ``GeoServer`` plus at least ``2GB`` for ``GeoNode``. A total of at least ``6GB`` of ``RAM`` available on your machine. If you don't have enough ``RAM`` available, you can lower down the values ``-Xms512m -Xmx4096m``. Consider that with less ``RAM`` available, the performances of your services will be highly impacted.

Conifgure the Geofence DB
............................

Before starting the service, Geofence must be configured to connect to the PostgreSQL DB, where its rules will be stored. 

.. warning:: In previous versions this step was optional and a file-based H2 DB could be used. This option has been dropped since using H2 is highly discouraged.

Open the ``geofence-datasource-ovr.properties`` file for edit:

.. code-block:: shell

  sudo vim /opt/data/geoserver_data/geofence/geofence-datasource-ovr.properties

And paste the following code by replace the placehoders with the required files

.. code-block:: shell

  geofenceVendorAdapter.databasePlatform=org.hibernatespatial.postgis.PostgisDialect
  geofenceDataSource.driverClassName=org.postgresql.Driver
  geofenceDataSource.url=jdbc:postgresql://localhost:5432/geonode_data
  geofenceDataSource.username=geonode
  geofenceDataSource.password=geonode
  geofenceEntityManagerFactory.jpaPropertyMap[hibernate.default_schema]=public


In order to make the changes effective, you'll need to restart the Servlet Container.

.. code-block:: shell

  # Restart the server
  sudo /etc/init.d/tomcat9 restart

  # Follow the startup logs
  sudo tail -F -n 300 /opt/data/geoserver_logs/geoserver.log

If you can see on the logs something similar to this, without errors

.. code-block:: shell

  ...
  2019-05-31 10:06:34,190 INFO [geoserver.wps] - Found 5 bindable processes in GeoServer specific processes
  2019-05-31 10:06:34,281 INFO [geoserver.wps] - Found 89 bindable processes in Deprecated processes
  2019-05-31 10:06:34,298 INFO [geoserver.wps] - Found 31 bindable processes in Vector processes
  2019-05-31 10:06:34,307 INFO [geoserver.wps] - Found 48 bindable processes in Geometry processes
  2019-05-31 10:06:34,307 INFO [geoserver.wps] - Found 1 bindable processes in PolygonLabelProcess
  2019-05-31 10:06:34,311 INFO [geoserver.wps] - Blacklisting process ras:ConvolveCoverage as the input kernel of type class javax.media.jai.KernelJAI cannot be handled
  2019-05-31 10:06:34,319 INFO [geoserver.wps] - Blacklisting process ras:RasterZonalStatistics2 as the input zones of type class java.lang.Object cannot be handled
  2019-05-31 10:06:34,320 INFO [geoserver.wps] - Blacklisting process ras:RasterZonalStatistics2 as the input nodata of type class it.geosolutions.jaiext.range.Range cannot be handled
  2019-05-31 10:06:34,320 INFO [geoserver.wps] - Blacklisting process ras:RasterZonalStatistics2 as the input rangeData of type class java.lang.Object cannot be handled
  2019-05-31 10:06:34,320 INFO [geoserver.wps] - Blacklisting process ras:RasterZonalStatistics2 as the output zonal statistics of type interface java.util.List cannot be handled
  2019-05-31 10:06:34,321 INFO [geoserver.wps] - Found 18 bindable processes in Raster processes
  2019-05-31 10:06:34,917 INFO [ows.OWSHandlerMapping] - Mapped URL path [/TestWfsPost] onto handler 'wfsTestServlet'
  2019-05-31 10:06:34,918 INFO [ows.OWSHandlerMapping] - Mapped URL path [/wfs/*] onto handler 'dispatcher'
  2019-05-31 10:06:34,918 INFO [ows.OWSHandlerMapping] - Mapped URL path [/wfs] onto handler 'dispatcher'
  2019-05-31 10:06:42,237 INFO [geoserver.security] - Start reloading user/groups for service named default
  2019-05-31 10:06:42,241 INFO [geoserver.security] - Reloading user/groups successful for service named default
  2019-05-31 10:06:42,357 WARN [auth.GeoFenceAuthenticationProvider] - INIT FROM CONFIG
  2019-05-31 10:06:42,494 INFO [geoserver.security] - AuthenticationCache Initialized with 1000 Max Entries, 300 seconds idle time, 600 seconds time to live and 3 concurrency level
  2019-05-31 10:06:42,495 INFO [geoserver.security] - AuthenticationCache Eviction Task created to run every 600 seconds
  2019-05-31 10:06:42,506 INFO [config.GeoserverXMLResourceProvider] - Found configuration file in /opt/data/gwc_cache_dir
  2019-05-31 10:06:42,516 INFO [config.GeoserverXMLResourceProvider] - Found configuration file in /opt/data/gwc_cache_dir
  2019-05-31 10:06:42,542 INFO [config.XMLConfiguration] - Wrote configuration to /opt/data/gwc_cache_dir
  2019-05-31 10:06:42,547 INFO [geoserver.importer] - Enabling import store: memory

Your ``GeoServer`` should be up and running at

.. code-block:: shell

  http://localhost:8080/geoserver/

.. warning:: In case of errors or the file ``geoserver.log`` is not created, check the Catalina logs in order to try to understand what's happened.

  .. code-block:: shell

    sudo less /opt/tomcat/latest/logs/catalina.out

5. Web Server
^^^^^^^^^^^^^

Until now we have seen how to start ``GeoNode`` in ``DEBUG`` mode from the command line, through the ``paver`` utilities. This is of course not the best way to start it. Moreover you will need a dedicated ``HTTPD`` server running on port ``80`` if you would like to expose your server to the world.

In this section we will see:

1. How to configure ``NGINX`` HTTPD Server to host ``GeoNode`` and ``GeoServer``. In the initial setup we will still run the services on ``http://localhost``
2. Update the ``settings`` in order to link ``GeoNode`` and ``GeoServer`` to the ``PostgreSQL`` Database.
3. Update the ``settings`` in order to update ``GeoNode`` and ``GeoServer`` services running on a **public IP** or **hostname**.
4. Install and enable ``HTTPS`` secured connection through the ``Let's Encrypt`` provider.

Install and configure NGINX
...........................

.. warning:: Seems to be possible that NGINX works with Python 3.6 and not with 3.8.

.. code-block:: shell

  # Install the services
  sudo apt install -y nginx uwsgi uwsgi-plugin-python3

Serving {“geonode”, “geoserver”} via NGINX
..........................................

.. code-block:: shell

  # Create the GeoNode UWSGI config
  sudo vim /etc/uwsgi/apps-available/geonode.ini

.. warning:: **!IMPORTANT!**

    Change the line ``virtualenv = /home/<my_user>/.virtualenvs/geonode`` below with your current user home directory!

    e.g.: If the user is ``afabiani`` then ``virtualenv = /home/afabiani/.virtualenvs/geonode``

.. code-block:: ini

  [uwsgi]
  uwsgi-socket = 0.0.0.0:8000
  # http-socket = 0.0.0.0:8000

  gid = www-data

  plugins = python3
  virtualenv = /home/<my_user>/.virtualenvs/geonode

  env = DJANGO_SETTINGS_MODULE=geonode.settings
  env = GEONODE_INSTANCE_NAME=geonode
  env = GEONODE_LB_HOST_IP=
  env = GEONODE_LB_PORT=

  # #################
  # backend
  # #################
  env = POSTGRES_USER=postgres
  env = POSTGRES_PASSWORD=postgres
  env = GEONODE_DATABASE=geonode
  env = GEONODE_DATABASE_PASSWORD=geonode
  env = GEONODE_GEODATABASE=geonode_data
  env = GEONODE_GEODATABASE_PASSWORD=geonode
  env = GEONODE_DATABASE_SCHEMA=public
  env = GEONODE_GEODATABASE_SCHEMA=public
  env = DATABASE_HOST=localhost
  env = DATABASE_PORT=5432
  env = DATABASE_URL=postgis://geonode:geonode@localhost:5432/geonode
  env = GEODATABASE_URL=postgis://geonode:geonode@localhost:5432/geonode_data
  env = GEONODE_DB_CONN_MAX_AGE=0
  env = GEONODE_DB_CONN_TOUT=5
  env = DEFAULT_BACKEND_DATASTORE=datastore
  env = BROKER_URL=amqp://admin:admin@localhost:5672//
  env = ASYNC_SIGNALS=False

  env = SITEURL=http://localhost/

  env = ALLOWED_HOSTS="['*']"

  # Data Uploader
  env = DEFAULT_BACKEND_UPLOADER=geonode.importer
  env = TIME_ENABLED=True
  env = MOSAIC_ENABLED=False
  env = HAYSTACK_SEARCH=False
  env = HAYSTACK_ENGINE_URL=http://elasticsearch:9200/
  env = HAYSTACK_ENGINE_INDEX_NAME=haystack
  env = HAYSTACK_SEARCH_RESULTS_PER_PAGE=200

  # #################
  # nginx
  # HTTPD Server
  # #################
  env = GEONODE_LB_HOST_IP=localhost
  env = GEONODE_LB_PORT=80

  # IP or domain name and port where the server can be reached on HTTPS (leave HOST empty if you want to use HTTP only)
  # port where the server can be reached on HTTPS
  env = HTTP_HOST=localhost
  env = HTTPS_HOST=

  env = HTTP_PORT=8000
  env = HTTPS_PORT=443

  # #################
  # geoserver
  # #################
  env = GEOSERVER_WEB_UI_LOCATION=http://localhost/geoserver/
  env = GEOSERVER_PUBLIC_LOCATION=http://localhost/geoserver/
  env = GEOSERVER_LOCATION=http://localhost:8080/geoserver/
  env = GEOSERVER_ADMIN_USER=admin
  env = GEOSERVER_ADMIN_PASSWORD=geoserver

  env = OGC_REQUEST_TIMEOUT=5
  env = OGC_REQUEST_MAX_RETRIES=1
  env = OGC_REQUEST_BACKOFF_FACTOR=0.3
  env = OGC_REQUEST_POOL_MAXSIZE=10
  env = OGC_REQUEST_POOL_CONNECTIONS=10

  # Java Options & Memory
  env = ENABLE_JSONP=true
  env = outFormat=text/javascript
  env = GEOSERVER_JAVA_OPTS="-Djava.awt.headless=true -Xms2G -Xmx4G -XX:+UnlockDiagnosticVMOptions -XX:+LogVMOutput -XX:LogFile=/var/log/jvm.log -XX:PerfDataSamplingInterval=500 -XX:SoftRefLRUPolicyMSPerMB=36000 -XX:-UseGCOverheadLimit -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:ParallelGCThreads=4 -Dfile.encoding=UTF8 -Djavax.servlet.request.encoding=UTF-8 -Djavax.servlet.response.encoding=UTF-8 -Duser.timezone=GMT -Dorg.geotools.shapefile.datetime=false -DGS-SHAPEFILE-CHARSET=UTF-8 -DGEOSERVER_CSRF_DISABLED=true -DPRINT_BASE_URL=http://geoserver:8080/geoserver/pdf -DALLOW_ENV_PARAMETRIZATION=true -Xbootclasspath/a:/usr/local/tomcat/webapps/geoserver/WEB-INF/lib/marlin-0.9.3-Unsafe.jar -Dsun.java2d.renderer=org.marlin.pisces.MarlinRenderingEngine"

  # #################
  # Security
  # #################
  # Admin Settings
  env = ADMIN_USERNAME=admin
  env = ADMIN_PASSWORD=admin
  env = ADMIN_EMAIL=admin@localhost

  # EMAIL Notifications
  env = EMAIL_ENABLE=False
  env = DJANGO_EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
  env = DJANGO_EMAIL_HOST=localhost
  env = DJANGO_EMAIL_PORT=25
  env = DJANGO_EMAIL_HOST_USER=
  env = DJANGO_EMAIL_HOST_PASSWORD=
  env = DJANGO_EMAIL_USE_TLS=False
  env = DJANGO_EMAIL_USE_SSL=False
  env = DEFAULT_FROM_EMAIL='GeoNode <no-reply@geonode.org>'

  # Session/Access Control
  env = LOCKDOWN_GEONODE=False
  env = CORS_ORIGIN_ALLOW_ALL=True
  env = X_FRAME_OPTIONS="SAMEORIGIN"
  env = SESSION_EXPIRED_CONTROL_ENABLED=True
  env = DEFAULT_ANONYMOUS_VIEW_PERMISSION=True
  env = DEFAULT_ANONYMOUS_DOWNLOAD_PERMISSION=True

  # Users Registration
  env = ACCOUNT_OPEN_SIGNUP=True
  env = ACCOUNT_EMAIL_REQUIRED=True
  env = ACCOUNT_APPROVAL_REQUIRED=False
  env = ACCOUNT_CONFIRM_EMAIL_ON_GET=False
  env = ACCOUNT_EMAIL_VERIFICATION=none
  env = ACCOUNT_EMAIL_CONFIRMATION_EMAIL=False
  env = ACCOUNT_EMAIL_CONFIRMATION_REQUIRED=False
  env = ACCOUNT_AUTHENTICATION_METHOD=username_email
  env = AUTO_ASSIGN_REGISTERED_MEMBERS_TO_REGISTERED_MEMBERS_GROUP_NAME=True

  # OAuth2
  env = OAUTH2_API_KEY=
  env = OAUTH2_CLIENT_ID=Jrchz2oPY3akmzndmgUTYrs9gczlgoV20YPSvqaV
  env = OAUTH2_CLIENT_SECRET=rCnp5txobUo83EpQEblM8fVj3QT5zb5qRfxNsuPzCqZaiRyIoxM4jdgMiZKFfePBHYXCLd7B8NlkfDBY9HKeIQPcy5Cp08KQNpRHQbjpLItDHv12GvkSeXp6OxaUETv3

  # GeoNode APIs
  env = API_LOCKDOWN=False
  env = TASTYPIE_APIKEY=

  # #################
  # Production and
  # Monitoring
  # #################
  env = DEBUG=False

  env = SECRET_KEY='myv-y4#7j-d*p-__@j#*3z@!y24fz8%^z2v6atuy4bo9vqr1_a'

  env = CACHE_BUSTING_STATIC_ENABLED=False

  env = MEMCACHED_ENABLED=False
  env = MEMCACHED_BACKEND=django.core.cache.backends.memcached.MemcachedCache
  env = MEMCACHED_LOCATION=127.0.0.1:11211
  env = MEMCACHED_LOCK_EXPIRE=3600
  env = MEMCACHED_LOCK_TIMEOUT=10

  env = MAX_DOCUMENT_SIZE=2
  env = CLIENT_RESULTS_LIMIT=5
  env = API_LIMIT_PER_PAGE=1000

  # GIS Client
  env = GEONODE_CLIENT_LAYER_PREVIEW_LIBRARY=mapstore
  env = MAPBOX_ACCESS_TOKEN=
  env = BING_API_KEY=
  env = GOOGLE_API_KEY=

  # Monitoring
  env = MONITORING_ENABLED=True
  env = MONITORING_DATA_TTL=365
  env = USER_ANALYTICS_ENABLED=True
  env = USER_ANALYTICS_GZIP=True
  env = CENTRALIZED_DASHBOARD_ENABLED=False
  env = MONITORING_SERVICE_NAME=local-geonode
  env = MONITORING_HOST_NAME=geonode

  # Other Options/Contribs
  env = MODIFY_TOPICCATEGORY=True
  env = AVATAR_GRAVATAR_SSL=True
  env = EXIF_ENABLED=True
  env = CREATE_LAYER=True
  env = FAVORITE_ENABLED=True

  chdir = /opt/geonode
  module = geonode.wsgi:application

  strict = false
  master = true
  enable-threads = true
  vacuum = true                        ; Delete sockets during shutdown
  single-interpreter = true
  die-on-term = true                   ; Shutdown when receiving SIGTERM (default is respawn)
  need-app = true

  # logging
  # path to where uwsgi logs will be saved
  logto = /opt/data/logs/geonode.log
  daemonize = /opt/data/logs/geonode.log
  touch-reload = /opt/geonode/geonode/wsgi.py
  buffer-size = 32768

  harakiri = 60                        ; forcefully kill workers after 60 seconds
  py-callos-afterfork = true           ; allow workers to trap signals

  max-requests = 1000                  ; Restart workers after this many requests
  max-worker-lifetime = 3600           ; Restart workers after this many seconds
  reload-on-rss = 2048                 ; Restart workers after this much resident memory
  worker-reload-mercy = 60             ; How long to wait before forcefully killing workers

  cheaper-algo = busyness
  processes = 128                      ; Maximum number of workers allowed
  cheaper = 8                          ; Minimum number of workers allowed
  cheaper-initial = 16                 ; Workers created at startup
  cheaper-overload = 1                 ; Length of a cycle in seconds
  cheaper-step = 16                    ; How many workers to spawn at a time

  cheaper-busyness-multiplier = 30     ; How many cycles to wait before killing workers
  cheaper-busyness-min = 20            ; Below this threshold, kill workers (if stable for multiplier cycles)
  cheaper-busyness-max = 70            ; Above this threshold, spawn new workers
  cheaper-busyness-backlog-alert = 16  ; Spawn emergency workers if more than this many requests are waiting in the queue
  cheaper-busyness-backlog-step = 2    ; How many emergency workers to create if there are too many requests in the queue

.. code-block:: shell

  # Enable the GeoNode UWSGI config
  sudo ln -s /etc/uwsgi/apps-available/geonode.ini /etc/uwsgi/apps-enabled/geonode.ini

  # Restart UWSGI Service
  sudo pkill -9 -f uwsgi

.. code-block:: shell

  # Create the UWSGI system service

  # Create the executable
  sudo vim /usr/bin/geonode-uwsgi-start.sh

    #!/bin/bash
    sudo uwsgi --ini /etc/uwsgi/apps-enabled/geonode.ini

  sudo chmod +x /usr/bin/geonode-uwsgi-start.sh

  # Create the systemctl Service
  sudo vim /etc/systemd/system/geonode-uwsgi.service

.. code-block:: shell

  [Unit]
  Description=GeoNode UWSGI Service
  After=rc-local.service

  [Service]
  User=root
  PIDFile=/run/geonode-uwsgi.pid
  ExecStart=/usr/bin/geonode-uwsgi-start.sh
  PrivateTmp=true
  Type=simple
  Restart=always
  KillMode=process
  TimeoutSec=900

  [Install]
  WantedBy=multi-user.target

.. code-block:: shell

  # Enable the UWSGI service
  sudo systemctl daemon-reload
  sudo systemctl start geonode-uwsgi.service
  sudo systemctl status geonode-uwsgi.service
  sudo systemctl enable geonode-uwsgi.service

.. code-block:: shell

  # Backup the original NGINX config
  sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig

  # Create the GeoNode Default NGINX config
  sudo vim /etc/nginx/nginx.conf

.. code-block:: shell

  # Make sure your nginx.config matches the following one
  user www-data;
  worker_processes auto;
  pid /run/nginx.pid;
  include /etc/nginx/modules-enabled/*.conf;

  events {
    worker_connections 768;
    # multi_accept on;
  }

  http {
    ##
    # Basic Settings
    ##

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    # server_tokens off;

    # server_names_hash_bucket_size 64;
    # server_name_in_redirect off;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    ##
    # SSL Settings
    ##

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;

    ##
    # Logging Settings
    ##

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    ##
    # Gzip Settings
    ##

    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_http_version 1.1;
    gzip_disable "MSIE [1-6]\.";
    gzip_buffers 16 8k;
    gzip_min_length 1100;
    gzip_comp_level 6;
    gzip_types video/mp4 text/plain application/javascript application/x-javascript text/javascript text/xml text/css image/jpeg;

    ##
    # Virtual Host Configs
    ##

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
  }

.. code-block:: shell

  # Remove the Default NGINX config
  sudo rm /etc/nginx/sites-enabled/default

  # Create the GeoNode App NGINX config
  sudo vim /etc/nginx/sites-available/geonode

.. code-block:: shell

  uwsgi_intercept_errors on;

  upstream geoserver_proxy {
    server localhost:8080;
  }

  # Expires map
  map $sent_http_content_type $expires {
    default                    off;
    text/html                  epoch;
    text/css                   max;
    application/javascript     max;
    ~image/                    max;
  }

  server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    charset utf-8;

    etag on;
    expires $expires;
    proxy_read_timeout 600s;
    # set client body size to 2M #
    client_max_body_size 50000M;

    location / {
      etag off;
      uwsgi_pass 127.0.0.1:8000;
      uwsgi_read_timeout 600s;
      include uwsgi_params;
    }

    location /static/ {
      alias /opt/geonode/geonode/static_root/;
    }

    location /uploaded/ {
      alias /opt/geonode/geonode/uploaded/;
    }

    location /geoserver {
      proxy_pass http://geoserver_proxy;
      include proxy_params;
    }
  }

.. code-block:: shell

  # Prepare the uploaded folder
  sudo mkdir -p /opt/geonode/geonode/uploaded
  sudo chown -Rf tomcat:www-data /opt/geonode/geonode/uploaded
  sudo chmod -Rf 777 /opt/geonode/geonode/uploaded/

  sudo touch /opt/geonode/geonode/.celery_results
  sudo chmod 777 /opt/geonode/geonode/.celery_results

  # Enable GeoNode NGINX config
  sudo ln -s /etc/nginx/sites-available/geonode /etc/nginx/sites-enabled/geonode

  # Restart the services
  sudo service tomcat9 restart
  sudo service nginx restart


Update the settings in order to use the ``PostgreSQL`` Database
...............................................................

.. warning:: Make sure you already installed and configured the Database as explained in the previous sections.

.. note:: Instead of using the ``local_settings.py``, you can drive the GeoNode behavior through the ``.env*`` variables; see as an instance the file ``./paver_dev.sh`` or ``./manage_dev.sh`` in order to understand how to use them. In that case **you don't need to create** the ``local_settings.py`` file; you can just stick with the decault one, which will take the values from the ENV. We tend to prefer this method in a production/dockerized system.

.. code-block:: shell

  workon geonode
  cd /opt/geonode

  # Initialize GeoNode
  chmod +x *.sh
  ./paver_local.sh reset
  ./paver_local.sh setup
  ./paver_local.sh sync
  ./manage_local.sh collectstatic --noinput
  sudo chmod -Rf 777 geonode/static_root/ geonode/uploaded/

Before finalizing the configuration we will need to update the ``UWSGI`` settings

Restart ``UWSGI`` and update ``OAuth2`` by using the new ``geonode.settings``

.. code-block:: shell

  # As superuser
  sudo su

  # Restart Tomcat
  service tomcat9 restart

  # Restart UWSGI
  pkill -9 -f uwsgi

  # Update the GeoNode ip or hostname
  cd /opt/geonode

  # This must be done the first time only
  cp package/support/geonode.binary /usr/bin/geonode
  cp package/support/geonode.updateip /usr/bin/geonode_updateip
  chmod +x /usr/bin/geonode
  chmod +x /usr/bin/geonode_updateip

  # Refresh GeoNode and GeoServer OAuth2 settings
  source .env_local
  PYTHONWARNINGS=ignore VIRTUAL_ENV=$VIRTUAL_ENV DJANGO_SETTINGS_MODULE=geonode.settings GEONODE_ETC=/opt/geonode/geonode GEOSERVER_DATA_DIR=/opt/data/geoserver_data TOMCAT_SERVICE="service tomcat9" APACHE_SERVICE="service nginx" geonode_updateip -p localhost

  # Go back to standard user
  exit

Check for any error with

.. code-block:: shell

  sudo tail -F -n 300 /var/log/uwsgi/app/geonode.log

Reload the UWSGI configuration with

.. code-block:: shell

  touch /opt/geonode/geonode/wsgi.py


6. Update the settings in order to update GeoNode and GeoServer services running on a public IP or hostname
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. warning:: Before exposing your services to the Internet, **make sure** your system is **hardened** and **secure enough**. See the specific documentation section for more details.

Let's say you want to run your services on a public IP or domain, e.g. ``www.example.org``. You will need to slightly update your services in order to reflect the new server name.

In particular the steps to do are:

    1. Update ``NGINX`` configuration in order to serve the new domain name.

    .. code-block:: shell

        sudo vim /etc/nginx/sites-enabled/geonode

        # Update the 'server_name' directive
        server_name example.org www.example.org;

        # Restart the service
        sudo service nginx restart

    2. Update ``UWSGI`` configuration in order to serve the new domain name.

    .. code-block:: shell

        sudo vim /etc/uwsgi/apps-enabled/geonode.ini

        # Change everywhere 'localhost' to the new hostname
        :%s/localhost/www.example.org/g
        :wq

        # Restart the service
        sudo service geonode-uwsgi restart

    3. Update ``OAuth2`` configuration in order to hit the new hostname.

    .. code-block:: shell

        workon geonode
	sudo su
        cd /opt/geonode

        # Update the GeoNode ip or hostname
        PYTHONWARNINGS=ignore VIRTUAL_ENV=$VIRTUAL_ENV DJANGO_SETTINGS_MODULE=geonode.local_settings GEONODE_ETC=/opt/geonode/geonode GEOSERVER_DATA_DIR=/opt/data/geoserver_data TOMCAT_SERVICE="service tomcat9" APACHE_SERVICE="service nginx" geonode_updateip -l localhost -p www.example.org

	exit

    4. Update the existing ``GeoNode`` links in order to hit the new hostname.

    .. code-block:: shell

        workon geonode
	
	# To avoid spatialite conflict if using postgresql
	vim $VIRTUAL_ENV/bin/postactivate
	
	# Add these to make available. Change user, password and server information to yours
	export DATABASE_URL='postgresql://<postgresqluser>:<postgresqlpass>@localhost:5432/geonode'

	#Close virtual environmetn and aopen it again to update variables
	deactivate
	
	workon geonode
        cd /opt/geonode

        # Update the GeoNode ip or hostname
        DJANGO_SETTINGS_MODULE=geonode.local_settings python manage.py migrate_baseurl --source-address=http://localhost --target-address=http://www.example.org
	
.. note:: If at the end you get a "bad gateway" error when accessing your geonode site, check uwsgi log with ``sudo tail -f /var/log/uwsgi/app/geonode.log`` and if theres is an error related with port 5432 check the listening configuration from the postgresql server and allow the incoming traffic from geonode.

7. Install and enable HTTPS secured connection through the Let's Encrypt provider
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: shell

    # Install Let's Encrypt Certbot
    # sudo add-apt-repository ppa:certbot/certbot  # for ubuntu 18.04 and lower
    sudo apt update -y; sudo apt install python3-certbot-nginx -y

    # Reload NGINX config and make sure the firewall denies access to HTTP
    sudo systemctl reload nginx
    sudo ufw allow 'Nginx Full'
    sudo ufw delete allow 'Nginx HTTP'

    # Create and dump the Let's Encrypt Certificates
    sudo certbot --nginx -d example.org -d www.example.org
    # ...choose the redirect option when asked for

Next, the steps to do are:

    1. Update the ``GeoNode`` **OAuth2** ``Redirect URIs`` accordingly.

    From the ``GeoNode Admin Dashboard`` go to ``Home › Django/GeoNode OAuth Toolkit › Applications › GeoServer``

    .. figure:: img/ubuntu-https-001.png
            :align: center

            *Redirect URIs*

    2. Update the ``GeoServer`` ``Proxy Base URL`` accordingly.

    From the ``GeoServer Admin GUI`` go to ``About & Status > Global``

    .. figure:: img/ubuntu-https-002.png
            :align: center

            *Proxy Base URL*


    3. Update the ``GeoServer`` ``Role Base URL`` accordingly.

    From the ``GeoServer Admin GUI`` go to ``Security > Users, Groups, Roles > geonode REST role service``

    .. figure:: img/ubuntu-https-003.png
            :align: center

            *Role Base URL*

    4. Update the ``GeoServer`` ``OAuth2 Service Parameters`` accordingly.

    From the ``GeoServer Admin GUI`` go to ``Security > Authentication > Authentication Filters > geonode-oauth2``

    .. figure:: img/ubuntu-https-004.png
            :align: center

            *OAuth2 Service Parameters*


    5. Update the ``UWSGI`` configuration

    .. code-block:: shell

        sudo vim /etc/uwsgi/apps-enabled/geonode.ini

        # Change everywhere 'http' to 'https'
        %s/http/https/g

        # Add three more 'env' variables to the configuration
        env = SECURE_SSL_REDIRECT=True
        env = SECURE_HSTS_INCLUDE_SUBDOMAINS=True
        env = AVATAR_GRAVATAR_SSL=True

        # Restart the service
        sudo service geonode-uwsgi restart

    .. figure:: img/ubuntu-https-005.png
            :align: center

            *UWSGI Configuration*

8. Enabling Fully Asynchronous Tasks
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install and configure `"rabbitmq-server" <https://lindevs.com/install-rabbitmq-on-ubuntu/>`_
............................................................................................

.. seealso::

    A `March 2021 blog post <https://blog.rabbitmq.com/posts/2021/03/migrate-off-of-bintray/>`_ from RabbitMQ provides alternative installations for other systems.

**Install rabbitmq-server**

Reference: `lindevs.com/install-rabbitmq-on-ubuntu/ <https://lindevs.com/install-rabbitmq-on-ubuntu/>`_ & `www.rabbitmq.com/install-debian.html/ <https://www.rabbitmq.com/install-debian.html#apt-cloudsmith/>`_

.. code-block:: bash

    sudo apt install curl -y
    
    ## Import GPG Key
    sudo apt update
    sudo apt install curl software-properties-common apt-transport-https lsb-release
    curl -fsSL https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/erlang.gpg

    ## Add Erlang Repository to Ubuntu
    sudo apt update
    sudo apt install erlang

    ## Add RabbitMQ Repository to Ubuntu
    curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | sudo bash

    ## Install RabbitMQ Server
    sudo apt install rabbitmq-server

    # check the status (it should already be running)
    sudo systemctl status rabbitmq-server

    # check the service is enabled (it should already be enabled)
    sudo systemctl is-enabled rabbitmq-server.service

    # enable the web frontend and allow access through firewall
    # view this interface at http://<your ip>:15672
    sudo rabbitmq-plugins enable rabbitmq_management
    sudo ufw allow proto tcp from any to any port 5672,15672

**Create admin user**

This is the user that GeoNode will use to communicate with rabbitmq-server.

.. code-block::

    sudo rabbitmqctl delete_user guest
    sudo rabbitmqctl add_user admin <your_rabbitmq_admin_password_here>
    sudo rabbitmqctl set_user_tags admin administrator
    sudo rabbitmqctl add_vhost /localhost
    sudo rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
    sudo rabbitmqctl set_permissions -p /localhost admin ".*" ".*" ".*"

**Managing RabbitMQ**

You can manage the rabbitmq-server service like any other service::

    sudo systemctl stop rabbitmq-server
    sudo systemctl start rabbitmq-server
    sudo systemctl restart rabbitmq-server

You can manage the rabbitmq-server node with `rabbitmqctl <https://www.rabbitmq.com/rabbitmqctl.8.html>`_.
For example, to fully reset the server, use these commands::

    sudo rabbitmqctl stop_app
    sudo rabbitmqctl reset
    sudo rabbitmqctl start_app

After reset, you'll need to recreate the ``admin`` user (see above).

Install and configure `"supervisor” and “celery" <https://cloudwafer.com/blog/how-to-install-and-configure-supervisor-on-ubuntu-16-04/>`_
..........................................................................................................................................

**Install supervisor**

.. code-block:: shell

    sudo apt install supervisor

    sudo mkdir /etc/supervisor
    echo_supervisord_conf > /etc/supervisor/supervisord.conf

    sudo mkdir /etc/supervisor/conf.d

**Configure supervisor**

.. code-block:: shell

    sudo vim /etc/supervisor/supervisord.conf

.. code-block:: ini

    ; supervisor config file

    [unix_http_server]
    file=/var/run/supervisor.sock   ; (the path to the socket file)
    chmod=0700                       ; sockef file mode (default 0700)

    [supervisord]
    nodaemon=true
    logfile=/var/log/supervisor/supervisord.log ; (main log file;default $CWD/supervisord.log)
    pidfile=/var/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
    childlogdir=/var/log/supervisor            ; ('AUTO' child log dir, default $TEMP)
    environment=DEBUG="False",CACHE_BUSTING_STATIC_ENABLED="True",SITEURL="https://<your_geonode_domain>/",DJANGO_SETTINGS_MODULE="geonode.local_settings",GEOSERVER_ADMIN_PASSWORD="<your_geoserver_admin_password>",GEOSERVER_LOCATION="http://localhost:8080/geoserver/",GEOSERVER_PUBLIC_LOCATION="https://<your_geonode_domain>/geoserver/",GEOSERVER_WEB_UI_LOCATION="https://<your_geonode_domain>/geoserver/",MONITORING_ENABLED="True",BROKER_URL="amqp://admin:<your_rabbitmq_admin_password_here>@localhost:5672/",ASYNC_SIGNALS="True"

    ; the below section must remain in the config file for RPC
    ; (supervisorctl/web interface) to work, additional interfaces may be
    ; added by defining them in separate rpcinterface: sections
    [rpcinterface:supervisor]
    supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

    [supervisorctl]
    serverurl=unix:///var/run/supervisor.sock ; use a unix:// URL  for a unix socket

    ; The [include] section can just contain the "files" setting.  This
    ; setting can list multiple files (separated by whitespace or
    ; newlines).  It can also contain wildcards.  The filenames are
    ; interpreted as relative to this file.  Included files *cannot*
    ; include files themselves.

    [include]
    files = /etc/supervisor/conf.d/*.conf

Note the last line which includes the ``geonode-celery.conf`` file that is described below.

**Set the `environment` directive**

Environment variables are placed directly into the ``/etc/supervisor/supervisord.conf`` file; they are exposed to the
service via the ``environment`` directive.

The syntax of this directive can either be all on one line like this (shown above):

.. code-block:: python

    environment=ENV_KEY_1="ENV_VALUE_1",ENV_KEY_2="ENV_VALUE_2",...,ENV_KEY_n="ENV_VALUE_n"

or broken into multiple **indented** lines like this:

.. code-block:: python

    environment=
        ENV_KEY_1="ENV_VALUE_1",
        ENV_KEY_2="ENV_VALUE_2",
        ENV_KEY_n="ENV_VALUE_n"

The following are the minimum set of env key value pairs you will need for a standard GeoNode Celery instance:

    - ``ASYNC_SIGNALS="True"``
    - ``BROKER_URL="amqp://admin:<your_rabbitmq_admin_password_here>@localhost:5672/"``
    - ``DATABASE_URL``
    - ``GEODATABASE_URL``
    - ``DEBUG``
    - ``CACHE_BUSTING_STATIC_ENABLED``
    - ``SITEURL``
    - ``DJANGO_SETTINGS_MODULE``
    - ``GEOSERVER_ADMIN_PASSWORD``
    - ``GEOSERVER_LOCATION``
    - ``GEOSERVER_PUBLIC_LOCATION``
    - ``GEOSERVER_WEB_UI_LOCATION``
    - ``MONITORING_ENABLED``

.. warning::

    + These key value pairs **must** match the values you have already set on the ``uwsgi.ini`` file.
    + If you have custom ``tasks`` that use any other variables from  ``django.conf.settings`` (like ``MEDIA_ROOT``), these variables must also be added to the environment directive.

**Configure celery**

.. code-block:: shell

    sudo vim /etc/supervisor/conf.d/geonode-celery.conf

.. code-block:: ini

    [program:geonode-celery]
    command = sh -c "/<full_path_to_the_virtuaenv>/bin/celery -A geonode.celery_app:app worker -B -E --loglevel=DEBUG --concurrency=10 -n worker1@%%h"
    directory = /<full_path_to_the_geonode_source_code>
    user=geosolutions
    numproc=1
    stdout_logfile=/var/logs/geonode-celery.log
    stderr_logfile=/var/logs/geonode-celery.log
    autostart = true
    autorestart = true
    startsecs = 10
    stopwaitsecs = 600
    priority = 998

----

**Manage supervisor and celery**

Reload and restart ``supervisor`` and the ``celery`` workers

.. code-block:: shell

    # Restart supervisor
    sudo supervisorctl reload
    sudo systemctl restart supervisor

    # Kill old celery workers (if any)
    sudo pkill -f celery

Make sure everything is *green*

.. code-block:: shell

    # Check the supervisor service status
    sudo systemctl status supervisor

    # Check the celery workers logs
    sudo tail -F -n 300 /var/logs/geonode-celery.log

Install and configure `"memcached" <https://cloudwafer.com/blog/how-to-install-and-configure-supervisor-on-ubuntu-16-04/>`_
...........................................................................................................................

.. code-block:: shell

    sudo apt install memcached

    sudo systemctl start memcached
    sudo systemctl enable memcached

    workon <your_geonode_venv_name>
    cd /<full_path_to_the_geonode_source_code>

    sudo apt install libmemcached-dev zlib1g-dev

    pip install pylibmc==1.6.1
    pip install sherlock==0.3.2

    sudo systemctl restart supervisor.service
    sudo systemctl status supervisor.service


Docker
======

In this section we are going to list the passages needed to deploy a vanilla ``GeoNode`` with ``Docker``
You can follow the instructions at :ref:`Docker Setup for Ubuntu (22.04) <Ubuntu (22.04) Basic Setup>` to prepare a Ubuntu 22.04 server with Docker and Docker Compose

1. Clone GeoNode
^^^^^^^^^^^^^^^^

.. code-block:: shell

  # Let's create the GeoNode core base folder and clone it
  sudo mkdir -p /opt/geonode/
  sudo usermod -a -G www-data geonode
  sudo chown -Rf geonode:www-data /opt/geonode/
  sudo chmod -Rf 775 /opt/geonode/

  # Clone the GeoNode source code on /opt/geonode
  cd /opt
  git clone https://github.com/GeoNode/geonode.git


2. Prepare the .env file
^^^^^^^^^^^^^^^^^^^^^^^^^
Follow the instructions at :ref:`Docker create env file<Docker create env file>`

3. Build and run
^^^^^^^^^^^^^^^^^
Follow the instructions at :ref:`Docker build and run<Docker build and run>`


Test the instance and follow the logs
.....................................

If you run the containers daemonized (with the ``-d`` option), you can either run specific Docker commands to follow the ``startup and initialization logs`` or entering the image ``shell`` and check for the ``GeoNode logs``.

In order to follow the ``startup and initialization logs``, you will need to run the following command from the repository folder

.. code-block:: shell

  cd /opt/geonode
  docker logs -f django4geonode

Alternatively:

.. code-block:: shell

  cd /opt/geonode
  docker-compose logs -f django

You should be able to see several initialization messages. Once the container is up and running, you will see the following statements

.. code-block:: shell

  ...
  789 static files copied to '/mnt/volumes/statics/static'.
  static data refreshed
  Executing UWSGI server uwsgi --ini /usr/src/app/uwsgi.ini for Production
  [uWSGI] getting INI configuration from /usr/src/app/uwsgi.ini

To exit just hit ``CTRL+C``.

This message means that the GeoNode containers have bee started. Browsing to ``http://localhost/`` will show the GeoNode home page. You should be able to successfully log with the default admin user (``admin`` / ``admin``) and start using it right away.

With Docker it is also possible to run a shell in the container and follow the logs exactly the same as you deployed it on a physical host. To achieve this run

.. code-block:: shell

  docker exec -it django4geonode /bin/bash

  # Once logged in the GeoNode image, follow the logs by executing
  tail -F -n 300 /var/log/geonode.log

Alternatively:

.. code-block:: shell

  docker-compose exec django /bin/bash

To exit just hit ``CTRL+C`` and ``exit`` to return to the host.

Override the ENV variables to deploy on a public IP or domain
.............................................................

If you would like to start the containers on a ``public IP`` or ``domain``, let's say ``www.example.org``, you can follow the instructions at :ref:`Deploy to production<Docker deploy to production>`

ariables to customize the GeoNode instance. See the ``GeoNode Settings`` section in order to get a list of the available options.


Remove all data and bring your running GeoNode deployment to the initial stage
..............................................................................

This procedure allows you to stop all the containers and reset all the data with the deletion of all the volumes.

.. code-block:: shell

  cd /opt/geonode

  # stop containers and remove volumes
  docker-compose down -v

Get rid of old Docker images and volumes (reset the environment completely)
............................................................................

.. note:: For more details on Docker commands, please refer to the official Docker documentation.

It is possible to let docker show which containers are currently running (add ``-a`` for all containers, also stopped ones)

.. code-block:: shell

  # Show the currently running containers
  docker ps

  CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS                   PORTS                                                                      NAMES
  4729b3dd1de7   geonode/geonode:4.0        "/usr/src/geonode/en…"   29 minutes ago   Up 5 minutes             8000/tcp                                                                   celery4geonode
  418da5579b1a   geonode/geonode:4.0        "/usr/src/geonode/en…"   29 minutes ago   Up 5 minutes (healthy)   8000/tcp                                                                   django4geonode
  d6b043f16526   geonode/letsencrypt:4.0    "./docker-entrypoint…"   29 minutes ago   Up 9 seconds             80/tcp, 443/tcp                                                            letsencrypt4geonode
  c77e1fa3ab2b   geonode/geoserver:2.19.6   "/usr/local/tomcat/t…"   29 minutes ago   Up 5 minutes (healthy)   8080/tcp                                                                   geoserver4geonode
  a971cedfd788   rabbitmq:3.7-alpine        "docker-entrypoint.s…"   29 minutes ago   Up 5 minutes             4369/tcp, 5671-5672/tcp, 25672/tcp                                         rabbitmq4geonode
  a2e4c69cb80f   geonode/nginx:4.0          "/docker-entrypoint.…"   29 minutes ago   Up 5 minutes             0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443-    >443/tcp, :::443->443/tcp   nginx4geonode
  d355d34cac4b   geonode/postgis:13         "docker-entrypoint.s…"   29 minutes ago   Up 5 minutes             5432/tcp                                                                   db4geonode


Stop all the containers by running

.. code-block:: shell

  docker-compose stop

Force kill all containers by running

.. code-block:: shell

  docker kill $(docker ps -q)

I you want to clean up all containers and images, without deleting the static volumes (i.e. the ``DB`` and the ``GeoServer catalog``), issue the following commands

.. code-block:: shell

  # Remove all containers
  docker rm $(docker ps -a -q)

  # Remove all docker images
  docker rmi $(docker images -q)

  # Prune the old images
  docker system prune -a

If you want to remove a ``volume`` also

.. code-block:: shell

  # List of the running volumes
  docker volume ls

  # Remove the GeoServer catalog by its name
  docker volume rm -f geonode-gsdatadir

  # Remove all dangling docker volumes
  docker volume rm $(docker volume ls -qf dangling=true)

  # update all images, should be run regularly to fetch published updates
  for i in $(docker images| awk 'NR>1{print $1":"$2}'| grep -v '<none>'); do docker pull "$i" ;done
