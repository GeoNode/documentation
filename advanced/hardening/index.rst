.. _geonode_on_https:

Publish on HTTPS
================

TBD

Publish on other than HTTP port (for e.g. 8082)
===============================================

By default geonode will be installed in the port 80 (i.e. HTTP) port. But what if you want to change the port of the geonode to other than HTTP port (For this example, I am taking 8082 port)? We need to edit couple of things in the web configuration. First things is, we need to update the `/etc/uwsgi/apps-enabled/geonode.ini` file,

.. code-block:: shell
    
    sudo vi /etc/uwsgi/apps-enabled/geonode.ini
    
Edit the following lines,

.. code-block:: shell
    
    env = SITE_HOST_NAME=localhost:8082 
    env = SITEURL=http://localhost:8082
    
    SITE_HOST_NAME=localhost
    SITE_HOST_PORT=8082
    GEOSERVER_WEB_UI_LOCATION=http://localhost:8082/geoserver/
    GEOSERVER_PUBLIC_LOCATION=http://localhost:8082/geoserver/



After that we need to update the `/etc/nginx/sites-enabled/geonode` file,

.. code-block:: shell
    
    sudo vi /etc/nginx/sites-enabled/geonode
    
Edit the following lines,

.. code-block:: shell
    
    server {
        listen 8082 default_server;
         listen [::]:8082 default_server;


.. _oauth2_fixtures_and_migration:

OAuth2 Fixtures Update and Base URL Migration
=============================================

TBD

.. _geonode_security_subsystem:

GeoNode Security Subsystem
==========================

TBD

.. _oauth2_tokens_and_sessions:

OAuth2 Tokens and Sessions
==========================

TBD (ref to :ref:`oauth2_admin_panel_access_tokens`)
