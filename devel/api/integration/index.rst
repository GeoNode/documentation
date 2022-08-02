===========
API usage examples
===========

| In this section, we are going to demostrate how GeoNode API can be utilized/integrated with other applications using Python.

Resource Listing and Details
----------------------------

As mentioned in previous chapters, GeoNode resources are categorized in different types e.g. datasets, maps, documents. Etc.
All available resources can be listed with API ``GET /api/v2/resources``.

To obtain a single resource, a primary key is provided in the url. Eg ``GET /api/v2/resources/{resource.pk}``.

Example Requests:
^^^^^^^^^^^^^^^^^

1. Listing

.. code-block:: shell
 
    import requests
    
    url = "https://master.demo.geonode.org/api/v2/resources"
    response = requests.request("GET", url)
 
2. Detail
 
.. code-block:: shell

    import requests
    
    url = "https://master.demo.geonode.org/api/v2/resources/1797"
    response = requests.request("GET", url)

.. note:: The above requests work for publicly visible resources. If a resource is private either the Basic Auth or the Bearer token must be included inside the headers.

3. Listing with basic auth:

.. code-block:: shell

    import requests
    
    url = "https://master.demo.geonode.org/api/v2/resources"
    headers = {
        'Authorization': 'Basic dXNlcjpwYXNzd29yZA=='
    }
    response = requests.request("GET", url, headers=headers)

Resource Download
-----------------

The download URL for a resource can be obtained from ``resource.download_url``. This URL executes the synchronous download of a resource in its default download format (ESRI Shapefile for vector, Geotiff for rasters and the original format for documents). 
Additional export formats for datasets are available through the UI. At the moment the API doesn’t expose them.

Resource Links
---------------

From the resource detail response, URls and links to services can be obtained from the ``resource.links[]`` array value.
The purpose of each link is defined by its ``link_type``. The “name” also can specify additional information about the linked resource. 

1. Metadata
^^^^^^^^^^^

Links to each metadata format can be obtained from links with ``link_type = "metadata"``

2. OGC services
^^^^^^^^^^^^^^^

