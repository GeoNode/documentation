.. _toc:

Table of Contents (TOC)
=======================

In the upper left corner, click on |toc_button| to open the *Table Of Contents*, briefly *TOC* from now on, of the map.
The *TOC* shows all the datasets involved with the *Map* and allows to manage their properties and representations on the map.

.. figure:: img/toc_panel.png
     :align: center
     :height: 200px

     *The Table Of Contents (TOC)*

From the *TOC* you can:

* manage the *TOC Settings* (click on |settings_toc_button|) (See the `MapStore Documentation <https://docs.mapstore.geosolutionsgroup.com/en/latest/user-guide/toc/#toc-settings-and-toolbar/>`_ for more information.)
* manage the datasets *Overlap*;
* filter the datasets list by typing text in the *Filter Datasets* field;
* manage the datasets properties such as *Opacity* (scroll the opacity cursor), *Visibility* (click on |hide_button| to make the dataset not visible, click on |show_button| to show it on map);
* add and manage *Annotations* (click on |annotation_button|)
* manage the *Dataset Settings*, see the next paragraph.

.. figure:: img/scrolling_opacity.png
     :align: center
     :height: 400px

     *Scrolling the Dataset Opacity*

Select a *Dataset* from the list and click on it, the *Dataset Toolbar* should appear in the *TOC*.

.. figure:: img/dataset_toolbar.png
     :align: center
     :height: 200px

     *The Dataset Toolbar*


The *Toolbar* shows you many buttons:

* the **Zoom to dataset extent** button allows you to zoom to the dataset extent;
* the **Filter layer** button that acts directly on a layer with WFS available and filter its content;
* the **Attribute Table** button to explore the features of the dataset and their attributes (more information at :ref:`attributes-table`);
* the **Delete** button to delete datasets (click on :guilabel:`Delete Dataset` to confirm your choice);
* the **Widgets** button to create Widgets (see :ref:`creating-widgets`).
* the **Export data** button;
* the **Settings** button drives you through the dataset settings customization (see the next paragraph);
* the **Compare tool** button to *Swipe* or *Spy* the selected layer
* the **Edit Style** button;


Managing Dataset Settings
-----------------------

The *Dataset Settings* panel looks like the one below.

.. figure:: img/dataset_settings_panel.png
     :align: center
     :height: 600px

     *The Dataset Settings Panel*

The *Dataset Settings* are divided in three groups:

1. *General* settings
2. *Visibility* settings
3. *Style* settings
4. *Tiling* settings

In the **General** tab of the *Settings Panel* you can customize the dataset *Title*, insert a *Description*, change/add the *Dataset Group* and change the *Tooltip content* and the *Tooltip placement*.

The **Visibility** tab where you can Change the *Opacity* of the layer and add the *Visibility limits* to display the layer only within certain scale limits

.. figure:: img/visibility_settings.png
     :align: center
     :height: 400px

     *The Visibility tab on Settings Panel*

The **Style** tab allows you to select the style from the available layer styles and change the *Width* and the *Height* of the *Legend*.

.. figure:: img/style_settings.png
     :align: center
     :height: 400px

     *The Style tab on Settings Panel*

Click on the **Tiling** tab to change the output *Format* of the WMS requests, the *Tile Size* and enable/disable the *Trasparent*, the *Use cache options* and the *Single Tile*.

.. figure:: img/tiling_settings.png
     :align: center
     :height: 400px

     *The Tiling tab on Settings Panel*

.. |toc_button| image:: img/toc_button.png
    :width: 30px
    :height: 30px
    :align: middle

.. |hide_button| image:: img/hide_button.png
    :width: 30px
    :height: 30px
    :align: middle

.. |show_button| image:: img/show_button.png
    :width: 30px
    :height: 30px
    :align: middle

.. |settings_toc_button| image:: img/settings_toc_button.png
    :width: 30px
    :height: 30px
    :align: middle

Add an Annotation
------------
Click on the |annotation_button| button from the *TOC Toolbar* to enrich the map with special features which expose additional information, mark particular position on the map and so on.
From here the editor can insert a *Title* and a *Description*.

.. figure:: img/add_annoations.png
     :align: center

     *Annotations panel*

.. |add_annotations_button| image:: img/add_annotations_button.png
    :width: 30px
    :height: 30px
    :align: middle

.. |annotation_button| image:: img/annotation_button.png
    :width: 30px
    :height: 30px
    :align: middle

To begin, from the annotation panel, the editor add new annotation by selecting the :guilabel:`Geometries` tab.

.. figure:: img/add_an_annotations.png
     :align: center

     *Add an Annotations*


Here the user can choose between five different types of *Geometries*:

1. *Marker*
2. *Line*
3. *Polygon*
4. *Text*
5. *Circle* 

See the `MapStore Documentation <https://docs.mapstore.geosolutionsgroup.com/en/latest/user-guide/annotations/>`_ for more information.