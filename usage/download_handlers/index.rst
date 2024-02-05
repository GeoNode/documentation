.. _data:

Download Handlers
=================

With GeoNode 4.2.x has been introduced the concept of Download Handler and ofc GeoNode provides a default implementation of it which process the download via WPS

Follow an example of how to create a custom download handler and to replace the default one or add an additional one.


Settings
========

DEFAULT_DATASET_DOWNLOAD_HANDLER
--------------------------------

    Default: ``geonode.layers.download_handler.DatasetDownloadHandler``

    path to the download handler location

DATASET_DOWNLOAD_HANDLERS
-------------------------

    Default: ``[]``

    List of paths of the additional download handlers


CODE
====


The default download handler is placed under the `geonode.layers` [package](https://github.com/GeoNode/geonode/blob/master/geonode/layers/download_handler.py) 

Follow an example of an basic class for define the download handler:

```python

class DatasetDownloadHandler:
    def __str__(self):
        return f"{self.__module__}.{self.__class__.__name__}"

    def __repr__(self):
        return self.__str__()

    def __init__(self, request, resource_name) -> None:
        self.request = request
        self.resource_name = resource_name
        self._resource = None

    def get_download_response(self):
        """
        Main method used, this method should return the response object 
        """
        return response
        @property

    def download_url(self):
        """
        Used by the API, it should return the URL where the resource can be downloaded from
        """
        return reverse("dataset_download", args=[resource.alternate])

```


If you prefer to inherit from the already existing one, the response is generated in the `process_dowload` method
