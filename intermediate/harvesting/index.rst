=========================================
Harvesting resources from remote services
=========================================

Generally speaking, harvesting is a process by which a metadata catalogue is able to connect to remote catalogues and
retrieve information about their resources. This process is usually performed periodically, in order to keep the
local catalogue in sync with the remote.

GeoNode is able to harvest resource metadata from multiple remote services.
When appropriately configured, it will contact the remote service, extract a list of relevant resources that can be
harvested and proceed to create local resources for each remote resource. It will also keep the resources synchronized
with the remote service by means of periodic refresh oprations.

Out of the box, GeoNode ships with support for harvesting from:

#. Other remote GeoNode instances;
#. OGC WMS servers;
#. ArcGIS REST services of type MapServer;
#. ArcGIS REST services of type ImageServer.

Adding support for additional harvesting sources is also possible.


GeoNode harvesting concepts
===========================

When a suitable **harvester** is configured, GeoNode is able to use its corresponding **harvester worker** to contact
the remote service and generate a list of **harvestable resources**. The user is then able to select which of those
resources are of interest. Depending on its configured update frequency, sometime later, the **harvesting scheduler**
will create new **harvesting sessions** in order to create local GeoNode resources from the remote harvestable resources
that had been marked as relevant by the user.

The above description uses the following key concepts:

harvester
    This is the configuration object that is used to parametrize harvesting of a remote service. It is configurable
    at runtime and is preserved in the GeoNode database.

    Harvesters and their properties can be managed by visiting the ``harvesting/harvesters`` section of the GeoNode
    admin area, or by visiting the ``api/v2/harvesters`` API endpoint with an admin user.

    Among other parameters, a harvester holds:

    remote_url
        Base URL of the remote service being harvested, *e.g.* ``https://stable.demo.geonode.org``

    harvester_type
        Type of harvester worker that will be used to perform harvesting. See the
        :ref:`Harvester worker <harvester-worker-label>` section below for more detail.

    scheduling_enabled
        Whether harvesting shall be performed periodically by the
        :ref:`harvesting scheduler <harvesting-scheduler-label>` or not.

    harvesting_session_update_frequency
        How often (in minutes) should new harvesting sessions be automatically scheduled?

    refresh_harvestable_resources_update_frequency
        How often (in minutes) should new refresh sessions be automatically scheduled?

    default_owner
        Which GeoNode user shall be made the owner of harvested resources

    harvest_new_resources_by_default
        Should new remote resources be harvested automatically?

    delete_orphan_resources_automatically
        Orphan resources are those that have previously been created by means of a harvesting operation but that
        GeoNode can no longer find on the remote service being harvested. Should these resources be deleted from
        GeoNode automatically? This also applies to when a harvester configuration is deleted, in which case all of
        the resources that originated from that harvester are now considered to be orphan.

.. _harvester-worker-label:

harvester worker
    Harvester workers implement retrieval for concrete remote service types. Each harvester uses a specific worker,
    depending on the type of remote service that it gets data from. Harvester workers may accept their own additional
    configuration parameters.

    GeoNode ships with the following harvester workers:

        GeoNode (geonode.harvesting.harvesters.geonodeharvester.GeonodeUnifiedHarvesterWorker)
            This is appropriate for harvesting from remote GeoNode deployments

        WMS (geonode.harvesting.harvesters.wms.OgcWmsHarvester)
            This is appropriate for harvesting from remote OGC WMS servers

        ArcGIS (geonode.harvesting.harvesters.arcgis.ArcgisHarvesterworker)
            This is appropriate for harvesting from ArcGIS REST services


harvestable resource
    A resource that is available on the remote server. It can be harvested if

.. _harvesting-session-label:

harvesting session
    Each periodic harvesting session

    There are two types of harvesting session:

    * **refresh session**
    * **harvesting session**

.. _harvesting-scheduler-label:

harvesting scheduler
    The scheduler is responsible for periodically spawining new harvesting sessions



Harvesting workflows
====================

The standard harvesting workflow is simple:

1. User creates a new harvester
2. Harvester proceeds to periodically create and update



{explain the harvesting in terms of GeoNode}

{explain the scheduler}

{explain how to configure harvesting via the django admin}

{explain how to configure harvesting via the API}

{available harvesters}

{how to add new harvesters}