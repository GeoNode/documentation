=========================================
Harvesting resources from remote services
=========================================

GeoNode is able to harvest resource metadata from multiple remote services.

Harvesting is the process by which a metadata catalogue, *i.e.* GeoNode, is able to connect to other remote catalogues
and retrieve information about their resources. This process is usually performed periodically, in order to keep the
local catalogue in sync with the remote.

When appropriately configured, GeoNode will contact the remote service, extract a list of relevant resources that can be
harvested and create local resources for each remote resource. It will also keep the resources synchronized with the
remote service by periodically updating them.

Out of the box, GeoNode ships with support for harvesting from:

#. :ref:`Other remote GeoNode instances <geonode-harvester-worker-label>`;
#. :ref:`OGC WMS servers <wms-harvester-worker-label>`;
#. :ref:`ArcGIS REST services <arcgis-harvester-worker-label>`.

Adding support for :ref:`additional harvesting sources <creating-new-workers-label>` is also possible.


GeoNode harvesting concepts
===========================

When a **harvester** is configured, GeoNode is able to use its corresponding **harvester worker** to contact
the remote service and generate a list of **harvestable resources**.
The user is then able to select which of those resources are of interest. Depending on its configured update
frequency, sometime later, the **harvesting scheduler** will create new **harvesting sessions** in order to create
local GeoNode resources from the remote harvestable resources that had been marked as relevant by the user.

The above description uses the following key concepts:

.. _harvester-label:

harvester
    This is the configuration object that is used to parametrize harvesting of a remote service. It is configurable
    at runtime and is preserved in the GeoNode database.

    Harvesters and their properties can be managed by visiting the ``Harvesting -> Harvesters`` section of the GeoNode
    admin area, or by visiting the ``api/v2/harvesters/`` API endpoint with an admin user.

    Among other parameters, a harvester holds:

    remote_url
        Base URL of the remote service being harvested, *e.g.* ``https://stable.demo.geonode.org``

    harvester_type
        Type of harvester worker that will be used to perform harvesting. See the
        :ref:`Harvester worker concept <harvester-worker-label>` and the :ref:`standard harvester workers
        <standard-harvester-workers-label>` sections below for more detail. Example: ``geonode.harvesting.harvesters.geonodeharvester.GeonodeUnifiedHarvesterWorker``.

    scheduling_enabled
        Whether harvesting shall be performed periodically by the
        :ref:`harvesting scheduler <harvesting-scheduler-label>` or not.

    harvesting_session_update_frequency
        How often (in minutes) should new :ref:`harvesting sessions <harvesting-session-label>` be
        automatically scheduled?

    refresh_harvestable_resources_update_frequency
        How often (in minutes) should new :ref:`refresh sessions <refresh-session-label>` be automatically scheduled?

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

    #. :ref:`GeoNode <geonode-harvester-worker-label>` - Enables harvesting from other GeoNode deployments
    #. :ref:`WMS <wms-harvester-worker-label>` - Enables harvesting from OGC WMS servers
    #. :ref:`ArcGIS REST services <arcgis-harvester-worker-label>` - Enables harvesting from ArcGIS REST services

    :ref:`Adding new harvester workers <creating-new-workers-label>` is also possible. This allows custom GeoNode
    deployments to add support for harvesting from other remote sources.


.. _harvestable-resource-label:

harvestable resource
    A resource that is available on the remote server. Harvestable resources are persisted in the GeoNode DB. They are
    created during :ref:`refresh operations <update-harvestable-resources-action-label>`, when the harvester worker
    interacts with the remote service in order to discover which remote resources can be harvested.

    Harvestable resources can be managed by visiting the ``Harvesting -> Harvestable resources`` section of the
    GeoNode admin area, or by visiting the ``api/v2/harvesters/{harvester-id}/harvestable-resources`` API endpoint
    with an admin user.

    In order to be harvested by the :ref:`harvesting scheduler <harvesting-scheduler-label>`, a harvestable resource
    must have its ``should_be_harvested`` attribute set to ``True``. This attribute can be set manually by the user
    or it can be set automatically by the harvester worker, in case the corresponding harvester is configured with
    ``harvest_new_resources_by_default = True``


