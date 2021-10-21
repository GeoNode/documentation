=========================================
Harvesting resources from remote services
=========================================

harvesting is a process by which a metadata catalogue is able to connect to remote catalogues and
retrieve information about their resources. This process is usually performed periodically, in order to keep the
local catalogue in sync with the remote.

GeoNode is able to harvest resource metadata from multiple remote services.

When appropriately configured, it will contact the remote service, extract a list of relevant resources that can be
harvested and proceed to create local resources for each remote resource. It will also keep the resources synchronized
with the remote service by means of periodic refresh operations.

Out of the box, GeoNode ships with support for harvesting from:

#. :ref:`Other remote GeoNode instances <geonode-harvester-worker-label>`;
#. :ref:`OGC WMS servers <wms-harvester-worker-label>`;
#. :ref:`ArcGIS REST services <arcgis-harvester-worker-label>`;

Adding support for :ref:`additional harvesting sources <creating-new-workers-label>` is also possible.


GeoNode harvesting concepts
===========================

When a **harvester** is configured, GeoNode is able to use its corresponding **harvester worker** to contact
the remote service and generate a list of **harvestable resources**. The user is then able to select which of those
resources are of interest. Depending on its configured update frequency, sometime later, the **harvesting scheduler**
will create new **harvesting sessions** in order to create local GeoNode resources from the remote harvestable resources
that had been marked as relevant by the user.

The above description uses the following key concepts:

.. _harvester-label:

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
        :ref:`Harvester worker concept <harvester-worker-label>` and the :ref:`standard harvester workers
        <standard-harvester-workers-label>` sections below for more detail.

    scheduling_enabled
        Whether harvesting shall be performed periodically by the
        :ref:`harvesting scheduler <harvesting-scheduler-label>` or not.

    harvesting_session_update_frequency
        How often (in minutes) should new :ref:`harvesting sessions <harvesting-session-label>` be
        automatically scheduled?

    refresh_harvestable_resources_update_frequency
        How often (in minutes) should new :ref:`refresh sessions <harvesting-session-label>` be automatically scheduled?

    default_owner
        Which GeoNode user shall be made the owner of harvested resources

    harvest_new_resources_by_default
        Should new remote resources be harvested automatically? When this option is selected, the user does not
        need to specify which :ref:`harvestable resources <harvestable-resource-label>` should be harvested,
        as all of them will be automatically marked for harvesting by GeoNode.

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

    Harvester workers are set as the ``harvester_type`` attribute on a :ref:`harvester <harvester-label>`. Their configuration is set as a JSON
    object on the ``harvester_type_specific_configuration`` attribute of the harvester.

    GeoNode ships with the following harvester workers:

    #. :ref:`GeoNode <geonode-harvester-worker-label>` (geonode.harvesting.harvesters.geonodeharvester.GeonodeUnifiedHarvesterWorker) - This is appropriate for harvesting from remote GeoNode deployments

    #. :ref:`WMS <wms-harvester-worker-label>` (geonode.harvesting.harvesters.wms.OgcWmsHarvester) - This is appropriate for harvesting from remote OGC WMS servers

    #. :ref:`ArcGIS REST services <arcgis-harvester-worker-label> (geonode.harvesting.harvesters.arcgis.ArcgisHarvesterworker) - This is appropriate for harvesting from ArcGIS REST services


harvestable resource
    A resource that is available on the remote server. Harvestable resources are persisted in the GeoNode DB. They are
    created during :ref:`refresh operations <update-harvestable-resources-action-label>`, when the harvester worker
    interacts with the remote service in order to discover which remote resources can be harvested.

    Harvestable resources can be managed by visiting the ``harvesting/harvestable resources`` section of the
    GeoNode admin area, or by visiting the ``api/v2/harvesters/{harvester-id}/harvestable_resources`` API endpoint
    with an admin user.

    In order to be harvested by the :ref:`harvesting scheduler <harvesting-scheduler-label>`, a harvestable resource
    must have its ``should_be_harvested`` attribute set to ``True``. This attribute can be set manually by the user
    or it can be set automatically by the harvester worker, in case the corresponding harvester is configured with
    ``harvest_new_resources_by_default = True``


.. _harvesting-session-label:

harvesting session
    Each periodic harvesting session

    There are two types of harvesting session:

    * **refresh session**
    * **harvesting session**

.. _harvesting-scheduler-label:

harvesting scheduler
    The scheduler is responsible for periodically spawining new harvesting sessions


.. _harvesting-operations-label:

Harvester operations
====================

Each GeoNode harvester is able to perform a finite set of operations. These can be performed:

* In an automated fashion, when the harvesting scheduler is in charge of handling the harvesting.

* On-demand, by explicit request of the user. On-demand execution can be requested by one of two ways:

  * By selecting the relevant harvester(s) in the ``harvesting/harvesters`` section of the GeoNode admin area and then
    selecting an action from the drop-down menu

  * By interacting with the GeoNode RESt API. Harvester actions are requested by issuing ``HTTP PATCH`` requests to
    the ``/api/v2/harvesters/{harvester-id}``.


While performing an action, the harvester's ``status`` property transitions from ``READY`` to whatever action-related
status (as indicated below). As the operation finishes execution, the harvester's status transitions back to ``READY``.
If the harvester has any status other than ``READY``, then it is currently busy. When a harvester is busy it cannot
execute other operations, you'll need to wait until the current operation finishes.


.. _check-remote-available-action-label:

Check if the remote service is available
----------------------------------------

This action causes the harvester to perform a simple health check on the remote service, in order to check whether it
responds successfully. The response is stored in the harvester's ``remote_available`` property. This action is performed
in the same process of the main GeoNode (*i.e.* it runs synchronously).


