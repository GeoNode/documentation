.. _options-menu-tools:

Other Menu Tools
==================

.. |burger_menu_button| image:: ../img/burger_menu_button.png
    :width: 30px
    :height: 30px
    :align: middle

At the top of the *Map* there are more menu items which we are are going to explain in this section.

.. figure:: img/options_menu_tools.png
     :align: center

     *The Map Options Menu*

Printing a map
--------------

| The `MapStore <https://mapstore2.geo-solutions.it/mapstore/#/>`_ based map viewer of GeoNode allows you to print the current view with a customizable layout.
| Click the :guilabel:`Print` option from the *Menu*, the **Printing Window** will open.

.. figure:: img/printing_window.png
     :align: center

     *The Printing Window*

From this window you can:

* enter *Title* and *Description*;
* choose the *Resolution* in dpi;
* select the format
* select the coordinate
* add the scale
* add grid with label
* customize the *Layout*

  + the *Sheet size* (A3, A4);
  + if include the legend or not;
  + if to put the legend in a separate page;
  + the page *Orientation* (Landscape or Portrait);

* customize the *Legend*

  + the *Label Font*;
  + the *Font Size*;
  + the *Font Emphasis* (bold, italic);
  + if *Force Labels*;
  + if use *Anti Aliasing Font*;
  + the *Icon Size*;
  + the *Legend Resolution* in dpi.

To print the view click on :guilabel:`Print`.

Add dataset
------------------

All the datasets available in GeoNode, both uploaded and remote, can be loaded on the map through the *Catalog*.
Click on the :guilabel:`Add dataset` option of the *Menu* to take a look at the catalog panel.

.. figure:: img/datasets_catalog.png
     :align: center

     *The Datasets Catalog*

You can navigate through datasets and look at their *Thumbnail* images, *Title*, *Description* and *Abstract*.
Click on a dataset to load it into the map, it will be also visible in the :ref:`toc`.

Performing Measurements
-----------------------

Click on the :guilabel:`Measure` option of the *Menu* to perform a measurement.
As you can see in the picture below, this tool allows you to measure *Distances*, *Areas* and the *Bearing* of lines.

.. figure:: img/measure_tool.png
     :align: center

     *The Measure Tool*

| To perform a measure draw on the map the geometry you are interested in, the result will be displayed on the left of the unit of measure select menu (this tool allows you to change the unit of measure also).

.. figure:: img/measuring_areas.png
     :align: center

     *Measuring Areas*

Add an Annotation
------------
Click on the :guilabel:`Annotations` option of the *Menu* to enrich the map with special features which expose additional information, mark particular position on the map and so on.

.. figure:: img/add_annoations.png
     :align: center

     *Annotations panel*

.. |add_annotations_button| image:: img/add_annotations_button.png
    :width: 30px
    :height: 30px
    :align: middle

To begin, from the annotation panel, the editor can open the new annotation panel by selecting the |add_annotations_button| button.

.. figure:: img/add_an_annotations.png
     :align: center

     *Add an Annotations*

From here the editor can insert a *Title*, a *Description* and choose between five different types of *Geometries*:

1. *Marker*
2. *Line*
3. *Polygon*
4. *Text*
5. *Circle* 

See the `MapStore Documentation <https://docs.mapstore.geosolutionsgroup.com/en/latest/user-guide/annotations/>`_ for more information.

Saving a map
------------

| Once all the customizations have been carried out, you can *Save* your map by clicking on the :guilabel:`Save` option of the *Menu*.
| Click :guilabel:`Save` again under the Save options.

|You could create a new map from the existing view by clicking :guilabel:`Save As..`.
| A new popup window will open.

.. figure:: img/saving_map.png
     :align: center

     *Saving Maps*

The current map title is filled by default, You can change it to the prefered naming then click on :guilabel:`Save`. The page will reload and your map should be visible in the :ref:`finding-data` list.