.. _asynchronous-session-label:

harvesting session
    In GeoNode, discovering remote resources and harvesting them is always done under the scope of a harvesting
    session. These sessions are stored in the GeoNode DB and can be inspected by visiting the
    ``Harvesting -> Asynchronous harvesting sessions`` section of the GeoNode admin area.

    Harvesting sessions are used to keep track of the progress of execution of the relevant harvesting operations. They
    are updated while each operation is running. There are two types of sessions:


    .. _refresh-session-label:

    refresh session
        This session is created during the :ref:`update of harvestable resources operation <update-harvestable-resources-action-label>`.
        It has ``type=discover-harvestable-resources``. During a refresh session, the harvester worker discovers remote
        resources and creates their respective :ref:`harvestable resources <harvestable-resource-label>` on the GeoNode
        DB. After such session is finished, the user can inspect the found harvestable resources and mark those that
        are relevant with ``should_be_harvester=True``.

    .. _harvesting-session-label:

    harvesting session
        This session is created during the :ref:`perform harvesting operation <perform-harvesting-action-label>`. It has
        ``type=harvesting``. During a harvesting session, the harvester worker creates or updates new GeoNode resources
        based on the harvestable resources that have been configured with ``should_be_harvested=True``.

    In addition to the aforementioned ``type``, harvesting sessions also carry the ``status`` attribute, which provides
    context on the current status of the session (and consequently of the underlying harvesting operation).


.. _harvesting-scheduler-label:

harvesting scheduler
    The scheduler is responsible for initiating new :ref:`harvesting operations <harvesting-operations-label>`
    in an automated fashion. Periodically, the scheduler goes through the list of existing harvesters, checking if it
    is time to dispatch one of the harvesting operations mentioned in the next section.

    The scheduler's operation frequency is configurable by defining a ``HARVESTER_SCHEDULER_FREQUENCY_MINUTES`` setting
    - the default is to trigger the scheduler every 30 seconds.

    .. note::

      Since the harvesting scheduler only checks if there is work to do once every ``x`` seconds
      (defaulting to 30 seconds, as mentioned above), there will usually be a delay between the time a harvesting
      operation is supposed to be scheduled and the actual time when it is indeed scheduled. Moreover, the harvesting
      scheduler is implemented as a celery task. This means that, if the celery worker is busy, that may also cause a
      delay in scheduling harvesting operations, as the scheduler's celery task may not be triggered immediately.


Harvesting workflows
====================

There are two main possible harvesting workflows:

#. :ref:`Continuous harvesting <continuous-harvesting-label>`
#. :ref:`One-time harvesting <one-time-harvesting-label>`


.. _continuous-harvesting-label:

Continuous harvesting
---------------------

   This workflow relies on the :ref:`harvesting scheduler <harvesting-scheduler-label>` in order to ensure harvested
   resources are continuously kept up to date with their remote counterparts.

   #. User creates harvester and sets its ``scheduling_enabled`` attribute to ``True``;
   #. When the time comes, the harvesting scheduler calls the
      :ref:`update list of harvestable resources operation <update-harvestable-resources-action-label>`. Alternatively,
      the user may call this operation manually the first time.
   #. When the previous operation is done, user goes through the list of generated
      :ref:`harvestable resources <harvestable-resource-label>` and, for each relevant harvestable resource, sets
      it ``should_be_harvested`` attribute to ``True``. Alternatively, if the harvester has its
      ``harvest_new_resources_automatically`` attribute set to ``True``, the harvestable resources will already be
      marked as to be harvested, without requiring manual user intervention;
   #. When the time comes, the harvesting scheduler calls the
      :ref:`perform harvesting operation <perform-harvesting-action-label>`. This causes
      the remote resources to be harvested. These now show up as resources on the local GeoNode.


.. _one-time-harvesting-label:

