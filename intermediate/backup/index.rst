.. _backup_restore_geonode:

=============================
Full GeoNode Backup & Restore
=============================

The admin command to backup and restore GeoNode, allows to extract consistently the GeoNode and GeoServer data models in a serializable
meta-format which is being interpreted later by the restore procedure in order to exactly rebuild the whole structure.

In particular the tool helps developers and administrators to correctly extract and serialize the following resources:

* **GeoNode** (Resource Base Model):

    #. Layers (both raster and vectors)

    #. Maps

    #. Documents

    #. People with Credentials

    #. Permissions

    #. Associated Styles

    #. Static data and templates

* **GeoServer** (Catalog):

    #. OWS Services configuration and limits

    #. Security model along with auth filters configuration, users and credentials

    #. Workspaces

    #. Stores (both DataStores and CoverageStores)

    #. Layers

    #. Styles

The tool exposes two GeoNode Management Commands, 'backup' and 'restore'.

The commands allow to:

#. Fully backup GeoNode data and fixtures on a zip archive

#. Fully backup GeoServer configuration (physical datasets - tables, shapefiles, geotiffs)

#. Fully restore GeoNode and GeoServer fixtures and catalog from the zip archive

The usage of those commands is quite easy and straightforward.

The first step is to ensure that everything is correctly configured and the requisites respected in order to successfully
perform a backup and restore of GeoNode.

.. warning:: It is worth to notice that this functionality requires the latest `GeoServer Extension <http://build.geonode.org/geoserver/latest/>`_ (2.9.x or greater) for GeoNode in order to correctly work.

.. note:: GeoServer full documentation is also available here `GeoServer Docs <https://docs.geoserver.org/stable/en/user/community/backuprestore/index.html>`_

Requisites and Setup
====================

**Before** running a GeoNode backup / restore, it is necessary to ensure everything is correctly configured and setup.

Settings
--------

Accordingly to the admin needs, the file ``settings.ini`` must be tuned up a bit before running a backup / restore.

It can be found at ``geonode/br/management/commands/settings.ini`` and by default it contains the following properties:

.. code-block:: ini

    [database]
    pgdump = pg_dump
    pgrestore = pg_restore

    [geoserver]
    datadir = geoserver/data
    dumpvectordata = yes
    dumprasterdata = yes

    [fixtures]
    # NOTE: Order is important
    apps  = contenttypes,auth,people,groups,account,guardian,admin,actstream,announcements,avatar,base,dialogos,documents,geoserver,invitations,pinax_notifications,layers,maps,oauth2_provider,services,sites,socialaccount,taggit,tastypie,upload,user_messages
    dumps = contenttypes,auth,people,groups,account,guardian,admin,actstream,announcements,avatar,base,dialogos,documents,geoserver,invitations,pinax_notifications,layers,maps,oauth2_provider,services,sites,socialaccount,taggit,tastypie,upload,user_messages

The ``settings.ini`` has few different sections that must carefully checked before running a backup / restore command.

Settings: [database] Section
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: ini

    [database]
    pgdump = pg_dump
    pgrestore = pg_restore

This section is quite simple. It contains only two properties:

* *pgdump*; the path of the ``pg_dump`` local command.

* *pgrestore*; the path of the ``pg_restore`` local command.

.. warning:: Those properties are ignored in case GeoNode is not configured to use a DataBase as backend (see ``settings.py`` and ``local_settings.py`` sections)

.. note:: Database connection settings (both for GeoNode and GeoServer) will be taken from ``settings.py`` and ``local_settings.py`` configuration files. Make sure they are correctly configured (on the target GeoNode instance, too) and the DataBase server is accessible while executing a backup / restore command.

Settings: [geoserver] Section
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: ini

    [geoserver]
    datadir = /opt/gs_data_dir
    dumpvectordata = yes
    dumprasterdata = yes

This section allows to enable / disable a full data backup / restore of GeoServer.

* *datadir*: the full path of GeoServer Data Dir, by default ``/opt/gs_data_dir``. The path **must** be accessible and **fully writable** by the ``geonode`` and / or ``httpd server`` users when executing a backup / restore command.

* *dumpvectordata*: a boolean flag enabling or disabling creation of a vector data dump from GeoServer (shapefiles or DB tables). If ``false`` (or ``no``) vector data won't be stored / re-stored.

* *dumprasterdata*: a boolean flag enabling or disabling creation of a raster data dump from GeoServer (geotiffs). If ``false`` (or ``no``) raster data won't be stored / re-stored.

.. warning:: Enabling these options **requires** the GeoServer Data Dir to be accessible and **fully writable** for the ``geonode`` and / or ``httpd server`` users when executing a backup / restore command.

Settings: [fixtures] Section
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: ini

    [fixtures]
    #NOTE: Order is important
    apps   = people,account,avatar.avatar,base.backup,base.license,base.topiccategory,base.region,base.resourcebase,base.contactrole,base.link,base.restrictioncodetype,base.spatialrepresentationtype,guardian.userobjectpermission,guardian.groupobjectpermission,layers.uploadsession,layers.style,layers.layer,layers.attribute,layers.layerfile,maps.map,maps.maplayer,maps.mapsnapshot,documents.document,taggit

    dumps  = people,accounts,avatars,backups,licenses,topiccategories,regions,resourcebases,contactroles,links,restrictioncodetypes,spatialrepresentationtypes,useropermissions,groupopermissions,uploadsessions,styles,layers,attributes,layerfiles,maps,maplayers,mapsnapshots,documents,tags

This section is the most complex one. Usually you don't need to modify it. Only an expert user who knows Python and GeoNode model structure should modify this section.

What its properties mean:

* *apps*; an ordered list of GeoNode Django applications. The backup / restore procedure will dump / restore the fixtures in a portable format.

* *dumps*; this is the list of ``files`` associated to the Django applications. The order **must** be the same as in the *apps* property above. Each name represents the ``file name`` where to dump to / read from the single app's fixtures.


Executing from the CLI
======================

The following sections shows instructions on how to perform backup / restore from the command line by using the Admin Management Commands.

In order to obtain a basic user guide for the management command from the command line, just run

    .. code-block:: shell

        python manage.py backup --help

        python manage.py restore --help

``--help`` will provide the list of available command line options with a brief description.

It is worth notice that both commands allows the following option

    .. code-block:: shell

        python manage.py backup --force / -f

        python manage.py restore --force / -f

Which will instruct the management command to not ask for confirmation from the user. It enables bascially a non-interactive mode.

Backup
------

In order to perform a backup just run the command:

    .. code-block:: shell

        python manage.py backup --backup-dir=<target_bk_folder_path>

The management command will automatically generate a ``.zip`` archive file on the target folder in case of success.

Restore
-------

In order to perform a restore just run the command:

    .. code-block:: shell

        python manage.py restore --backup-file=<target_restore_file_path>

Restore requires the path of one ``.zip`` archive containing the backup fixtures.

.. warning:: The Restore will **overwrite** the whole target GeoNode / GeoServer users, catalog and database, so be very carefull.

GeoNode Admin GUI Inspection
============================
