Upgrade from 3.1.x
==================

1. Upgrade the dependencies
2. Perform the ``migrations`` management command; in case some attribute is conflicting, remove it manually from the DB
3. Proform the ``collectstatic`` management command
4. Perform the ``set_all_layers_metadata -d`` management command
5. Drop the ``rabbitmq`` image and volume and let GeoNode recreate the ``queues`` automatically

Upgrade from 2.10.x / 3.0
=========================

Upgrade the instance dependencies
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Check the :ref:`install_dep` and :ref:`install_venv` sections in order to upgrade your Python environment.

Also, make sure the code is ``Python 3.8`` compatible and that you switched and aligned the **source code** and the **requirements.txt** to the ``3.x`` branch.

This must be done manually and with particular attention.

.. code-block:: shell

    workon geonode3
    cd /<full_path_to_geonode>

    pip install pip --upgrade
    pip install -r requirements.txt --upgrade --no-cache --no-cache-dir
    pip install -e . --upgrade
    pip install pygdal=="`gdal-config --version`.*"

    ./manage.sh collectstatic --noinput

Prepare the Database and Migrate to the new Schema
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Fix the tables in order to migrate to the new schema
....................................................

.. code-block:: shell

    ./manage.sh dbshell

.. code-block:: sql

    ALTER TABLE base_resourcebase ADD COLUMN doi_bkp varchar;
    UPDATE base_resourcebase SET doi_bkp = doi;
    ALTER TABLE base_resourcebase DROP COLUMN doi;

    CREATE TABLE base_backup(name varchar);

    CREATE TABLE base_usergeolimit_bkp ( like base_usergeolimit including all);
    CREATE TABLE base_groupgeolimit_bkp ( like base_usergeolimit including all);
    CREATE TABLE base_resourcebase_users_geolimits_bkp ( like base_usergeolimit including all);
    CREATE TABLE base_resourcebase_groups_geolimits_bkp ( like base_usergeolimit including all);

    DROP TABLE IF EXISTS base_configuration CASCADE;
    DROP TABLE IF EXISTS base_usergeolimit CASCADE;
    DROP TABLE IF EXISTS base_groupgeolimit CASCADE;
    DROP TABLE IF EXISTS base_resourcebase_users_geolimits CASCADE;
    DROP TABLE IF EXISTS base_resourcebase_groups_geolimits CASCADE;

    \q

Migrate to the new schema
.........................

.. code-block:: shell

    ./manage.sh makemigrations
    ./manage.sh migrate

Restore the old contents
........................

.. code-block:: shell

    ./manage.sh dbshell

.. code-block:: sql

    UPDATE base_resourcebase SET doi = doi_bkp;
    ALTER TABLE base_resourcebase DROP COLUMN doi_bkp;

    INSERT INTO base_usergeolimit (SELECT * FROM base_usergeolimit_bkp);
    INSERT INTO base_groupgeolimit (SELECT * FROM base_groupgeolimit_bkp);
    INSERT INTO base_resourcebase_users_geolimits (SELECT * FROM base_resourcebase_users_geolimits_bkp);
    INSERT INTO base_resourcebase_groups_geolimits (SELECT * FROM base_resourcebase_groups_geolimits_bkp);

    DROP TABLE IF EXISTS base_usergeolimit_bkp CASCADE;
    DROP TABLE IF EXISTS base_groupgeolimit_bkp CASCADE;
    DROP TABLE IF EXISTS base_resourcebase_users_geolimits_bkp CASCADE;
    DROP TABLE IF EXISTS base_resourcebase_groups_geolimits_bkp CASCADE;

    \q

Upgrade from 2.4.x
==================

These are the notes of a migration from 2.4.x to 2.10.1.
These notes could possibly work also when migrating from 2.6.x, 2.7.x, 2.8.x but are not tested in that scenarios.
You should run this procedure on your local machine and once you successfully migrated the database move the backup to your GeoNode 2.10.1 production instance.

PostgreSQL
^^^^^^^^^^

Create a role and a database for Django GeoNode 2.4:

.. code-block:: sql

    create role user with superuser login with password '***';
    create database gn_24 with owner user;
    \c gn_24
    create extension postgis;

Restore backup from your production backup:

.. code-block:: shell

    psql gn_24 < gn_24.sql

Run GeoNode migrations
^^^^^^^^^^^^^^^^^^^^^^

Activate your GeoNode virtualenv and set the env vars:

.. code-block:: sql

    . env/bin/Activate
    export vars_210

Here are the variables to export - update them to your environment settings:

.. code-block:: shell

    export DATABASE_URL=postgis://user:***@localhost:5432/dbname
    export DEFAULT_BACKEND_DATASTORE=data
    export GEODATABASE_URL=postgis://user:***@localhost:5432/geonode_data
    export ALLOWED_HOSTS="['localhost', '192.168.100.10']"
    export STATIC_ROOT=~/www/geonode/static/
    export GEOSERVER_LOCATION=http://localhost:8080/geoserver/
    export GEOSERVER_PUBLIC_LOCATION=http://localhost:8080/geoserver/
    export GEOSERVER_ADMIN_PASSWORD=geoserver
    export SESSION_EXPIRED_CONTROL_ENABLED=False

Downgrade psycopg2:

.. code-block:: shell

    pip install psycopg2==2.7.7

Apply migrations and apply basic fixtures:

.. code-block:: shell

    cd wfp-geonode
    ./manage.py migrate --fake-initial
    paver sync


Regenerate from scratch the upload application tables in the database:

.. code-block:: sql

    delete from django_migrations where app = 'upload';
    drop table upload_upload cascade;
    drop table upload_uploadfile;

Regenerate upload tables with migrate:

.. code-block:: shell

    ./manage.py migrate upload

Upgrade psycopg2:

.. code-block:: shell

    pip install -r geonode/requirements.txt

Create superuser
^^^^^^^^^^^^^^^^

To create a superuser you should drop the following constraints (they can be re-enabled if needed):

.. code-block:: sql

    alter table people_profile alter column last_login drop not null;

.. code-block:: shell

    ./manage createsuperuser

Fixes on database
^^^^^^^^^^^^^^^^^

For some reason some resources were unpublished:

.. code-block:: sql

    UPDATE base_resourcebase SET is_published = true;

Remove a foreign key from account_account which is not used anymore (GeoNode dev team: maybe even better let's remove all of the account tables, I think they are stale now):

.. code-block:: sql

    ALTER TABLE account_account DROP CONSTRAINT user_id_refs_id_726cb6b4;
    ALTER TABLE account_signupcode DROP CONSTRAINT "inviter_id_refs_id_49a7c0d9";

Fix the remote service layers by running this script:

.. code-block:: shell

    python migration/fixes_remote_layers.py