One-time harvesting
-------------------

   This workflow is mostly executed manually by the user.

   #. User creates harvester and sets its ``scheduling_enabled`` attribute to ``False``;
   #. User calls the :ref:`update list of harvestable resources operation <update-harvestable-resources-action-label>`;
   #. When the previous operation is done, user goes through the list of generated
      :ref:`harvestable resources <harvestable-resource-label>` and, for each relevant harvestable resource, sets
      it ``should_be_harvested`` attribute to ``True``;
   #. User then proceeds to call the :ref:`perform harvesting operation <perform-harvesting-action-label>`. This causes
      the remote resources to be harvested. These now show up as resources on the local GeoNode.



.. _harvesting-operations-label:

Harvester operations
====================

Each GeoNode harvester is able to perform a finite set of operations. These can be performed either:

#. In an **automated fashion**, being dispatched by the harvesting scheduler. Automated harvesting is only performed when
   the corresponding :ref:`harvester <harvester-label>` has ``scheduling_enabled=True``;

#. **On-demand**, by explicit request of the user. On-demand execution can be requested by one of two ways:

   #. By selecting the relevant harvester(s) in the ``Harvesting -> Harvesters`` section of the GeoNode admin area and
      then selecting and running an action from the drop-down menu;

   #. By interacting with the GeoNode REST API. Harvester actions are requested by issuing ``HTTP PATCH`` requests to
      the ``/api/v2/harvesters/{harvester-id}/`` endpoint. The payload of such requests must specify the corresponding
      status. For example, by issuing a request like::

          curl -X PATCH http:/localhost/api/v2/harvesters/1/ \
            -H "Content-Type: application/json" \
            -u "myuser:mypass" \
            --data '{"status": "updating-harvestable-resources"}'

      We are asking that the harvester's status be changed to ``updating-harvestable-resources``. If the server accepts
      this request, then the :ref:`update list of harvestable resources operation <update-harvestable-resources-action-label>`
      is triggered.

      .. note::

          The server will not accept the API request if the harvester's current status is not ``ready``.


While performing an action, the harvester's ``status`` property transitions from ``ready`` to whatever action-related
status is appropriate (as indicated below). As the operation finishes execution, the harvester's status transitions
back to ``ready``. If the harvester has any status other than ``ready``, then it is currently busy. When a harvester
is busy it cannot execute other operations, you'll need to wait until the current operation finishes.


.. _check-remote-available-action-label:

Check if the remote service is available operation
--------------------------------------------------

This operation causes the harvester to perform a simple health check on the remote service, in order to check whether it
responds successfully. The response is stored in the harvester's ``remote_available`` property. This operation is
performed in the same process of the main GeoNode (*i.e.* it runs synchronously).

When triggered, this operation causes the harvester's status to transition to ``checking-availability``.
As the operation finishes, the harvester's status transitions back to ``ready``.

Invocation via the GeoNode admin is performed by selecting the
``Check availability of selected harvesters`` command.

Invocation via the GeoNode REST API is performed by issuing an HTTP PATCH request with a payload that sets the
harvester status.


.. _update-harvestable-resources-action-label:

Update the list of harvestable resources operation
--------------------------------------------------

This operation causes the harvester to interact with the remote service in order to discover which resources are
available for being harvested. Existing remote resources are then saved as
:ref:`harvestable resources <harvestable-resource-label>`.

Since this operation can potentially take a long time to complete (as we don't know how may resources may exist on the
remote service), it is run using a background process. GeoNode creates a new :ref:`refresh session <refresh-session-label>`
and uses it to track the progress of this operation.

When triggered, this operation causes the harvester's status to transition to ``updating-harvestable-resources``.
As the operation finishes, the harvester's status transitions back to ``ready``.

Invocation via the GeoNode admin is performed by selecting the
``Update harvestable resources for selected harvesters`` command.

Invocation via the GeoNode REST API is performed by issuing an HTTP PATCH request with a payload that sets the
harvester status.


.. _perform-harvesting-action-label:

Perform harvesting operation
----------------------------

This operation causes the harvester to check which harvestable resources are currently marked as being harvestable
and then, for each one, harvest the resource from the remote server.

