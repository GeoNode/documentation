Connecting GeoNode Docker to an External Database
-------------------------------------------------

1. Make sure docker components are down
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: sh

    >_ docker-compose down

2. Disable GeoNode docker database and related commands
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  ``@docker-compose.yml`` comment out the ``db`` section

   .. code:: yml

       # # PostGIS database.
       # db:
       #   # use geonode official postgis 11 image
       #   image: geonode/postgis:latest
       #   container_name: db4${COMPOSE_PROJECT_NAME}
       #   env_file:
       #     - ./scripts/docker/env/${DOCKER_ENV}/db.env
       #   volumes:
       #     - dbdata:/var/lib/postgresql/data
       #     - dbbackups:/pg_backups
       #   restart: on-failure
       #   # uncomment to enable remote connections to postgres
       #   #ports:
       #   #  - "5432:5432"

-  ``@docker-compose.yml`` comment out the related ``volumes`` section

   .. code:: yml

       # dbdata:
       #   name: ${COMPOSE_PROJECT_NAME}-dbdata
       # dbbackups:
       #   name: ${COMPOSE_PROJECT_NAME}-dbbackups

-  ``@entrypoint.sh`` comment out the related ``"waitfordbs task done"``
   section

   -  Note 1: **It is expected to have the external database up running
      before running, So no need to wait for the databases**
   -  Note 2: **Please check how the script for ``wait for databases``
      could be improved at the end on the file**

   .. code:: sh

       # /usr/local/bin/invoke waitfordbs > /usr/src/geonode/invoke.log 2>&1
       # echo "waitfordbs task done"

-  Rebuild django docker service

   .. code:: sh

       >_ docker-compose build

3. As for the external PostgreSQL database it is expected to have the following parameters:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  database user with password for connection
-  database name for geonode django tables
-  database name for geonode data tables
-  exposed database IP address
-  exposed database port
-  Docker containers network IP address

4. Prepare The External PostgreSQL Database:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    Skip this part if it is already prepared

-  Create database user ``<username>`` with ``<your_strong_password>``

   .. code:: sh

       >_ sudo -u postgres createuser -P <username>

-  Create databases for ``geonode django tables`` with name ``geonode``

   .. code:: sh

       >_ sudo -u postgres createdb -O <username> geonode

-  Create databases for ``geonode django tables`` with name
   ``geonode_data``

   .. code:: sh

       >_ sudo -u postgres createdb -O <username> geonode_data

-  Use ``PostGIS`` extension for the created databases > Replace
   ``<username>`` with your username

   .. code:: sh

       >_ sudo -u postgres psql -d geonode -c 'CREATE EXTENSION postgis;'
       >_ sudo -u postgres psql -d geonode -c 'GRANT ALL ON geometry_columns TO PUBLIC;'
       >_ sudo -u postgres psql -d geonode -c 'GRANT ALL ON spatial_ref_sys TO PUBLIC;'
       >_ sudo -u postgres psql -d geonode -c 'GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO <username>;'

       >_ sudo -u postgres psql -d geonode_data -c 'CREATE EXTENSION postgis;'
       >_ sudo -u postgres psql -d geonode_data -c 'GRANT ALL ON geometry_columns TO PUBLIC;'
       >_ sudo -u postgres psql -d geonode_data -c 'GRANT ALL ON spatial_ref_sys TO PUBLIC;'
       >_ sudo -u postgres psql -d geonode_data -c 'GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO <username>;'

-  Scenario 1: PostgreSQL service with docker service on the same host
   machine

   -  Get the geonode docker network IP address:

      .. code:: sh

          >_ docker network inspect geonode_default | grep Subnet
          # example output:
          #       "Subnet": "172.21.0.0/16",

-  Scenario 2: PostgreSQL is running on separate host machine:

   -  Get the host machine IP address:

      .. code:: sh

          >_ ifconfig

-  Now, Having the IP address, Add two rules for both databases at
   ``/etc/postgres/<postgres_version_number>/pg_hba.conf``

   .. code:: conf

       # Syntax 
       # host DATABASE        USER         ADDRESS             METHOD
       # Ex
       # host geonode_data    geonode_user 172.21.0.0/16      md5 
       host   geonode         <username>   <ip_address>/16     md5
       host   geonode_data    <username>   <ip_address>/16     md5        

-  Restart postgresql database service

   .. code:: sh

       >_ sudo service postgresql restart

-  Allow GeoNode docker to connect to the external database:

   -  At geonode project dir, edit ``.env`` file
   -  Replace with your ``username``, ``password``, ``ip_address``,
      ``port``
   -  Replace database names if changed than ``geonode & geonode_data``

      .. code:: conf

          POSTGRES_USER=<username>
          POSTGRES_PASSWORD=<password>
          GEONODE_DATABASE=geonode
          GEONODE_DATABASE_PASSWORD=geonode
          GEONODE_GEODATABASE=geonode_data
          GEONODE_GEODATABASE_PASSWORD=geonode_data
          DATABASE_URL=postgis://<username>:<password>@<ip_address>:<port>/geonode
          GEODATABASE_URL=postgis://<username>:<password>@<ip_address>:<port>/geonode_data

   -  Start the docker containers

          Expected to see the migrations running again

      .. code:: sh

          >_ docker-compose up -d

   -  **Done!**


