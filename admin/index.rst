GeoNode Admins Guide
====================

GeoNode has an administration panel, based on the Django admin, which can be used to do some database operations.
Although most of the operations can and should be done through the normal GeoNode interface,
the admin panel provides a quick overview and management tool over the database.

The following sections will explain more in depth what functionalities the admin panel makes available to you.
It should be highlighted that the sections not covered in this guide are meant to be managed through GeoNode UI.

.. toctree::
    :maxdepth: 3

    admin_panel/index

GeoNode Management Commands
===========================

Management commands are utility functions for GeoNode maintenance tasks. They are usually run from an SSH/bash shell on the server running GeoNode.
Any call to python is prepended with a configuration parameter to indicate the GeoNode settings module to be used.

.. code-block:: shell

    DJANGO_SETTINGS_MODULE=geonode.settings python manage.py migrate_baseurl --help

.. note:: If you have enabled ``local_settings.py`` the command will change as follows:

    .. code-block:: shell

        DJANGO_SETTINGS_MODULE=geonode.local_settings python manage.py migrate_baseurl --help

.. toctree::
    :caption: GeoNode Management Commands
    :maxdepth: 3

    mgmt_commands/index

Changing the default Languages
==============================

.. toctree::
    :caption: Changing the default Languages
    :maxdepth: 3

    default_lang/index

GeoNode Upgrade from older versions
===================================

.. toctree::
    :caption: GeoNode Upgrade from older versions
    :maxdepth: 3

    upgrade/index

GeoNode Async Signals
=====================

.. toctree::
    :caption: GeoNode Async Signals
    :maxdepth: 3

    async/index

GeoNode Managing thesauri
=========================

.. toctree::
    :maxdepth: 3

    thesaurus/index