OGC requests can be built by taking:
the OGC base url from  links from ``resource.links[]`` with ``"link_type"= ("OGC:WMS | OGC:WFS | OGC:WCS)``
the OGC service layername obtained from the ``resource.alternate`` property 

1. Embedding
^^^^^^^^^^^^
A resource can be embedded inside a third party website. The “embed view” of a resource is suitable to be placed inside an iframe.
The URL for the embedded view can be obtained from the ``resource.embed_url`` property.

Resource Searching and Filtering
--------------------------------

GeoNode resources can be filtered with the following query parameters:

.. list-table::
   :widths: 25 100
   :header-rows: 1

   * - Parameters
     - URL
   * - title and abstract ``(paginated free text search)``
     - /api/v2/resources?page=1&search=text-to-search&search_fields=title&search_fields=abstract
   * - resource_type ``(dataset, map, document, geostory, dashboard)``
     - /api/v2/resources?filter{resource_type}=map
   * - subtype ``(raster,vector, vector_time, remote)``
     - /api/v2/resources?filter{resource_type}=vector
   * - favorite ``(Boolean True)``
     - /api/v2/resources?favorite=true
   * - featured ``(Boolean True or False)``
     - /api/v2/resources?filter{featured}=true
   * - published ``(Boolean True or False)``
     - /api/v2/resources?filter{is_published}=true
   * - aprroved ``(Boolean True or False)``
     - /api/v2/resources?filter{is_approved}=true
   * - category
     - api/v2/resources?filter{category.identifier}=example
   * - keywords
     - /api/v2/resources?filter{keywords.name}=example
   * - regions
     - /api/v2/resources?filter{regions.name}=global
   * - owner
     - /api/v2/resources?filter{owner.username}=test_user
   * - extent ``(Four comer separated coordinates)``
     - /api/v2/resources?extent=-180,-90,180,90

Examples:
^^^^^^^^^

1. Filter with a single value

.. code-block:: shell

    import requests
    
    url = "https://master.demo.geonode.org/api/v2/resources/?filter{resource_type}=map"
    response = requests.request("GET", url, headers=headers, data=payload

2. Filter with multiple values

.. code-block:: shell

    import requests
    
    url = "https://master.demo.geonode.org/api/v2/resources/?filter{resource_type.in}=map&filter{resource_type.in}=dataset"
    response = requests.request("GET", url, headers=headers, data=payload)


.. note:: 
    With filter APIs of format ``/api/v2/resources?filter{filter_key}=value``, additional methods(in and icontains) can be used on them to provide extensively filtered results.
    Eg
    ``/api/v2/resources?filter{regions.name.icontains}=global``
    ``/api/v2/resources?filter{regions.name.in}=global``.

    It's important to note that other methods are case sensitive except the icontains.


Obtaining Available Resource Types
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The list of available resource types can be obtained from API
``GET /api/v2/resources/resource_types``

Example:

.. code-block:: shell

    import requests
    
    url = "https://master.demo.geonode.org/api/v2/resources/resource_types"
    response = requests.request("GET", url, headers=headers, data=payload)

Resource Upload
---------------

GeoNode allows upload of datasets and documents.

1. Datasets

The dataset upload form accepts file formats of ESRI Shapefile, GeoTIFF, Comma Separated Value (CSV), Zip Archive, XML Metadata File, and Styled Layer Descriptor (SLD).
For a successful upload, the form requires base_file, dbf_file, shx_file, and prj_file. The xml_file, and Sld_file are optional.

- API: ``POST /api/v2/uploads/upload``
- Status Code: ``200``

Example:

.. code-block:: shell

    import requests
    
    url = "https://master.demo.geonode.org/api/v2/uploads/upload"
    files= [
    ('sld_file',('BoulderCityLimits.sld',open('/home/BoulderCityLimits.sld','rb'),'application/octet-stream')),   ('base_file',('BoulderCityLimits.shp',open('/home/BoulderCityLimits.shp','rb'),'application/octet-stream')),  ('dbf_file',('BoulderCityLimits.dbf',open('/home/BoulderCityLimits.dbf','rb'),'application/octet-stream')),  ('shx_file',('BoulderCityLimits.shx',open('/home/BoulderCityLimits.shx','rb'),'application/octet-stream')),
    ('prj_file',('BoulderCityLimits.prj',open('/home/BoulderCityLimits.prj','rb'),'application/octet-stream))
    ]
    headers = {
    'Authorization': 'Basic dXNlcjpwYXNzd29yZA=='
    }
    response = requests.request("POST", url, headers=headers, files=files)


Tracking dataset upload progress
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
When an upload request is executed, GeoNode creates an “upload object” and keeps updating its state and progress (it’s a property attribute, calculated on getting the response) attributes as the resource is being created and configured in Geoserver.
The states used include:
    - READY
    - RUNNING
    - PENDING
    - WAITING
    - INCOMPLETE
    - COMPLETE
    - INVALID
    - PROCESSED

When the dataset is successfully uploaded, the final state of the upload is set to ``PROCESSED`` and progress is calculated as ``100.0``.

In order to view ongoing uploads, and their states, you can use the API ``GET /api/v2/uploads`` or ``GET /api/v2/uploads/{id}`` if the upload id is known. You can also filter uploads with state.
Eg ``GET /api/v2/uploads?filter{state}=PROCESSED``

Example:

.. code-block:: shell

    import requests
    
    url = "https://master.demo.geonode.org/api/v2/uploads"
    headers = {
        'Authorization': 'Basic dXNlcjpwYXNzd29yZA=='
    }
    response = requests.request("GET", url, headers=headers)

 
2. Documents

.. note:: At the moment documents can't be uploaded through the API. This will probably change in the future.

Resource Update
---------------

- API: ``PATCH /api/v2/resources/{pk}``
- Status Code: ``200``

The payload can be all resource attributes or only attributes you want to change.

Example:

.. code-block:: shell
    import requests
    import json
    
    url = "https://master.demo.geonode.org/api/v2/resources/1778"
    payload = json.dumps({
        “title”: “BoulderCityLimits3 update”,
        “abstract”: “new abstract”
    })
    headers = {
        ‘Authorization’: ‘Basic dXNlcjpwYXNzd29yZA==’
    }
    response = requests.request("PATCH", url, headers=headers, data=payload)

Resource Delete
---------------

- API: ``DELETE /api/v2/resources/{pk}/delete``
- Status Code: ``204``

Example:

.. code-block:: shell
    import requests
    
    url = "https://master.demo.geonode.org/api/v2/resources/1778"
    headers = {
        'Authorization': 'Basic dXNlcjpwYXNzd29yZA=='
    }
    response = requests.request("DELETE", url, headers=headers)

Resource Download
-----------------

GeoNode offers a download option to resources of resource_type dataset and document.
For datasets, the download option is available for only datasets with uploaded files.

1. Datasets

- API: ``GET /datasets/{resource.alternate}/dataset_download``
- Status Code: ``200``

Example:

.. code-block:: shell

    import requests
    
    url = "https://master.demo.geonode.org/datasets/geonode:BoulderCityLimits3/dataset_download"
    response = requests.request("GET", url)

2. Documents

- API: ``GET /documents/{resource.pk}/download``
- Status Code: ``200``

Example:

.. code-block:: shell

    import requests
    
    url = "https://master.demo.geonode.org/documents/1781/download"
    response = requests.request("GET", url)


Users, Groups and Permissions
-----------------------------

Users
^^^^^

1. Listing

- API: ``POST /api/v2/users``
- Status Code: ``200``

Example:

.. code-block:: shell

    import requests
    
    url = "https://master.demo.geonode.org/api/v2/users"
    headers = {
        'Authorization': 'Basic dXNlcjpwYXNzd29yZA=='
    }
    response = requests.request("GET", url, headers=headers)


 
 
1. Detail

- API: ``POST /api/v2/users/{pk}``
- Status Code: ``200``

Example:

.. code-block:: shell

    import requests
    
    url = "https://master.demo.geonode.org/api/v2/users/1000"
    headers = {
        'Authorization': 'Basic dXNlcjpwYXNzd29yZA=='
    }
    response = requests.request("GET", url, headers=headers)


		
3. List user groups

- API: ``POST /api/v2/users/{pk}/groups``
- Status Code: ``200``

Example:

.. code-block:: shell

    import requests
    
    url = "https://master.demo.geonode.org/api/v2/users/1000/groups"
    headers = {
        'Authorization': 'Basic dXNlcjpwYXNzd29yZA=='
    }
    response = requests.request("GET", url, headers=headers)

Groups
^^^^^^

In GeoNode, On listing groups, the api returns groups which have group profiles. Therefore for django groups which are not related to a group profile are not included in the response. However these can be accessed in the Django Administration panel.

- API: ``POST /api/v2/groups``
- Status Code: ``200``

Example:

.. code-block:: shell

    import requests
    
    url = "https://master.demo.geonode.org/api/v2/groups"
    headers = {
        'Authorization': 'Basic dXNlcjpwYXNzd29yZA=='
    }
    response = requests.request("GET", url, headers=headers)




Permissions
^^^^^^^^^^^
Permissions in GeoNode are set per resource and per user or group. The following are general permissions that can be assigned:

- *View:* allows to view the resource. ``[view_resourcebase]``
- *Download:* allows to download the resource specifically datasets and documents. ``[ view_resourcebase, download_resourcebase]``
- *Edit:* allows to change attributes, properties of the datasets features, styles and metadata for the specified resource. ``[view_resourcebase, download_resourcebase, change_resourcebase, change_dataset_style, change_dataset_data, change_resourcebase_metadata]``
- *Manage:* allows to update, delete, change permissions, publish and unpublish the resource. ``[view_resourcebase, download_resourcebase, change_resourcebase, change_dataset_style, change_dataset_data, publish_resourcebase, delete_resourcebase, change_resourcebase_metadata, change_resourcebase_permissions]``

Obtaining permissions on a resource
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

On listing the resources or on resource detail API, GeoNode includes perms attribute to each resource with a list of permissions a user making the request has on the respective resource.

GeoNode also provides an API to get an overview of permissions set on a resource. The response contains users and groups with permissions set on them. However this API returns ``200`` if a requesting user has ``manage`` permissions on the resource otherwise it will return ``403 (Forbidden)``.

- API: ``GET /api/v2/resources/1791/permissions``

Example:

.. code-block:: shell

    import requests
    
    url = "https://master.demo.geonode.org/api/v2/resources/1791/permissions"
    headers = {
        'Authorization': 'Basic dXNlcjpwYXNzd29yZA=='
    }
    response = requests.request("GET", url, headers=headers)


Changing permissions on a resource
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Permissions are configured with a so called ``perms spec``, which is a JSON structured where permissions for single users and groups can be specified.

The example below shows a perm specification for following rules:

- user1 can ``edit``
- user2 can ``manage``
- group1 can ``edit``
- anonymous users (public) can ``view``
- registered members can ``download``

NOTE: The id of the “anonymous” and “registered members” groups can be obtained from the permissions of the resource. They are not listed inside the groups API, since these are spceial internal groups

.. code-block:: shell

    { 
        "users": [
            {
                "id": <id_of_user1>,
                "permissions": "edit"
            },
            {
                "id": <id_of_user2>,
                "permissions": "manage"
            }
        ],
        "organizations": [
            {
                "id": <id_of_group1>,
                "permissions": "edit"
            },
        ],
        "groups": [
            {
                "id": <id_of_anonymous_group>,
                "permissions": "view"
            },
            {
                "id": <id_of_regisdtered-members_group>,
                "permissions": "download"
            }
        ]
    }

The perm spec is sent as JSON, with ``application/json Content-Type``, inside a ``PUT`` request.

.. code-block:: shell

    import requests
    import json
    
    url = "https://master.demo.geonode.org/api/v2/resources/1791/permissions"
    payload = json.dumps({
    "users": [
        {
        "id": 1001,
        "permissions": "edit"
        },
        {
        "id": 1002,
        "permissions": "manage"
        }
    ],
    "organizations": [
        {
        "id": 1,
        "permissions": "edit"
        }
    ],
    "groups": [
        {
        "id": 2,
        "permissions": "view"
        },
        {
        "id": 3,
        "permissions": "download"
        }
    ]
    })
    headers = {
    'Authorization': 'Basic dXNlcjpwYXNzd29yZA==',
    'Content-Type': 'application/json',
    }
    
    response = requests.request("PUT", url, headers=headers, data=payload)

This is an asynchrnous operation which returns a response similar to the following:

.. code-block:: shell

    {
        "status": "ready",
        "execution_id": "7ed578c2-7db8-47fe-a3f5-6ed3ca545b67",
        "status_url": "https://master.demo.geonode.org/api/v2/resource-service/execution-status/7ed578c2-7db8-47fe-a3f5-6ed3ca545b67"
    }


The ``status_url`` property returns the URL to track kthe progress of the request. Querying the URL a result similar to the following will be returned:

.. code-block:: shell

    {
        "user": "admin",
        "status": "running",
        "func_name": "set_permissions",
        "created": "2022-07-08T11:16:32.240453Z",
        "finished": null,
        "last_updated": "2022-07-08T11:16:32.240485Z",
        "input_params": {
        …
        }
    }


The operation will be completed once the ``status`` property is updated with the value ``finished``.