Since this operation can potentially take a long time to complete (as we don't know how may resources may exist on the
remote service), it is run using a background process. GeoNode creates a new :ref:`harvesting session <harvesting-session-label>`
and uses it to track the progress of this operation.

When triggered, this operation causes the harvester's status to transition to ``harvesting-resources``.
As the operation finishes, the harvester's status transitions back to ``ready``.

Invocation via the GeoNode admin is performed by selecting the ``Perform harvesting on selected harvesters`` command.

Invocation via the GeoNode REST API is performed by issuing an HTTP PATCH request with a payload that sets the
harvester status.


.. _abort-refresh-action-label:

Abort update of harvestable resources operation
------------------------------------------------

This operation causes the harvester to abort an on-going
:ref:`update list of harvestable resources operation <update-harvestable-resources-action-label>`.

When triggered, this operation causes the harvester's status to transition to ``aborting-update-harvestable-resources``.
As the operation finishes, the harvester's status transitions back to ``ready``.

Invocation via the GeoNode admin is performed by selecting the
``Abort on-going update of harvestable resources for selected harvesters`` command.

Invocation via the GeoNode REST API is performed by issuing an HTTP PATCH request with a payload that sets the
harvester status.


.. _abort-harvesting-action-label:

Abort harvesting operation
--------------------------

This operation causes the harvester to abort an on-going
:ref:`perform harvesting operation <perform-harvesting-action-label>`.

When triggered, this operation causes the harvester's status to transition to ``aborting-performing-harvesting``.
As the operation finishes, the harvester's status transitions back to ``ready``.

Invocation via the GeoNode admin is performed by selecting the
``Abort on-going harvesting sessions for selected harvesters`` command.

Invocation via the GeoNode REST API is performed by issuing an HTTP PATCH request with a payload that sets the
harvester status.


.. _reset-harvester-action-label:

Reset harvester operation
-------------------------

This operation causes the harvester's status to be reset back to ``ready``. It is mainly useful for troubleshooting
potential errors, in order to unlock harvesters that may get stuck in a non-actionable status when some unforeseen
error occurs.

When triggered, this operation causes the harvester's status to transition to ``ready`` immediately.

Invocation via the GeoNode admin is performed by selecting the ``Reset harvester status`` command.

This operation cannot be called via the GeoNode API.


.. _standard-harvester-workers-label:

Standard harvester workers
==========================

.. note::
    Remember that, as stated above, a harvester worker is configured by means of setting the ``harvester_type`` and
    ``harvester_type_specific_configuration`` attributes on the :ref:`harvester <harvester-label>`.

    Moreover, the format of the ``harvester_type_specific_configuration`` attribute must be a JSON object.


.. _geonode-harvester-worker-label:

GeoNode harvester worker
------------------------

This worker is able to harvest remote GeoNode deployments. In addition to creating local resources by retrieving
the remote metadata, this harvester is also able to copy remote datasets over to the local GeoNode. This means
that this harvester can even be used in order to generate replicated GeoNode instances.

This harvester can be used by setting ``harvester_type=geonode.harvesting.harvesters.geonodeharvester.GeonodeUnifiedHarvesterWorker``
in the harvester configuration.

It recognizes the following ``harvester_type_specific_configuration`` parameters:

harvest_datasets
    Whether to harvest remote resources of type ``dataset`` or not. Acceptable values: ``true`` (the default) or ``false``.

copy_datasets
    Whether to copy remote resources of type ``dataset`` over to the local GeoNode. Acceptable values: ``true`` or ``false`` (the default).

harvest_documents
    Whether to harvest remote resources of type ``document`` or not. Acceptable values: ``true`` (the default) or ``false``.

copy_documents
    Whether to copy remote resources of type ``document`` over to the local GeoNode. Acceptable values: ``true`` or ``false`` (the default).

resource_title_filter
    A string that must be present in the remote resources' ``title`` in order for them to be acknowledged as
    harvestable resources. This allows filtering out resources that are not relevant. Acceptable values: any
    alphanumeric value.

    Example: setting this to a value of ``"water"`` would mean that the harvester would generate harvestable resources
    for remote resources that are titled *water basins*, *Water territories*, etc. The harvester would not generate
    harvestable resources for remote resources whose title does not contain the word *water*.

