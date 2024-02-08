===================
API usage examples
===================

| In this section, we are going to demostrate how to use linked resources api

Linked Resources Listing and Details
------------------------------------

All available linked_resources  can be listed with API ``GET /api/v2/resources/{pk}/linked_resources``.
where pk Resource base id

Example Requests:
^^^^^^^^^^^^^^^^^

1. List all resource links

.. code-block:: python

    import requests

    url = "https://master.demo.geonode.org/api/v2/resources/{pk}/linked_resources"
    response = requests.request("GET", url)







To link resources between them the endpoint implements POST and DELETE methods
------------------------------------------------------------------------------
- /api/v2/resources/{pk}/linked_resources

Examples:
^^^^^^^^^
1. Add a resource link

.. code-block:: python

    import requests

    url = "https://master.demo.geonode.org/api/v2/resources/1797"
    payload={'target':[1,2,3]}
    response = requests.request("POST", url, data=payload)


2. Remove resource link

.. code-block:: python

    import requests

    url = "https://master.demo.geonode.org/api/v2/resources/1797"
    payload={'target':[1,2,3]}
    response = requests.request("POST", url, data=payload)

3. Response POST/DELETE

.. code-block:: python

    #in the event of a successful post
    {"success": [1,2,3],"error": [],"message": "Resources updated successfully"}
    #in case the target ids are not updated successfully
    {"success": [],"error": [1,2,3],"message": "Something went wrong"}




GeoNode linked resources can be filtered with the following query parameters:

.. list-table::
   :widths: 25 100
   :header-rows: 1

   * - Parameters
     - Resource id provided in the url
   * - linked resources connected to resource base
     - /api/v2/resources/{pk}/linked_resourcest
   * - linked resources connected to resource base filtered by resource type
     - /api/v2/resources/{pk}/linked_resources?resource_type=map,dataset
   * - linked resources connected to resource base filtered by link type
     - /api/v2/resources/{pk}/linked_resources?link_type=linked_by

1. Resource Type can by filtered by multiple values if they're seperated by a comma

.. code-block:: python

    import requests

    url = "https://master.demo.geonode.org//api/v2/resources/{pk}/linked_resources?resource_type=map,dataset&linked_type=linked_by,linked_to"
    response = requests.request("GET", url, headers=headers, data=payload)

2. Filter with linked_type

.. code-block:: python

    import requests

    url = "https://master.demo.geonode.org//api/v2/resources/{pk}/linked_resources?link_type=linked_to"

    response = requests.request("GET", url, headers=headers)

=====================
Response GET
=====================

The api will respond with with the follwing payload based on present filters

--------------------------------------------------------------------------------


.. code-block:: python

    {
        "WARNINGS": {
        "DEPRECATION": "'resources' field is deprecated, please use 'linked_to'"
        },
        "resources": [{
            "pk": 3,
            "title": ">>> vertexes",
            "resource_type": "dataset",
            "detail_url": "/catalogue/#/dataset/3",
            "thumbnail_url": "http://localhost:8000/upload1.jpg"
        }],
        "linked_to": [
        {
            "internal": false,
            "pk": 3,
            "title": "vertexes",
            "resource_type": "dataset",
            "detail_url": "/catalogue/#/dataset/3",
            "thumbnail_url": "http://localhost:8000/uploaded/thumbs/dataset-ac0cd7d6931.jpg"
        }],
        "linked_by": []
    }



