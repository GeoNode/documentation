Upgrade from 3.2.x / 3.3.x
=========================

1. Upgrade the dependencies
2. Perform the ``migrations`` management command; in case some attribute is conflicting, remove it manually from the DB
3. Proform the ``collectstatic`` management command

Upgrade the instance dependencies
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Check the :ref:`install_dep` and :ref:`install_venv` sections in order to upgrade your Python environment.

Also, make sure the code is ``Python 3.8`` compatible and that you switched and aligned the **source code** and the **requirements.txt** to the ``master`` branch.

This must be done manually and with particular attention.

.. code-block:: shell

    workon <project environment>
    cd <project_name>
    pip install -r requirements.txt

    cd /<full_path_to_geonode>

    pip install pip --upgrade
    pip install -r requirements.txt --upgrade
    pip install -e . --upgrade
    pip install pygdal=="`gdal-config --version`.*"

    ./manage.sh collectstatic --noinput


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


Apply migrations and apply basic fixtures:

.. code-block:: shell

    ./manage.py migrate --fake-initial
    paver sync


.. note:: Incase of an error of :guilabel:`django.db.utils.ProgrammingError: column "colum-name" of relation "table-name" already exists` on running migrations, you can backup the field data with the following steps.

.. code-block:: shell

    ./manage.sh dbshell

.. code-block:: sql

    ALTER TABLE <table> ADD COLUMN <colum-name>_bkp varchar;
    UPDATE <table> SET <colum-name>_bkp = colum-name;
    ALTER TABLE <table> DROP COLUMN <colum-name>;

    \q

Run migration then:

.. code-block:: shell

    ./manage.sh dbshell

.. code-block:: sql

    UPDATE <table> SET <colum-name> = <colum-name>_bkp;
    ALTER TABLE <table> DROP COLUMN <colum-name>_bkp;

    \q


Create superuser
^^^^^^^^^^^^^^^^

To create a superuser you should drop the following constraints (they can be re-enabled if needed):

.. code-block:: sql

    alter table people_profile alter column last_login drop not null;

.. code-block:: shell

    ./manage createsuperuser


Update Templates
^^^^^^^^^^^^^^^^

Update available templates to use {% load static %} instead of {% load staticfiles %}
