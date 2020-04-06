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

Accordingly to the admin needs, the file ``settings.ini`` must be ceated / tuned up a bit before running a backup or restore.

The default file can be found at``geonode/br/management/commands/settings.ini`` and it contains the following properties:

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

The ``settings.ini`` file can be created in any directory accessible by GeoNode, and it's path can be passed to the backup / restore
procedures using `-c` (`--config`) argument.

There are few different sections of the configuration file, that must be carefully checked before running a backup / restore command.

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

The following sections shows instructions on how to perform backup / restore from the command line by using the Django Admin Management Commands.

In order to obtain a basic user guide for the management command from the command line, just run

    .. code-block:: shell

        python manage.py backup --help

        python manage.py restore --help

``--help`` will provide the list of available command line options with a brief description.

By default both procedures activate `Read Only` mode, disabling any content modifying requests, which is reverted
to the previous state (from before the execution) after finish, regardless of the command's result (success or failure).
To disable activation of this mode, ``--skip-read-only`` argument can be passed to the command.

It is worth notice that both commands allows the following option

    .. code-block:: shell

        python manage.py backup --force / -f

        python manage.py restore --force / -f

Which enables a non-interactive mode, meaning the user will not be asked for an explicit confirmation.

Backup
------

In order to perform a backup just run the command:

    .. code-block:: shell

        python manage.py backup --backup-dir=<target_bk_folder_path>

The management command will automatically generate a ``.zip`` archive file on the target folder in case of success. In the target directory
``.md5`` file with the same name as backup will be created. It contains the MD5 hash of the backup file, which can be used to check archive's
integrity before restoration.

It is worth to mention that ``br`` (Backup & Restore GeoNode application) will not be dumped, even if specified in the ``settings.ini`` as
its content is strictly related to the certain GeoNode instance.

Currently, GeoNode does not support any automatic extraction of the backup file. It should be manually transferred, if needed to the target
instance environment.

Restore
-------

The ``restore`` command has a number of arguments, modifying its execution:

#. ``--skip-geoserver``: the Geoserver backup restoration won't be performed

#. ``--backup-file``: (exclusive together with ``--backup-files-dir``) path to the backup ``.zip`` archive

#. ``--backup-files-dir``: (exclusive together with ``--backup-file``) directory containing backup archives. The directory may contain a number of files, but **only** backup archives are allowed with a ``.zip`` extension. In case multiple archives are present in the directory, the newest one, created after the last already restored backup creation time, will be restored. This option was implemented with a thought of automated restores.

#. ``-l`` / ``--with-logs``: the backup file will be checked against the restoration logs (history). In case this backup has already been restored (MD5 based comparision), RuntimeError is raised, preventing restore execution.

#. ``-n`` / ``--notify``: the restore procedure outcome will be send by an e-mail notification to the superusers of the instance (note: notification will be sent to the superusers of the instance before restoration).

#. ``--skip-read-only``: the restore procedure will be conducted without setting `Read Only` mode during execution.

In order to perform a default backup restoration just run the command:

    .. code-block:: shell

        python manage.py restore --backup-file=<target_restore_file_path>

For restore to run it requires either ``--backup-file`` or ``--backup-files-dir`` argument defined.

.. warning:: The Restore will **overwrite** the whole target instances of GeoNode (and by default GeoServer) including users, catalog and database, so be very careful.

GeoNode Admin GUI Inspection
============================

The history of restored backups can be verified in the admin panel.

Login to the admin panel and select ``Restored backups`` table from ``BACKUP/RESTORE`` application.

.. figure:: img/br_1.png
   :align: center


A list will be displayed with a history of all restored backups. You can select a certain backup to view it's data.

.. figure:: img/br_2.png
   :align: center


The detailed view of the restored backup shows backup archive's name, it's MD5 hash, it's creation/modification date (in the target folder), and the date of the restoration. Please note Restored Backup history cannot be modified.

.. figure:: img/br_3.png
   :align: center

B/R in Docker environment
=========================

When executing B/R in the Docker environment, creation backup to / restoration from should be executed in ``/backup_restore`` directory.
It is a shared volume between Geoserver and Geonode images, created for this purpose only. Pointing at another
location will fail, as one of the images won't have an access to the files.

.. warning:: The only other volume shared between images is ``/geoserver_data/data``, but backup creation **should not** be performed there, as the recursive Geoserver backups may be created in such case.

