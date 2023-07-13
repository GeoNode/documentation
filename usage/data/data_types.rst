.. _data-types:

Data Types
==========

| GeoNode welcome page shows a variety of information about the current GeoNode instance.
| You can explore the existing data using many search tools and filters (see :ref:`finding-data`) or through the links of the navigation bar at the top of the page.
| There are three main types of resources that GeoNode can manage:

#. Documents
#. Datasets
#. Maps

Datasets and Documents can be accessed from the :guilabel:`Data` menu of the navigation bar.
The :guilabel:`Maps` menu lets you filter only maps in the available resource. This applies to other existing menu items like :guilabel:`GeoStories`.

.. note:: :guilabel:`GeoStories` and :guilabel:`Dashboards` In the screenshot below are GeoApp resouce types which are added by the client.

.. figure:: img/data_menu.png
     :align: center

     *Data menu*

.. _document-data-type:

Documents
---------

| GeoNode allows to publish tabular and text data and to manage metadata and associated documents.
| Documents can be uploaded directly from your disk (see :ref:`uploading-documents` for further information).
| The following documents types are allowed: `txt, .log, .doc, .docx, .ods, .odt, .sld, .qml, .xls, .xlsx, .xml, .bm, .bmp, .dwg, .dxf, .fif, .gif, .jpg, .jpe, .jpeg, .png, .tif, .tiff, .pbm, .odp, .ppt, .pptx, .pdf, .tar, .tgz, .rar, .gz, .7z, .zip, .aif, .aifc, .aiff, .au, .mp3, .mpga, .wav, .afl, .avi, .avs, .fli, .mp2, .mp4, .mpg, .ogg, .webm, .3gp, .flv, .vdo, .glb, .pcd, .gltf`.
| Through the document detailed page is possible to view, download and manage a document.

Datasets
------

| Datasets are a primary component of GeoNode.
| Datasets are publishable resources representing a raster or vector spatial data source. Datasets also can be associated with metadata, ratings, and comments.

| By clicking the Datasets link you will get a list of all published datasets. If logged in as an administrator, you will also see the unpublished datasets in the same list.
| GeoNode allows the user to upload vector and raster data in their original projections using a web form.

Vector data can be uploaded in many different formats (ESRI Shapefile, KML and so on...). Satellite imagery and other kinds of raster data can be uploaded as GeoTIFFs.

Maps
----

| Maps are a primary component of GeoNode.
| Maps are comprised of various datasets and their styles. Datasets can be both local datasets in GeoNode as well as remote datasets either served from other WMS servers or by web service datasets such as Google or MapQuest.

GeoNode maps also contain other information such as map zoom and extent, dataset ordering, and style.

You can create a map based on uploaded datasets, combine them with some existing datasets and a remote web service dataset, share the resulting map for public viewing.
Once the data has been uploaded, GeoNode lets the user search for it geographically or via keywords and create maps.
All the datasets are automatically reprojected to web mercator for maps display, making it possible to use popular base maps such as `OpenStreetMap <https://www.openstreetmap.org>`_.
