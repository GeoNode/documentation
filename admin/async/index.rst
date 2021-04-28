Supervisord and Systemd
=======================

Celery
======

Rabbitmq and Redis
==================

How to: Async Upload via API
============================
In geonode is possible to upload resources via API in async/sync way.

Here is available a full example of upload via API 
https://github.com/GeoNode/geonode/blob/582d6efda74adb8042d1d897004bbf764e6e0285/geonode/upload/api/tests.py#L416

Step 1
------

Create a common client session, this is foundamental due the fact that geonode will check the request session.
For example with requests we will do something like:

.. code-block:: python

    import requests
    client = requests.session()


Note: in Django this part is already managed

Step 2
------

Call the `api/v2/uploads/upload` endpoint in PUT (is a form-data endpoint) by specifing in files a dictionary with the names and the files that we want to uploads and a data payload with the required informations.
For example:

.. code-block:: python

    params = {
        "permissions": '{ "users": {"AnonymousUser": ["view_resourcebase"]} , "groups":{}}',  # layer permissions
        "time": "false",
        "layer_title": "layer_title",
        "time": "false",
        "charset": "UTF-8",
    }

    files = {
        "filename": <_io.BufferedReader name="filename">
    }

    client.put(
        "http://localhost:8000/api/v2/uploads/upload/",
        auth=HTTPBasicAuth(username, password),
        data=params,
        files=files,
    )

    Returns:
    - dict with import id of the resource

Step 3
------

Call in the final upload page in order to trigger the actual import. 
If correclty set, Geoserver will manage the upload asyncronously.

.. code-block:: python

    client.get("http://localhost:8000/upload/final?id={import_id}")

    The `import_id` is returned from the previous step

Step 4
------

The upload as been completed on GeoNode, we should check utill Geoserver has complete his part.
To do so, is enougth to call the detailed information about the upload that we are performing

.. code-block:: python

    client.get(f"http://localhost:8000/api/v2/uploads/{upload_id}")

When the status is `PROCESSED` and the completion is `100%` we are able to see the resource in geonode and geoserver