.. _update-harvestable-resources-action-label:

Update the list of harvestable resources
----------------------------------------

This action causes the harvester to interact with the remote service in order to discover which resources are
available for being harvested. Existing remote resources are then saved as
:ref:`harvestable resources <harvestable-resource-label>` and can be reviewed by visiting the
``/harvesting/harvestable resources`` section of the GeoNode admin.

Since this action can potentially take a long time to complete (as we don't know how may resources may exist on the
remote service), it is run on a background process. This background process stores its state and updates its execution
progress by means of a dedicated :ref:`harvesting session <harvesting-session-label>`. You can consult the session in
order to get up-to-date detail on the operation. The session will eventually transition to its ``finished`` state.
Additionally, while the harvester is performing this operation, its own status is set to
``updating harvestable resources``. The harvester cannot perform other actions until its status transitions back
to ``ready``.

Invocation via the GeoNode admin is performed by selecting the ``Update harvestable resources`` command.

Invocation via the GeoNode REST API is performed by issuing an HTTP PATCH request with a payload that sets the harvester status


.. _perform-harvesting-action-label:

Perform harvesting
------------------

This action causes the harvester to check which harvestable resources are currently marked as being harvestable and then,
for each one, extract the resource's metadata (and potentially the underlying dataset too) from the remote server. This
operation can potentially take a long time to complete, so it is performed in a background process by means of a celery task.
This background process stores its state and updates its execution progress by means of a dedicated
:ref:`harvesting session <harvesting-session-label>`. You can consult the session in order to get up-to-date detail on
the operation. The session will eventually transition to its ``finished`` state.

Additionally, while the harvester is performing this operation, its own status is set to
``performing harvesting``. The harvester cannot perform other actions until its status transitions back
to ``ready``.


.. _reset-harvester-action-label:

Reset harvester
---------------


Harvesting workflows
====================

The standard harvesting workflow involves the following steps:

#. User creates a new harvester;

   Typically the user will visit the GeoNode admin section and access the
   ``harvesting/harvesters`` section (this can also eb done via the GeoNode
   REST API). Upon creation, the user provides:

   * URL of the remote service that is to be harvested;

   * Type of harvester worker to use and relevant configuration options, as mentioned above in the
     :ref:`harvester worker section <harvesting-worker-label>`

#. The user now asks the harvester to discover available harvestable resources

   After having created the harvester, the user now needs to review which remote resources are available and select
   those that should be harvested. This is typically done by visiting the ``harvesting/harvesters`` page of the
   GeoNode admin, which shows a list of list of existing harvesters. The user now selects the relevant harvester from
   the list, selects the *Update available harvestable resources* action and presses the *OK* button. Alternatively,
   this step can be performed via the GeoNode REST API

   .. note::
      In order to be able to ask the harvester to update its list of harvestable resources, the current harvester
      status **must** be reported as *READY*. If that is not the case then the harvester is currently busy performing
      some other operation. In this case you will need to wait a while until the current operation is done.

   The harvester then proceeds

   Alternatively, if the harvester's ``harvest_new_resources_by_default`` parameter is set, GeoNode will automatically

#. User reviews the list of existing resources and selects those that should be harvested

#. Harvester proceeds to periodically create and update local GeoNode resources based on the remote resources


Periodic harvesting
===================

{explain the scheduler}

{explain how to configure harvesting via the django admin}

{explain how to configure harvesting via the API}

{available harvesters}

{how to add new harvesters}


.. _standard-harvester-workers-label:

Standard harvester workers
==========================

.. _geonode-harvester-worker-label:

GeoNode
-------

Configuration value: ``geonode.harvesting.harvesters.geonodeharvester.GeonodeUnifiedHarvesterWorker``

This is appropriate for harvesting from remote GeoNode deployments




.. _wms-harvester-worker-label:

WMS
---

Configuration value: ``geonode.harvesting.harvesters.wms.OgcWmsHarvester``

This is appropriate for harvesting from remote OGC WMS servers


.. _arcgis-harvester-worker-label:

ArcGIS REST Services
--------------------

Configuration value: ``geonode.harvesting.harvesters.arcgis.ArcgisHarvesterworker``

This is appropriate for harvesting from ArcGIS REST services


Troubleshooting
===============

{mention the reset status action}



.. _creating-new-workers-label:

Creating new harvesting workers
===============================

New harvesting workers can be created by writing classes derived from ``geonode.harvesting.harvesters.base.BaseGeonodeHarvesterWorker``. This class
implements an abstract interface...


Implementation details
======================

.. note::
  This section is only relevant for GeoNode developers - or if you are very curious about the internal implementation
  of the GeoNode harvesting


Most :ref:`harvesting operations <harvesting-operations-label>` are implemented as celery tasks and are meant to be ran
asynchronously. They use the django DB as a means to communicate the state of each operation, most notably a harvester's
``status`` attribute is used to implement a simple state machine, whereby a state has predefined fixed transitions.

The :ref:`harvesting scheduler <harvesting-scheduler-label>` is also implemented as a celery task and also runs
asynchronously. Moreover, it is triggered by means of a celery beat schedule that has a fixed periodicity - this is
configurable in the ``HARVESTER_SCHEDULER_FREQUENCY_MINUTES`` setting (the default value is to trigger this task
every 30 seconds). This has some implications on the timeliness of scheduled harvesting sessions. Since the harvesting
scheduler only checks if there is work to do once every 30 seconds, there can be some small delay between the time a
harvesting operation is supposed to be scheduled and the actual time when it is indeed scheduled. If the celery worker is
busy that may also cause a delay in the harvesting scheduler, as its task may not be triggered immediately.