start_date_filter
    A string specifying a datetime that is used to filter out resources by their start_date. This is parsed with
    :ref:`dateutil.parser.parse() <https://dateutil.readthedocs.io/en/stable/parser.html#dateutil.parser.parse>`,
    which means that it accepts many different formats (e.g. `2021-06-31T13:04:05Z`)

end_date_filter
    Similar to ``start_date_filter`` but uses resources' `end_date` as a filter parameter.

keywords_filter
    A list of keywords that are used to filter remote resources.

categories_filter
    A list of categories that are used to filter remote resources.


.. _wms-harvester-worker-label:

WMS harvester worker
--------------------

This worker is able to harvest from remote OGC WMS servers.

This harvester can be used by setting ``harvester_type=geonode.harvesting.harvesters.wms.OgcWmsHarvester``
in the harvester configuration.

It recognizes the following ``harvester_type_specific_configuration`` parameters:

dataset_title_filter
    A string that is used to filter remote WMS layers by their ``title`` property. If a remote layer's title contains
    the string defined by this parameter, then the layer is recognized by the harvester worker.


.. _arcgis-harvester-worker-label:

ArcGIS REST Services harvester worker
-------------------------------------

This worker is able to harvest from remote ArcGIS REST Services catalogs.

This worker is able to recognize two types of ``remote_url``:

#. URL of the ArcGIS REST services catalog. This URL usually ends in ``rest/services``. A catalog may expose several
   different services. This harvester worker is able to descend into the available ArcGIS Rest services and retrieve
   their respective resources. Example::

       https://sampleserver6.arcgisonline.com/arcgis/rest/services

#. URL of the ArcGIS REST services Service. This URL usually takes the form ``{base-url}/rest/services/{service-name}/{service-type}``. Example::

       https://sampleserver6.arcgisonline.com/arcgis/rest/services/CharlotteLAS/ImageServer

This harvester worker can be used by setting ``harvester_type=geonode.harvesting.harvesters.arcgis.ArcgisHarvesterWorker``
in the harvester configuration.

It recognizes the following ``harvester_type_specific_configuration`` parameters:

harvest_map_services
    Whether services of type `MapServer` ought to be harvested. Defaults to ``True``.

harvest_image_services
    Whether services of type `ImageServer` ought to be harvested. Defaults to ``True``.

resource_name_filter
    A string that is used to filter remote WMS layers by their ``title`` property. If a remote layer's name contains
    the string defined by this parameter, then the layer is recognized by the harvester worker.

service_names_filter
    A list of names that are used to filter the remote ArcGIS catalog.


.. _creating-new-workers-label:

Creating new harvesting workers
===============================

New harvesting workers can be created by writing classes derived from
:ref:`geonode.harvesting.harvesters.base.BaseGeonodeHarvesterWorker <https://github.com/GeoNode/geonode/blob/master/geonode/harvesting/harvesters/base.py#L66>`.
This class defines an abstract interface that must be implemented. All methods decorated with ``abc.abstractmethod``
must be implemented in the custom harvester worker class. Study the implementation of the standard GeoNode harvester worker
classes in order to gain insight on how to implement custom ones.

After writing a custom harvester worker class, it can be added to the list of known harvester workers by defining
the ``HARVESTER_CLASSES`` GeoNode setting. This setting is a list of strings, containing the Python class path to each
harvester worker class. It has a default value of::

    HARVESTER_CLASSES = [
        "geonode.harvesting.harvesters.geonodeharvester.GeonodeUnifiedHarvesterWorker",
        "geonode.harvesting.harvesters.wms.OgcWmsHarvester",
        "geonode.harvesting.harvesters.arcgis.ArcgisHarvesterWorker",
    ]

These are the standard harvester worker classes shipped by GeoNode. If this setting is defined, its value will simply
extend the default list. This means that it is not possible to disable the standard worker classes, only to add new ones.
